char serialCharacter = 'A';

void setup() {
  Serial.begin(115200);
}

void loop() {
  Serial.print(serialCharacter);
  Serial.print(",");
  for(int i = 0; i < 6; i++){
    Serial.print(analogRead(i));
    Serial.print(",");
  }
  Serial.print("\n");
  delay(1000);
}
