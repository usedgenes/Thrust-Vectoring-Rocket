#include "PID.h"

void PID::Init(float _Kp, float _Ki, float _Kd) {
  Kp = _Kp;
  Ki = _Ki;
  Kd = _Kd;
  Serial.println(String(Kp) + "\t" + String(Ki) + "\t" + String(Kd));
}

float PID::ComputeCorrection(float error, unsigned long loopTime) {
  if (loopTime == 0) {
    return 0;
  }
  float deltaTime = loopTime / 1000.0;
  integrator += error * deltaTime;
  float derivative = (error - previousError) / deltaTime;
  float output = (Kp * error) + (Ki * integrator) + (Kd * derivative);

  previousError = error;

  Serial.println(String(rocketOrientation) + "\t" + String(error) + "\t" + String(deltaTime) + "\t" + String(integrator) + "\t" + String(derivative) + "\t" + String(output));
  return output;
}

void PID::setSetpoint(float _setpoint) {
  setpoint = _setpoint;
}