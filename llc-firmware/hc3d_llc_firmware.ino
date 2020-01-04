
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

// Select target adapter before flashing
#define ADAPTER_TEMP_CTRL 0
#define ADAPTER_TEMP_SENSE 1
#define INPUT_DEV_TYPE_IN_TEMP 0
#define INPUT_DEV_TYPE_IN_TACH 1

#define ADAPTER ADAPTER_TEMP_CTRL

/*
 * Temp ctrl adapter config
 */

#if ADAPTER == ADAPTER_TEMP_CTRL
	#define OUTPUT_DEV_COUNT 3
	static float PWM_OUT_MIN[] = { .35f, .35f, .35f}; // Used as initial setpoint until data is received
	static float PWM_OUT_MAX[] = { 1.0f, 1.0f, 1.0f}; // Used for failsafe
	#define INPUT_DEV_COUNT 3
	#define INPUT_DEV_TYPE INPUT_DEV_TYPE_IN_TACH
#endif
/*
* Temp sense adapter config
*/

#if ADAPTER == ADAPTER_TEMP_SENSE
  // TODO
#endif

/*
 * End Per-Adapter config
 */


String lineIn = "";
static const int PINS_OUTPUT[] = {3, 9, 10}; // HW PWM only available on these pins due to AVR design
#if INPUT_DEV_TYPE == INPUT_DEV_TYPE_IN_TEMP
	static const int [] = {2, 3, 7, 8, 12, 13}; // All other pins
#elif INPUT_DEV_TYPE == INPUT_DEV_TYPE_IN_TACH
	static const int PINS_INPUT[] = {2, 3};  // Availble on Nano/Pro Mini AVR for interrupt
#endif

#define CMD_TIMEOUT 2000 // Application triggers max PWM failsafe for all outputs after inactivity on input

// Used in stage when waiting for a full line to be received
char cmd_char_buf;
char* cmd_line_buf;
unsigned long cmd_last_frame_received = 0;
// Contains the processed last cmd frame
static float cmd_frame_processed[INPUT_DEV_COUNT];

// Contains to-be-sent output data, sent in the last phase
static float cmd_out_buf = float[OUTPUT_DEV_COUNT];

#if INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_IN_TACH
	// Used for collecting tachometer readings
	unsigned long tach_total_duration[INPUT_DEV_COUNT]; // accumulates pulse width
	unsigned long tach_elaspsed_time_us_last[INPUT_DEV_COUNT];
	unsigned long tach_total_ticks[INPUT_DEV_COUNT];
	unsigned long tach_speed_rpm_calc[INPUT_DEV_COUNT];
#endif

#if INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_IN_TEMP
	// Include the libraries for reading temperature sensors
	#include <OneWire.h>
	#include <DallasTemperature.h>

	//TODO init OneWire using constructor OneWire(int pin)
	// TODO init DallasTemperature using constructor DallasTemperature(OneWire& one_wire_ref)
	OneWire* obj_one_wire[INPUT_DEV_COUNT]; // Tref0 on pin 2
	DallasTemperature* obj_dallas_temp_sensor[INPUT_DEV_COUNT];

#endif

void setup() {
	#if OUTPUT_DEV_COUNT > 0
		/*
			Setup PWM output on pin 10 (OCR1A) and 9 (OCR1B) (both use timer1)
			Should be ~25KHz
			Changing PWM is done by setting the register to 0-320
		*/

		/*
			Info

			pin 3 = OC2B (timer 2 PWM output B)
			pin 11 = OC2A (timer 2 PWM output A)
			pin 9 = OC1B (timer 1 PWM output B)
			pin 10 = OC1A (timer 1 PWM output A)
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

		pinMode(3, OUTPUT); //OCR2B
		TCCR2A = 0;                               // TC2 Control Register A
		TCCR2B = 0;                               // TC2 Control Register B
		TIMSK2 = 0;                               // TC2 Interrupt Mask Register
		TIFR2 = 0;                                // TC2 Interrupt Flag Register
		TCCR2A |= (1 << COM2B1) | (1 << WGM21) | (1 << WGM20);  // OC2B cleared/set on match when up/down counting, fast PWM
		TCCR2B |= (1 << WGM22) | (1 << CS21);     // prescaler 8
		OCR2A = 79;                               // TOP overflow value (Hz)
		OCR2B = 0;

	    /*
	     *  Populate initial cmd frame data and directly set intial PWM
	     */

		for(int i = 0; i < INPUT_DEV_COUNT ; i++){
			cmd_frame_processed[i] = PWM_OUT_MIN[i];
			set_pwm(PINS_OUTPUT[i], PWM_OUT_MIN[i]);
		}
	#endif

	#if INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_IN_TACH
		/*
		 * Setup interrupts for tachometers
		 */
		for(int i = 0; i < INPUT_DEV_COUNT; i++){
			switch(i){
			case 0:
				attachInterrupt(digitalPinToInterrupt(PINS_INPUT[i]), itr_tach0_on_falling, FALLING);
				break;
			case 1:
				attachInterrupt(digitalPinToInterrupt(PINS_INPUT[i]), itr_tach1_on_falling, FALLING);
				break;
			}
		}
	#elif INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_IN_TEMP
		// Instantiate a OneWire and DallasTemperature object for each temperature sensing device
		for(int i = 0; i < INPUT_DEV_COUNT; i++){
			obj_one_wire[i](PINS_INPUT[i]);
			obj_dallas_temp_sensor[i](&obj_one_wire[i]);
		}
	#endif

	Serial.begin(115200);
}

