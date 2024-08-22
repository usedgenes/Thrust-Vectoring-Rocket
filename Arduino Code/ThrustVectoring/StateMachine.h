#ifndef STATEMACHINE_H_
#define STATEMACHINE_H_

class StateMachine {
private:
  IMU imu;
  Servos servos;
  Altimeter altimeter;
  Logger logger;
  PID thetaPID, phiPID;
public:
  void Init(IMU& _imu, Servos& _servos, Altimeter& _altimeter, Logger& _logger, PID& _thetaPID, PID& _phiPID);

};

#endif