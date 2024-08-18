#include "PID.h"

void PID::Init(Constants _constants) {
  constants = _constants;
}

float PID::ComputeCorrection(float error, unsigned long loopTime) {
  if (loopTime == 0) {
    return 0;
  }
  integrator += error * loopTime;
  float derivative = (error - previousError) / loopTime;
  float output = (constants.Kp * error) + (constants.Ki * integrator) + (constants.Kd * derivative);

  previousError = error;

  if (output > MAX_PID_OUTPUT) {
    output = MAX_PID_OUTPUT;
  } else if (output < MIN_PID_OUTPUT) {
    output = MIN_PID_OUTPUT;
  }
  return output;
}