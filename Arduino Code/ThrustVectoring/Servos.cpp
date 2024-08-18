#include "Servos.h"

void Servos::Init() {
  for (int i = 0; i < 2; i++) {
    servos[i].write(servoStartingPosition[i]);
    servos[i].attach(servoPins[i]);
    servos[i].write(servoStartingPosition[i]);
  }
}

float Servos::WriteServoPosition(int servoNumber, float position) {
  if (position > maxPosition) {
    position = maxPosition;
  }
  if (position < -maxPosition) {
    position = -maxPosition;
  }
  servos[servoNumber].write(servoStartingPosition[servoNumber] + position);
  return position;
}
