#ifndef IMU_H_
#define IMU_H_

#include "BMI088.h"

class IMU {
#define SPI_SCK 27
#define SPI_MISO 25
#define SPI_MOSI 26
#define ACCEL_CS 33
#define GYRO_CS 32
private:
  SPIClass hspi = SPIClass(HSPI);
  Bmi088Accel *accel;
  Bmi088Gyro *gyro;

  float gyroscopeCorrected[3] = { 0, 0, 0 };

public:
  bool Init();
  void getIMUData(float accelerometer[], float gyroscope[]);
  void getCorrectedIMU();
};

#endif