void loop() {

	// Stage 1 and 2 are only activated when output devices are present
	#if OUTPUT_DEV_COUNT > 0
		/*
		 * Stage 1: Decode incoming data; populate input_frame_processed so it can be processed later on
		 * - Will trigger failsafe condition when no cmd is received within timeout period (unless no first frame received yet)
		 * - Will manually set cmd_frame_processed values to max PWM when triggering failsafe
		 * - Will block until either a full line is received or a timeout occurs
		 */
		while(true){
			if(millis() < cmd_last_frame_received){
				// Timer overflow after 50 days, delete invalidated old time stamp
				cmd_last_frame_received = millis();
			}
			// Check if timeout is encountered
			// Does not trigger when no initial frame was received yet
			if(cmd_last_frame_received != 0 && millis() - cmd_last_frame_received > CMD_TIMEOUT){
				printf("Timeout of %lu millis, enabling failsafe.\n", millis() - cmd_last_frame_received);
				enable_failsafe();
				// Proceed to next stage
				break;
			}
			cmd_last_frame_received = millis();
			// Keep waiting if no data is available
			if(!Serial.available()) continue;

			cmd_char_buf = Serial.read();

			if(cmd_char_buf == '\n'){
				// End of input line, process it
				/*
				 * - Split into segments
				 * - Check if count matches with expected, otherwise truncate data
				 * - Parse each segment into float
				 */
				char str[] ="- This, a sample string.";
				char* segment;
				segment = strtok(str,",");
				int i = 0;
				while (segment != NULL)
				{
					float val;
					// Parse segment
					if (sscanf(segment, "%f", &val) != 1){
						printf ("Unable to parse: %s\n", segment);
					}
					cmd_frame_processed[i] = val;
					segment = strtok (NULL, ",");
					i++;
				}
				// Check if last processed segment index is in line with expected field count
				if(i+1 != OUTPUT_DEV_COUNT){
					printf("Did not expect %i frames in segment; enabling failsafe.\n", i+1);
					enable_failsafe();
				}
			}else{
				// Add character to receive buffer
				cmd_line_buf += cmd_char_buf;
			}
		}

		/*
		 * Stage 2: Apply the PWM setpoints defined in input_frame_processed
		 */

		for(int i = 0; i < OUTPUT_DEV_COUNT; i++){
			set_pwm(PINS_OUTPUT[i], cmd_frame_processed[i]);
		}
	#endif




	/*
	* Stage 3: Read data from sensors and respond over serial
	*/
	#if INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_IN_TACH
		// For each tachometric device, calculate average speed in RPM based on data gathered since the last calculation
		// Reset counters afterwards
		// Store results in tach_speed_rpm_calc
		for(int i = 0; i < INPUT_DEV_COUNT; i++){
			float freq = (1e6 / float(tach_total_duration[i]) * tach_total_ticks[i]) / 2;
			cmd_out_buf[i] = freq * 60;
			tach_total_ticks[i] = 0;
			tach_total_duration[i] = 0;
		}

	#elif INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_IN_TEMP
		for(int i = 0; i < INPUT_DEV_COUNT; i++){
		  obj_dallas_temp_sensor[i].requestTemperatures();
		  cmd_out_buf[i] = obj_dallas_temp_sensor[i].getTempCByIndex(0);
		}
	#endif


	#if INPUT_DEV_COUNT > 0
		// Send buffered output frame
		for(int i = 0; i < INPUT_DEV_COUNT; i++){
			Serial.print(cmd_out_buf[i]);
			if(i != INPUT_DEV_COUNT-1){
				Serial.print(",");
			}
			Serial.print("\n");
		}
	#endif

	// Run communication at ~1 Hz. Command timeout cannot be too close to this otherwise timeouts will trigger unexpectedly
	// TODO in case of slow temperature sensor polling, double check timings

	delay(1000);
}

#if INPUT_DEV_COUNT > 0 && INPUT_DEV_TYPE == INPUT_DEV_TYPE_IN_TACH
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

		if (current_time_us - tach_elaspsed_time_us_last[dev] > 20000){ // Prevent pulses less than 20k micros far.
			tach_total_duration[dev] += current_time_us - tach_elaspsed_time_us_last[dev];
			tach_elaspsed_time_us_last[dev] = current_time_us;
			tach_total_ticks[dev]++;
		}
	}
#endif

#if OUTPUT_DEV_COUNT > 0
	void enable_failsafe(){
		// Set failsafe PWM setpoints
		for(int i = 0; i < OUTPUT_DEV_COUNT; i++){
			cmd_frame_processed[i] = PWM_OUT_MAX[i];
		}
	}

	void set_pwm(int pin, float val){
		if(pin == 9 || pin == 10){
			// Scale between 0-320
			int registerValue = round(val * 320);

			if(pin == 10){
				OCR1A = registerValue;
			}else if(pin == 9){
				OCR1B = registerValue;
			}
		}else if(pin == 3){
			// Scale between 0-79
			int registerValue = round(val * 79);
			OCR2B = registerValue;
		}
	}
#endif
