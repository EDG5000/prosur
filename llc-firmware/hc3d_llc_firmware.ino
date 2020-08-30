
/*
 * TODO
 * allow configuring types of devices and pin assignment
 *    in or out
 *    device type: temp, pwm. tach
 *    PWM min and PWM max in case of output device
 *
 * - set initial state: all devices to minimal PWM
 * - failsafe on input timeout (all output devices max PWM)
 * - continuously stream data from all input devices
 */

#define DEBUG
#define ADAPTER_RAD_FANS 0
#define ADAPTER_TEMP_A 1
#define ADAPTER_PUMP 2
#define ADAPTER_RELAY 3
#define INPUT_DEV_TYPE_TEMP 0
#define INPUT_DEV_TYPE_TACH 1
#define OUTPUT_DEV_TYPE_PWM 0
#define OUTPUT_DEV_TYPE_RELAY 1

/*
 * Select target adapter before flashing
 */
#define ADAPTER ADAPTER_RAD_FANS

/*
 * Temp ctrl adapter config
 */

#if ADAPTER == ADAPTER_RAD_FANS
	#define ADAPTER_ID "RAD_FANS"

	// Outputs configuration
	#define OUTPUT_DEV_COUNT 2
	#define OUTPUT_DEV_TYPE OUTPUT_DEV_TYPE_PWM
	float PWM_OUT_MIN[] = { 1.0f, 1.0f}; // Used as initial setpoint until data is received
	float PWM_OUT_MAX[] = { 1.0f, 1.0f}; // Used for failsafe

	// Inputs configuration
	#define INPUT_DEV_COUNT 2
	#define INPUT_DEV_TYPE INPUT_DEV_TYPE_TACH
#endif

/*
* Temp sense adapter config
*/

#if ADAPTER == ADAPTER_TEMP_A
	#define ADAPTER_ID "TEMP_A"

	// Outputs configuration
	#define OUTPUT_DEV_COUNT 0
	#define OUTPUT_DEV_TYPE OUTPUT_DEV_TYPE_PWM
	float PWM_OUT_MIN[] = { }; // Used as initial setpoint until data is received
	float PWM_OUT_MAX[] = { }; // Used for failsafe

	// Inputs configuration
	#define INPUT_DEV_COUNT 2
	#define INPUT_DEV_TYPE INPUT_DEV_TYPE_TEMP
#endif

/*
 * HE fan adapter config
 */
#if ADAPTER == ADAPTER_PUMP
	#define ADAPTER_ID "PUMP"

	// Outputs configuration
	#define OUTPUT_DEV_COUNT 1
	#define OUTPUT_DEV_TYPE OUTPUT_DEV_TYPE_PWM
	float PWM_OUT_MIN[] = { 1.0f }; // Used as initial setpoint until data is received
	float PWM_OUT_MAX[] = { 1.0f }; // Used for failsafe

	// Inputs configuration
	#define INPUT_DEV_COUNT 1
	#define INPUT_DEV_TYPE INPUT_DEV_TYPE_TACH
#endif

/*
 * Relay adapter config
 */
#if ADAPTER == ADAPTER_RELAY
	#define ADAPTER_ID "RELAY"

	// Outputs configuration
	#define OUTPUT_DEV_COUNT 3
	#define OUTPUT_DEV_TYPE OUTPUT_DEV_TYPE_RELAY
	float PWM_OUT_MIN[] = { }; // Used as initial setpoint until data is received
	float PWM_OUT_MAX[] = { }; // Used for failsafe

	// Inputs configuration
	#define INPUT_DEV_COUNT 0
#endif

/*
 * End Per-Adapter config
 */

// HW PWM only available on these pins due to AVR design.
// Pin 3 is currently not setup for PWM. Do not forget uncomment the PWM setup code for pin 3.
// This overlaps with tach 0 input pin, make sure to enable max 1. tachometer input in those cases!
const int PINS_OUTPUT[] = {9, 10, 3};
#if INPUT_DEV_TYPE == INPUT_DEV_TYPE_TEMP
	const int PINS_INPUT[] = {2, 3, 7, 8, 12, 13}; // All other pins
#elif INPUT_DEV_TYPE == INPUT_DEV_TYPE_TACH
	// Tachometer input only availble on these pins for Nano/Pro Mini AVR for interrupt
	const int PINS_INPUT[] = {2, 3};
#endif

