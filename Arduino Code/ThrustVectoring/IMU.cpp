#include "IMU.h"

bool IMU::Init(SPIClass & _hspi) {
  hspi = _hspi;
  accel = new Bmi088Accel(hspi, ACCEL_CS);
  gyro = new Bmi088Gyro(hspi, GYRO_CS);
  int status;
  status = accel->begin();
  if (status < 0) {
    return false;
  }
  status = gyro->begin();
  if (status < 0) {
    return false;
  }
  getCorrectedIMU();
  digitalWrite(ACCEL_CS, HIGH);
  digitalWrite(GYRO_CS, HIGH);
  return true;
}

void IMU::getIMUData(float accelerometer[], float gyroscope[]) {
  accel->readSensor();
  gyro->readSensor();

  accelerometer[0] = accel->getAccelX_mss();
  accelerometer[1] = accel->getAccelY_mss();
  accelerometer[2] = accel->getAccelZ_mss();

  gyroscope[0] = gyro->getGyroX_rads();
  gyroscope[1] = gyro->getGyroY_rads();
  gyroscope[2] = gyro->getGyroZ_rads();
  digitalWrite(ACCEL_CS, HIGH);
  digitalWrite(GYRO_CS, HIGH);
}

void IMU::getCorrectedIMU() {
  float gyroscopeTemp[] = { 0, 0, 0 };
  int numberOfReadings = 100;
  for (int i = 0; i < numberOfReadings; i++) {
    gyro->readSensor();
    gyroscopeTemp[0] = gyro->getGyroX_rads();
    gyroscopeTemp[1] = gyro->getGyroY_rads();
    gyroscopeTemp[2] = gyro->getGyroZ_rads();
  }

  for (int i = 0; i < 3; i++) {
    gyroscopeCorrected[i] = gyroscopeTemp[i] / numberOfReadings;
  }

}


