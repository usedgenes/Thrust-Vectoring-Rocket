#ifndef SERVOS_H_
#define SERVOS_H_

#include "ESP32Servo.h"

class Servos {
private:
  #define PARACHUTE_SERVO_PIN 13
  Servo gimbalServos[2];
  Servo parachuteServo;
  int gimbalServoPins[2] = { 23, 22 };
  int gimbalServoStartingPosition[2] = { 90, 90 };
  int maxGimbalPosition = 15;
  int parachuteServoOpenPosition = 140;
  int parachuteServoClosedPosition = 50;
public:
  void Init();
  void getGimbalServosStartingPositions(int output[]);
  void setGimbalServosStartingPosition(int servoNumber, int position);
  void bluetoothWriteGimbalServoPosition(int servoNumber, int position);
  float writeGimbalServoPosition(int servoNumber, float position);
  void openParachuteServo();
  void closeParachuteServo();
  void homeGimbalServos();
  void circleGimbalServos();
  int getMaxGimbalPosition();
};


#endif