//#define CMD_TIMEOUT 2000 // Application triggers max PWM failsafe for all outputs after inactivity on input
#define CMD_TIMEOUT 200000
#define CMD_INPUT_LINE_MAX 100
/*
 *  Used in stage when waiting for a full line to be received
 */
const char* cmd_cur_segment;
int cmd_char_buf;
int cmd_char_buf_index = 0;
char cmd_line_buf[CMD_INPUT_LINE_MAX];
unsigned long cmd_time_ms_last_data_recv = 0;
float cmd_in_buf[OUTPUT_DEV_COUNT];

// Contains to-be-sent output data, sent in the last phase
float cmd_out_buf[INPUT_DEV_COUNT];

int heartbeat = 1;

//boolean awaiting_newline = false; // Initial state or after failsafe

#if INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_TACH
	// Used for collecting tachometer readings
	unsigned long tach_total_duration[INPUT_DEV_COUNT]; // accumulates pulse width
	unsigned long tach_elaspsed_time_us_last[INPUT_DEV_COUNT];
	unsigned long tach_total_ticks[INPUT_DEV_COUNT];
	unsigned long tach_speed_rpm_calc[INPUT_DEV_COUNT];
#endif

#if INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_TEMP
	// Include the libraries for reading temperature sensors
	#include <OneWire.h>
	#include <DallasTemperature.h>

	//TODO init OneWire using constructor OneWire(int pin)
	// TODO init DallasTemperature using constructor DallasTemperature(OneWire& one_wire_ref)
	OneWire obj_one_wire[INPUT_DEV_COUNT]; // Tref0 on pin 2
	DallasTemperature obj_dallas_temp_sensor[INPUT_DEV_COUNT];

	//TODO test
	//OneWire* obj_one_wire; // Tref0 on pin 2
	//DallasTemperature* obj_dallas_temp_sensor;

#endif

void setup() {
	Serial.begin(115200);
	//Serial.println("Init.");
	pinMode(13, OUTPUT); // LED

	#if OUTPUT_DEV_COUNT > 0 && OUTPUT_DEV_TYPE == OUTPUT_DEV_TYPE_PWM
		/*
			Setup PWM output on pin 10 (OCR1A) and 9 (OCR1B) (both use timer1)
			Should be ~25KHz
			Changing PWM is done by setting the register to 0-320
		*/

		/*
			Info

			pin 3 = OC2B (timer 2 PWM output B)
			pin 11 = OC2A (timer 2 PWM output A)
			pin 10 = OC1B (timer 1 PWM output B)
			pin 9 = OC1A (timer 1 PWM output A)
			pin 5 = OC0B (timer 0 PWM output B)
			pin 6 = OC0A (timer 0 PWM output A)
		*/

		pinMode(9, OUTPUT);  //OCR1B
		pinMode(10, OUTPUT); //OCR1A

		TCCR1A = 0;            //clear timer registers
		TCCR1B = 0;
		TCNT1 = 0;

		TCCR1B |= _BV(CS10);   //no prescaler
		ICR1 = 320;            //PWM mode counts up 320 then down 320 counts (25kHz)

		//OCR1A = pwmA;          //0-320 = 0-100% duty cycle
		TCCR1A |= _BV(COM1A1); //output A clear rising/set falling

		//OCR1B = pwmB;          //0-320 = 0-100% duty cycle
		TCCR1A |= _BV(COM1B1); //output B clear rising/set falling

		TCCR1B |= _BV(WGM13);  //PWM mode with ICR1 Mode 10
		TCCR1A |= _BV(WGM11);  //WGM13:WGM10 set 1010

		/*
			Setup PWM output on pin 3 (OCR2B) (uses timer2)
			Should be ~25KHz
			Changing PWM is done by setting the register to 0-79
		*/
		// Disabled for now to allow using pin 3 for tachometer
		// Can be enabled anytime. Do not forget to also uncomment the pin in PINS_OUTPUT
		/*
		pinMode(3, OUTPUT); //OCR2B
		TCCR2A = 0;                               // TC2 Control Register A
		TCCR2B = 0;                               // TC2 Control Register B
		TIMSK2 = 0;                               // TC2 Interrupt Mask Register
		TIFR2 = 0;                                // TC2 Interrupt Flag Register
		TCCR2A |= (1 << COM2B1) | (1 << WGM21) | (1 << WGM20);  // OC2B cleared/set on match when up/down counting, fast PWM
		TCCR2B |= (1 << WGM22) | (1 << CS21);     // prescaler 8
		OCR2A = 79;                               // TOP overflow value (Hz)
		OCR2B = 0;
		*/

		//Serial.println("PWM registers set-up.");

	    /*
	     *  Populate initial cmd frame data and directly set intial PWM
	     */

		for(int i = 0; i < OUTPUT_DEV_COUNT ; i++){
			cmd_in_buf[i] = PWM_OUT_MIN[i];
			set_pwm(PINS_OUTPUT[i], PWM_OUT_MIN[i]);
		}

		//Serial.println("Initial PWM setpoints set.");

	#elif OUTPUT_DEV_COUNT > 0 && OUTPUT_DEV_TYPE == OUTPUT_DEV_TYPE_RELAY
		// Set all relay outputs to low initially, until a setpoint is received from hlc
		for(int i = 0; i < OUTPUT_DEV_COUNT; i++){
			pinMode(PINS_OUTPUT[i], OUTPUT);
			digitalWrite(PINS_OUTPUT[i], 0);
		}
	#endif

	#if INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_TACH
		/*
		 * Setup interrupts for tachometers
		 */
		for(int i = 0; i < INPUT_DEV_COUNT; i++){
			pinMode(PINS_INPUT[i], INPUT_PULLUP);
			switch(i){
			case 0:
				attachInterrupt(digitalPinToInterrupt(PINS_INPUT[i]), itr_tach0_on_falling, FALLING);
				break;
			case 1:
				attachInterrupt(digitalPinToInterrupt(PINS_INPUT[i]), itr_tach1_on_falling, FALLING);
				break;
			}
		}

	#elif INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_TEMP
		//Serial.println("Instantiating temperature sensors");
		// Instantiate a OneWire and DallasTemperature object for each temperature sensing device
		for(int i = 0; i < INPUT_DEV_COUNT; i++){
			obj_one_wire[i] = OneWire(PINS_INPUT[i]);
			obj_dallas_temp_sensor[i] = DallasTemperature(&obj_one_wire[i]);
		}
	#endif
}

