#ifndef CALCULATIONS_H_
#define CALCULATIONS_H_

#include "Arduino.h"

class Calculations {

private:
  //Kalman filter taken from https://github.com/TKJElectronics/KalmanFilter
  /* Kalman filter variables */
  float Q_angle;    // Process noise variance for the accelerometer
  float Q_bias;     // Process noise variance for the gyro bias
  float R_measure;  // Measurement noise variance - this is actually the variance of the measurement noise

  float angle;  // The angle calculated by the Kalman filter - part of the 2x1 state vector
  float bias;   // The gyro bias calculated by the Kalman filter - part of the 2x1 state vector
  float rate;   // Unbiased rate calculated from the rate and the calculated bias - you have to call getAngle to update the rate

  float P[2][2];  // Error covariance matrix - This is a 2x2 matrix

  //Lowpass filter for altitude
  float alpha;

public:
  // The angle should be in degrees and the rate should be in degrees per second and the delta time in seconds
  float getAngle(float newAngle, float newRate, float dt);

  void setAngle(float angle);  // Used to set angle, this should be set as the starting angle
  float getRate();             // Return the unbiased rate

  /* These are used to tune the Kalman filter */
  void setQangle(float Q_angle);
  /**
     * setQbias(float Q_bias)
     * Default value (0.003f) is in Kalman.cpp. 
     * Raise this to follow input more closely,
     * lower this to smooth result of kalman filter.
     */
  void setQbias(float Q_bias);
  void setRmeasure(float R_measure);

  float getQangle();
  float getQbias();
  float getRmeasure();
  
  void Init();
  void applyOffsets(float& pitch, float& roll);
};
#endif