#include "IMU.h"

bool IMU::Init() {
  vspi.begin(SPI_SCK, SPI_MISO, SPI_MOSI, ACCEL_CS);
  accel = new Bmi088Accel(vspi, ACCEL_CS);
  gyro = new Bmi088Gyro(vspi, GYRO_CS);
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
  return true;
}

void IMU::getIMUData(float accelerometer[], float gyroscope[]) {
  accel->readSensor();
  gyro->readSensor();

  accelerometer[0] = accel->getAccelX_mss();
  accelerometer[1] = accel->getAccelY_mss();
  accelerometer[2] = accel->getAccelZ_mss();

  gyroscope[0] = gyro->getGyroX_rads() - gyroscopeCorrected[0];
  gyroscope[1] = gyro->getGyroY_rads() - gyroscopeCorrected[1];
  gyroscope[2] = gyro->getGyroZ_rads() - gyroscopeCorrected[2];
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


