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
  for(int i = 0; i < 2; i++) {
    gimbalServos[i].write(gimbalServoStartingPosition[i]);
  }
}

void Servos::circleGimbalServos() {
  
}

void Servos::getGimbalServosStartingPositions(int output[]) {
  output[0] = gimbalServoStartingPosition[0];
  output[1] = gimbalServoStartingPosition[0];}

void Servos::setGimbalServosStartingPosition(int servoNumber, int position) {
  gimbalServoStartingPosition[servoNumber] = position;
}

void Servos::bluetoothWriteGimbalServoPosition(int servoNumber, int position) {
  gimbalServos[servoNumber].write(position);
}

float Servos::writeGimbalServoPosition(int servoNumber, float position) {
  if (position > maxPosition) {
    position = maxPosition;
  }
  if (position < -maxPosition) {
    position = -maxPosition;
  }
  gimbalServos[servoNumber].write(gimbalServoStartingPosition[servoNumber] + position);
  return position;
}

void Servos::openParachuteServo() {
  parachuteServo.write(parachuteServoOpenPosition);
}

void Servos::closeParachuteServo() {
  parachuteServo.write(parachuteServoClosedPosition);
}