void loop() {
	//Serial.println("Loop.");
	// Stage 1 and 2 are only activated when output devices are present
	#if OUTPUT_DEV_COUNT > 0
		/*
		 * Stage 1: Decode incoming data; populate input_frame_processed so it can be processed later on
		 * - Will trigger failsafe condition when no cmd is received within timeout period (unless no first frame received yet)
		 * - Will manually set cmd_frame_processed values to max PWM when triggering failsafe
		 * - Will block until either a full line is received or a timeout occurs
		 */
		while(true){
			//log("Awaiting serial data.");

			// Keep waiting if no data is available
			if(!Serial.available()){
				// No data is being sent. Proceed with next phase. If any output devices are defined,
				// they will use the initial defaults (PWM_MIN) values until data is received.
				break;
			}
			cmd_time_ms_last_data_recv = millis();
			cmd_char_buf = Serial.read();

			if(cmd_char_buf != '\n'/* && !awaiting_newline*/){
				// Add character to receive buffer
				if(cmd_char_buf_index + 2 > CMD_INPUT_LINE_MAX){
					// Discard character. Once host sends newline data will be accepted again.
					Serial.println("Input buffer size exceeded.");
					break;
					//enable_failsafe();
				}

				//Serial.println("Adding char:");
				cmd_line_buf[cmd_char_buf_index] = cmd_char_buf;
				cmd_line_buf[cmd_char_buf_index + 1] = '\n';
				cmd_char_buf_index++;
			}else if(cmd_char_buf == '\n'){

				//awaiting_newline = false;

				// End of input line, process it
				/*
				 * - Split into segments
				 * - Check if count matches with expected, otherwise enable failsafe
				 * - Parse each segment into float
				 */
				cmd_char_buf_index = 0;

				cmd_cur_segment = strtok(cmd_line_buf, ",");
				int i = 0;
				while (cmd_cur_segment != NULL)
				{
					// Parse segment, copy into processed input buffer
					cmd_in_buf[i] = atof(cmd_cur_segment);
					cmd_cur_segment = strtok(NULL, ",");
					i++;
				}

				// Reset the line buffer since we have extracted the data
				cmd_line_buf[0] = '\0';

				// Check if the amount of processed segments is in line with expected field count
				if(i != OUTPUT_DEV_COUNT){
					Serial.print("Did not expect ");
					Serial.print(i);
					Serial.println(" frames in segment.");
					//enable_failsafe();
					break;
				}
				// An input frame is now fully processed.
				// Proceed with next phase. cmd_in_buf will be populated with the received line or failsafe values.
				break;
			}
		}

		/*
		 * Stage 2: Apply the outputs defined in input_frame_processed
		 */
		#if OUTPUT_DEV_TYPE == OUTPUT_DEV_TYPE_PWM
			for(int i = 0; i < OUTPUT_DEV_COUNT; i++){
				set_pwm(PINS_OUTPUT[i], cmd_in_buf[i]);
			}
		#elif OUTPUT_DEV_TYPE == OUTPUT_DEV_TYPE_RELAY
			for(int i = 0; i < OUTPUT_DEV_COUNT; i++){
				digitalWrite(PINS_OUTPUT[i], ((int)cmd_in_buf[i]) == 1);
			}
		#endif
	#endif

	/*
	* Stage 3: Read data from sensors/process tachometer data
	*/
	#if INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_TACH
		// For each tachometric device, calculate average speed in RPM based on data gathered since the last calculation
		// Reset counters afterwards
		// Store results in tach_speed_rpm_calc
		for(int i = 0; i < INPUT_DEV_COUNT; i++){
			if(tach_total_ticks[i] != 0){
				cmd_out_buf[i] = tach_total_ticks[i];
				tach_total_ticks[i] = 0;
				tach_total_duration[i] = 0;
			}else{
				cmd_out_buf[i] = 0;
			}
		}

	#elif INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_TEMP
		for(int i = 0; i < INPUT_DEV_COUNT; i++){
		  obj_dallas_temp_sensor[i].requestTemperatures();
		  cmd_out_buf[i] = obj_dallas_temp_sensor[i].getTempCByIndex(0);
		}
	#endif

	/*
	 * Stage 4: Send out heartbeat to host, retransmit incoming buffer for verification and send data collected from input devices
	 */
	Serial.print(ADAPTER_ID);
	Serial.print(",");
	// Retransmit any output device setpoints back to master for additional verification
	if(OUTPUT_DEV_COUNT > 0){
		print_float_array(&cmd_in_buf[0], OUTPUT_DEV_COUNT);
	}

	if(INPUT_DEV_COUNT > 0){
		if(OUTPUT_DEV_COUNT > 0){
			Serial.print(",");
		}
		// Send buffered output frame
		print_float_array(&cmd_out_buf[0], INPUT_DEV_COUNT);
	}

	Serial.println();

	// Run communication at ~1 Hz. Command timeout cannot be too close to this otherwise timeouts will trigger unexpectedly
	// TODO in case of slow temperature sensor polling, double check timings
	// Blink LED
	digitalWrite(13, heartbeat == 1);
	heartbeat *= -1;
	delay(1000);
}

