#include "Servos.h"

void Servos::Init() {
  for (int i = 0; i < 2; i++) {
    gimbalServos[i].write(gimbalServoStartingPosition[i]);
    gimbalServos[i].attach(gimbalServoPins[i]);
    gimbalServos[i].write(gimbalServoStartingPosition[i]);
  }
  parachuteServo.write(PARACHUTE_SERVO_OPEN_POSITION);
  parachuteServo.attach(PARACHUTE_SERVO_PIN);
  parachuteServo.write(PARACHUTE_SERVO_OPEN_POSITION);
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
  parachuteServo.write(PARACHUTE_SERVO_OPEN_POSITION);
}

void Servos::closeParachuteServo() {
  parachuteServo.write(PARACHUTE_SERVO_CLOSED_POSITION);
}
