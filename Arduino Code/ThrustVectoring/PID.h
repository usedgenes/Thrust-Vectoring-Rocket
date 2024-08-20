#ifndef PID_H_
#define PID_H_

typedef struct {
  float Kp;
  float Kd;
  float Ki;
} Constants;

class PID {
#define MAX_PID_OUTPUT 0
#define MIN_PID_OUTPUT 0 
private:
  Constants constants;
  float setpoint = 0;
  float error = 0;
  float previousError = 0;
  float integrator = 0;

public:
  void Init(Constants _constants);
  float ComputeCorrection(float error, unsigned long loopTime);
  void setSetpoint(float _setpoint);
};

#endif  
