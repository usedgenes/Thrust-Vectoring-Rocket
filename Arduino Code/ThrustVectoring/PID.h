#ifndef PID_H_
#define PID_H_

class PID {
#define MAX_PID_OUTPUT 0
#define MIN_PID_OUTPUT 0 
private:
  float setpoint = 0;
  float error = 0;
  float previousError = 0;
  float integrator = 0;

public:
  float Kp;
  float Ki;
  float Kd;
  void Init(float _Kp, float _Ki, float _Kd);
  float ComputeCorrection(float error, unsigned long loopTime);
  void setSetpoint(float _setpoint);
};

#endif  