// Print array of floats in ASCII/CSV format
void print_float_array(float* data, int length){
	for(int i = 0; i < length; i++){
		Serial.print(data[i]);
		if(i != length-1){
			Serial.print(",");
		}
	}
}

#if INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_TACH
	/*
	 * Tachometer interrupts
	 */
	void itr_tach0_on_falling(){
		itr_on_falling(0);
	}

	void itr_tach1_on_falling(){
		itr_on_falling(1);
	}

	void itr_on_falling(uint8_t dev){
		volatile unsigned long current_time_us = micros();
			tach_total_ticks[dev]++;
	}
#endif

#if OUTPUT_DEV_COUNT > 0 && OUTPUT_DEV_TYPE == OUTPUT_DEV_TYPE_PWM
	/*void enable_failsafe(){
		// Set failsafe PWM setpoints
		for(int i = 0; i < OUTPUT_DEV_COUNT; i++){
			cmd_in_buf[i] = PWM_OUT_MAX[i];
		}
	}*/

	void set_pwm(int pin, float val){
		if(pin == 9 || pin == 10){
			// Scale between 0-320
			int registerValue = round(val * 320);

			if(pin == 9){
				OCR1A = registerValue;
			}else if(pin == 10){
				OCR1B = registerValue;
			}
		}else if(pin == 3){
			// Scale between 0-79
			int registerValue = round(val * 79);
			OCR2B = registerValue;
		}
	}
#endif

	/*
void enable_failsafe(){
	awaiting_newline = true;
}
*/

