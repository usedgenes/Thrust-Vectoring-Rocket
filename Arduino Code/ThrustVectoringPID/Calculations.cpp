#include "Calculations.h"
#include "Arduino.h"

void Calculations::applyKalmanFilter(float accelerometerInput[], float gyroInput[], int loopTime, float output[]) {
  loopTime = loopTime * 0.001;
  thetaModel = thetaModel - gyroInput[1] * 0.1;
  phiModel = phiModel + gyroInput[0] * 0.1;
  thetaSensor = atan2(accelerometerInput[0] / 9.8, accelerometerInput[2] / 9.8) / 2 / 3.141592654 * 360;
  phiSensor = atan2(accelerometerInput[1] / 9.8, accelerometerInput[2] / 9.8) / 2 / 3.141592654 * 360;
  P_theta_n = P_theta_p + Q;
  K_theta = P_theta_n / (P_theta_n + R);
  theta_n = theta_p - loopTime * gyroInput[1];
  theta_p = theta_n + K_theta * (thetaSensor - theta_n);
  P_theta_p = (1 - K_theta) * P_theta_n;

  P_phi_n = P_phi_p + Q;
  K_phi = P_phi_n / (P_phi_n + R);
  phi_n = phi_p + loopTime * gyroInput[0];
  phi_p = phi_n + K_phi * (phiSensor - phi_n);
  P_phi_p = (1 - K_phi) * P_phi_n;

  output[0] = theta_p;
  output[1] = phi_p;

#ifdef PRINT_COMPLEMENTARY_FILTER
  // Serial.print("Pitch: ");
  Serial.print(pitch);
  Serial.print("\t");
  // Serial.print("Roll: ");
  Serial.println(roll);
#endif
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
