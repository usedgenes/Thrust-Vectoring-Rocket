#ifndef SERVOS_H_
#define SERVOS_H_

#include "ESP32Servo.h"

class Servos {
private:
  Servo gimbalServos[2];
  Servo parachuteServo;
  int gimbalServoPins[2] = { 0, 0 };
  int gimbalServoStartingPosition[4] = { 90, 90 };
  int maxPosition = 15;
  #define PARACHUTE_SERVO_OPEN_POSITION 140
  #define PARACHUTE_SERVO_CLOSED_POSITION 50
  #define PARACHUTE_SERVO_PIN -1
public:
  void Init();
  float writeGimbalServoPosition(int servoNumber, float position);
  void openParachuteServo();
  void closeParachuteServo();
};


#endif