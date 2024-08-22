#include "StateMachine.h"

void StateMachine::Init(IMU& _imu, Servos& _servos, Altimeter& _altimeter, Logger& _logger, PID& _thetaPID, PID& _phiPID) {
  imu = _imu;
  servos = _servos;
  altimeter = _altimeter;
  logger = _logger;
  thetaPID = _thetaPID;
  phiPID = _phiPID;
}

void StateMachine::onPad() {
  logger.log();
}

void StateMachine::ThrustVectorActive() {

}

