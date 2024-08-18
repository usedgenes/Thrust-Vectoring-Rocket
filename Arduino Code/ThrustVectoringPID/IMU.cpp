#include "IMU.h"

void IMU::Init() {
  vspi.begin(SPI_SCK, SPI_MISO, SPI_MOSI, ACCEL_CS);
  accel = new Bmi088Accel(vspi, ACCEL_CS);
  gyro = new Bmi088Gyro(vspi, GYRO_CS);
  int status;
  status = accel->begin();
  if (status < 0) {
    Serial.println("Accel Initialization Error");
    while (1) {}
  }
  status = gyro->begin();
  if (status < 0) {
    Serial.println("Gyro Initialization Error");
    while (1) {}
  }
  getCorrectedIMU();
  Serial.println("IMU Initialized");
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

#ifdef PRINT_IMU_DATA
  // Serial.print("Accelerometer: ");
  // Serial.print("\t");
  Serial.print(accelerometer[0]);
  Serial.print("\t");
  Serial.print(accelerometer[1]);
  Serial.print("\t");
  Serial.println(accelerometer[2]);

  // Serial.print("Gyroscope: ");
  // Serial.print("\t");
  // Serial.print(gyroscope[0]);
  // Serial.print("\t");
  // Serial.print(gyroscope[1]);
  // Serial.print("\t");
  // Serial.println(gyroscope[2]);
#endif
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

#ifdef PRINT_CORRECTED_IMU
  Serial.print("Accelerometer Corrected: ");
  Serial.print("\t");
  Serial.print(accelerometerCorrected[0]);
  Serial.print("\t");
  Serial.print(accelerometerCorrected[1]);
  Serial.print("\t");
  Serial.println(accelerometerCorrected[2]);

  Serial.print("Gyroscope Corrected: ");
  Serial.print("\t");
  Serial.print(gyroscopeCorrected[0]);
  Serial.print("\t");
  Serial.print(gyroscopeCorrected[1]);
  Serial.print("\t");
  Serial.println(gyroscopeCorrected[2]);
#endif
}


