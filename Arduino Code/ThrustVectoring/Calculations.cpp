#include "Calculations.h"

void Calculations::Init() {
  Q_angle = 0.001f;
  Q_bias = 0.003f;
  R_measure = 0.03f;

  angle = 0.0f;  // Reset the angle
  bias = 0.0f;   // Reset bias

  P[0][0] = 0.0f;  // Since we assume that the bias is 0 and we know the starting angle (use setAngle), the error covariance matrix is set like so - see: http://en.wikipedia.org/wiki/Kalman_filter#Example_application.2C_technical
  P[0][1] = 0.0f;
  P[1][0] = 0.0f;
  P[1][1] = 0.0f;
}

// The angle should be in degrees and the rate should be in degrees per second and the delta time in seconds
float Calculations::getAngle(float newAngle, float newRate, float dt) {
  // Discrete Kalman filter time update equations - Time Update ("Predict")
  // Update xhat - Project the state ahead
  /* Step 1 */
  rate = newRate - bias;
  angle += dt * rate;

  // Update estimation error covariance - Project the error covariance ahead
  /* Step 2 */
  P[0][0] += dt * (dt * P[1][1] - P[0][1] - P[1][0] + Q_angle);
  P[0][1] -= dt * P[1][1];
  P[1][0] -= dt * P[1][1];
  P[1][1] += Q_bias * dt;

  // Discrete Kalman filter measurement update equations - Measurement Update ("Correct")
  // Calculate Kalman gain - Compute the Kalman gain
  /* Step 4 */
  float S = P[0][0] + R_measure;  // Estimate error
  /* Step 5 */
  float K[2];  // Kalman gain - This is a 2x1 vector
  K[0] = P[0][0] / S;
  K[1] = P[1][0] / S;

  // Calculate angle and bias - Update estimate with measurement zk (newAngle)
  /* Step 3 */
  float y = newAngle - angle;  // Angle difference
  /* Step 6 */
  angle += K[0] * y;
  bias += K[1] * y;

  // Calculate estimation error covariance - Update the error covariance
  /* Step 7 */
  float P00_temp = P[0][0];
  float P01_temp = P[0][1];

  P[0][0] -= K[0] * P00_temp;
  P[0][1] -= K[0] * P01_temp;
  P[1][0] -= K[1] * P00_temp;
  P[1][1] -= K[1] * P01_temp;

  return angle;
};

void Calculations::setAngle(float angle) {
  this->angle = angle;
};  // Used to set angle, this should be set as the starting angle
float Calculations::getRate() {
  return this->rate;
};  // Return the unbiased rate

/* These are used to tune the Kalman filter */
void Calculations::setQangle(float Q_angle) {
  this->Q_angle = Q_angle;
};
void Calculations::setQbias(float Q_bias) {
  this->Q_bias = Q_bias;
};
void Calculations::setRmeasure(float R_measure) {
  this->R_measure = R_measure;
};

float Calculations::getQangle() {
  return this->Q_angle;
};
float Calculations::getQbias() {
  return this->Q_bias;
};
float Calculations::getRmeasure() {
  return this->R_measure;
};

void Calculations::applyOffsets(float& pitch, float& roll) {
  pitch = pitch - 180;
  roll = roll - 180;
}

void Calculations::normalizeVector(float vector[]) {
  float sum = 0;
  for (int i = 0; i < 3; i++) {
    sum += vector[i] * vector[i];
  }

  sum = sqrt(sum);

  if (sum > 0) {
    for (int i = 0; i < 3; i++) {
      vector[i] = vector[i] / sum;
    }
  }

#ifdef PRINT_VECTOR_NORMALIZE
  Serial.print("Magnitude: ");
  Serial.println(sum);
  Serial.print("Vectors: ");
  Serial.print(vector[0]);
  Serial.print("\t");
  Serial.print(vector[1]);
  Serial.print("\t");
  Serial.println(vector[2]);
#endif
}

float Calculations::degToRad(float input) {
  return input / 57.29577;
}
