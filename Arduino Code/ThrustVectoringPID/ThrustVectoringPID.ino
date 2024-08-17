unsigned long previousTime = 0;

void setup() {
  Serial.begin(115200);
  previousTime = 0;
}

void loop() {
  unsigned long loopTime = millis() - previousTime;
  previousTime = millis();
}




