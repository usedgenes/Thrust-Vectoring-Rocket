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

void Servos::getGimbalServosStartingPositions(int output[]) {
  output[1] = gimbalServoStartingPosition[0];}

void Servos::setGimbalServosStartingPosition(int positions[]) {
  gimbalServoStartingPosition[0] = positions[0];
  gimbalServoStartingPosition[1] = positions[1]; 
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
