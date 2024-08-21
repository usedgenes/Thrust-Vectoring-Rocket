#include "PID.h"

void PID::Init(float _Kp, float _Ki, float _Kd) {
  Kp = _Kp;
  Ki = _Ki;
  Kd = _Kd;
}

float PID::ComputeCorrection(float rocketOrientation, unsigned long loopTime) {
  if (loopTime == 0) {
    return 0;
  }
  loopTime = loopTime / 1000;
  float error = setpoint - rocketOrientation;
  float deltaTime = loopTime / 1000;
  integrator += error * deltaTime;
  float derivative = (error - previousError) / deltaTime;
  float output = (Kp * error) + (Ki * integrator) + (Kd * derivative);

  previousError = error;

  return output;
}

void PID::setSetpoint(float _setpoint) {
  setpoint = _setpoint;
}