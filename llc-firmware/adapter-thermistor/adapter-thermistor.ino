
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

// Choose adapter before compiling
#define ADAPTER ADAPTER_TEMP_CTRL


/*
 * Start Per-Adapter config
 */

#if ADAPTER == ADAPTER_TEMP_CTRL
  #define OUTPUT_COUNT 3
  static int[] PWM_OUT_MAX = { 1000, 1000, 1000} // Used for failsafe
  #define INPUT_COUNT = 3
  #define IN_DEVICE_TYPE DEVICE_TYPE_IN_TACH
#endif

#if ADAPTER == ADAPTER_TEMP_SENSE
  // TODO
  #define IN_DEVICE_TYPE DEVICE_TYPE_IN_TEMP
  // etc
#endif

char serialCharacter = 'B';



/*
 * End Per-Adapter config
 */

#define ADAPTER_TEMP_CTRL 0
#define ADAPTER_TEMP_SENSE 1
#define DEVICE_TYPE_IN_TEMP 0
#define DEVICE_TYPE_IN_TACH 1
String lineIn = "";
//static int[] PINS_OUTPUT_AVAILABLE = {3, 5, 6, 9, 10, 11}; // HW PWM only available on these pins due to AVR design
//static int[] PINS_INPUT_AVAILABLE = {2, 3, 7, 8, 12, 13};
 
void setup() {
  Serial.begin(115200);
  Serial.setTimeout(2000);
}

void loop() {
  /*
   * - wait up to 2 sec for data
   * - after 2 sec activate failsafe (max PWM output for all devices)"
   * 
   */
  lineIn = "";
  lineIn = Serial.readStringUntil('\n');
  if(lineIn == ""){
    // Timeout, activate failsafe
    // TODO iterate outputs, set all to minimum PWM
    for(int i = 0; i < OUTPUT_COUNT; i++){
      setPwmOut(i, PWM_OUT_MAX[i]);
    }
  }

  // Todo parse line
  float[] parsedInputFields = new float[INPUT_COUNT];
  while
  
  
  Serial.print(serialCharacter);
  Serial.print(",");
  for(int i = 0; i < 6; i++){
    Serial.print(analogRead(i));
    if(i != 6-1){
        Serial.print(",");
    }
  }
  Serial.print("\n");
  delay(1000);
}
