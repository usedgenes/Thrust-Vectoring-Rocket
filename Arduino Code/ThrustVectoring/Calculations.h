#ifndef CALCULATIONS_H_
#define CALCULATIONS_H_

#include "Arduino.h"

class Calculations {
#define MAX_PID_OUTPUT 0
#define MIN_PID_OUTPUT 0
//Kalman Filter
#define Q 0.1
#define R 4
private:
  float angularVelocityX = 0;
  float angularyVelocityY = 0;
  float thetaModel = 0;
  float phiModel = 0;
  float thetaSensor = 0;
  float phiSensor = 0;

  float theta_n;      // a priori estimation of Theta
  float theta_p = 0;  // a posteriori estimation on Theta (set to zero for the initial time step k=0)
  float phi_n;        // a priori estimation of Phi
  float phi_p = 0;    // a posteriori estimation on Phi (set to zero for the initial time step k=0)

  float P_theta_n;      // a priori cobvariance of Theta
  float P_phi_n;        // a priori covariance of Phi
  float P_theta_p = 0;  // a posteriori covariance of Theta
  float P_phi_p = 0;    // a posteriori covariance of Phi

  float K_theta;  // Observer gain or Kalman gain for Theta
  float K_phi;    // Observer gain or Kalman gain for Phi
  //PID
  float integralError = 0;
  float previousError = 0;
  //Lowpass filter for altitude
  float alpha;

public:
  void applyKalmanFilter(float accelerometerInput[], float gyroInput[], int loopTime, float& theta, float& phi);
  void normalizeVector(float vector[]);
  float degToRad(float input);
};
#endif