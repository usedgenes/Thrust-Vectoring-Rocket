#include "Servos.h"

void Servos::Init() {
  for (int i = 0; i < 2; i++) {
    gimbalServos[i].write(gimbalServoStartingPosition[i]);
    gimbalServos[i].attach(gimbalServoPins[i]);
    gimbalServos[i].write(gimbalServoStartingPosition[i]);
  }
  parachuteServo.write(parachuteServoOpenPosition);
  parachuteServo.attach(PARACHUTE_SERVO_PIN);
  parachuteServo.write(parachuteServoOpenPosition);
}

void Servos::homeGimbalServos() {
  for (int i = 0; i < 2; i++) {
    gimbalServos[i].write(gimbalServoStartingPosition[i]);
  }
}

void Servos::circleGimbalServos() {
  Serial.println("Circling Gimbal");
  for (int num = 0; num <= 360; num += 20) {
    gimbalServos[0].write((maxGimbalPosition * sin(3.14 * num / 180)) + gimbalServoStartingPosition[0]);
    gimbalServos[1].write((maxGimbalPosition * cos(3.14 * num / 180)) + gimbalServoStartingPosition[1]);
    delay(25);
  }
}

int Servos::getMaxGimbalPosition() {
  return maxGimbalPosition;
}

void Servos::getGimbalServosStartingPositions(int output[]) {
  output[0] = gimbalServoStartingPosition[0];
  output[1] = gimbalServoStartingPosition[0];
}

void Servos::setGimbalServosStartingPosition(int servoNumber, int position) {
  gimbalServoStartingPosition[servoNumber] = position;
  Serial.println("Servo Starting Position: " + String(gimbalServoStartingPosition[0]) + " " + String(gimbalServoStartingPosition[1]));
}

void Servos::bluetoothWriteGimbalServoPosition(int servoNumber, int position) {
  gimbalServos[servoNumber].write(position);
  gimbalServos[0].write(100);
}

float Servos::writeGimbalServoPosition(int servoNumber, float position) {
  int pos = (int) position;
  if (pos > maxGimbalPosition) {
    pos = maxGimbalPosition;
  }
  if (pos < -maxGimbalPosition) {
    pos = -maxGimbalPosition;
  }
  gimbalServos[servoNumber].write(gimbalServoStartingPosition[servoNumber] + pos);
  return pos;
}

void Servos::openParachuteServo() {
  parachuteServo.write(parachuteServoOpenPosition);
  Serial.println("Opened Parachute");
}

void Servos::closeParachuteServo() {
  parachuteServo.write(parachuteServoClosedPosition);
  Serial.println("Closed Parachute");
}
