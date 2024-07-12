#include <ESP32Servo.h>

#define BMP_SCK 13
#define BMP_MISO 12
#define BMP_MOSI 11
#define BMP_CS 10

#define SEALEVELPRESSURE_HPA (1013.25)
Servo servoX;
Servo servoY;
int num;
void setup() {
  Serial.begin(115200);
  servoX.attach(27);
  servoY.attach(13);
  // Set up oversampling and filter initialization
}


void loop() {
  for(int i = 0; i <=360; i++) {
    servoX.write(10 * cos (3.14*i/180) + 100);
    servoY.write(10 * sin(3.14*i/180) + 100);
  }
  delay(10);
}
