#include "Arduino.h"
#include "Servo.h"

Servo servo;

#define MAX_SIGNAL 2000
#define MIN_SIGNAL 700
#define OPERATING_SIGNAL 1000

#define SERVO_PIN 3

void setup(){
	servo.attach(SERVO_PIN);

	// Arm ESC
	servo.writeMicroseconds(900);
 
	delay(3000);
  int val = 900;
  for(int i = 0; i < 5; i++){
    servo.writeMicroseconds(val);
    val += 50;
    delay(100);
  }
  
	 // Send min output
  //delay(2000);
	// Set operating speed
	//servo.writeMicroseconds(OPERATING_SIGNAL);
}

void loop(){}
