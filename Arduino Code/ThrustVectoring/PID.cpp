#include "PID.h"

void PID::Init(Constants _constants) {
  constants = _constants;
}

float PID::ComputeCorrection(float error, unsigned long loopTime) {
  if (loopTime == 0) {
    return 0;
  }
  float deltaTime = loopTime / 1000;
  integrator += error * deltaTime;
  float derivative = (error - previousError) / deltaTime;
  float output = (constants.Kp * error) + (constants.Ki * integrator) + (constants.Kd * derivative);

  previousError = error;

  if (output > MAX_PID_OUTPUT) {
    output = MAX_PID_OUTPUT;
  } else if (output < MIN_PID_OUTPUT) {
    output = MIN_PID_OUTPUT;
  }
  return output;
}