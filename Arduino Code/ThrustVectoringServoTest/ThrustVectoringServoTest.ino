#include <ESP32Servo.h>
//bottom neutral is 90
//top neutral is 90
#define PI 3.141592
Servo servoX;
Servo servoY;
int num;
void setup() {
  Serial.begin(115200);
  servoX.attach(22);
  servoY.attach(23);
  // Set up oversampling and filter initialization
}


void loop() {
  for(num = 0; num <=360; num += 20) {
    servoX.write((15 *sin(3.14*num/180)) + 90);
    servoY.write((15 * cos(3.14*num/180)) + 90);
    delay(25);
  }
  num=0;
}
