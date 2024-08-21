#ifndef SERVOS_H_
#define SERVOS_H

#include "ESP32Servo.h"

class Servos {
private:
  Servo servos[2];
  int servoPins[2] = { 0, 0 };
  int servoStartingPosition[4] = { 90, 90 };
  int maxPosition = 15;
public:
  String Init();
  float WriteServoPosition(int servoNumber, float position);
};


#endif