#include <OneWire.h> 
#include <DallasTemperature.h>

OneWire oneWire0(2); // Tref0 on pin 2
DallasTemperature tempSensor0(&oneWire0);

OneWire oneWire1(3); // Tref1 on pin3
DallasTemperature tempSensor1(&oneWire1);

void setup(void) {
  Serial.begin(115200); 
  tempSensor0.begin(); 
  tempSensor1.begin();
} 

void loop(void) { 
  Serial.print("TREF,"); // Print adapter ID
  
  // Print temp 0
  tempSensor0.requestTemperatures();
  Serial.print(tempSensor0.getTempCByIndex(0));
  Serial.print(",");

  // Print temp 1
  tempSensor1.requestTemperatures();
  Serial.print(tempSensor1.getTempCByIndex(0));

  Serial.print("\n");
}
