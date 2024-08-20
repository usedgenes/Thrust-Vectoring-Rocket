#include "PID.h"

void PID::Init(Constants _constants) {
  constants = _constants;
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
  float output = (constants.Kp * error) + (constants.Ki * integrator) + (constants.Kd * derivative);

  previousError = error;

  return output;
}

void PID::setSetpoint(float _setpoint) {
  setpoint = _setpoint;
}