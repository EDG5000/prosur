char serialCharacter = 'B';

void setup() {
  Serial.begin(115200);
}

void loop() {
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
