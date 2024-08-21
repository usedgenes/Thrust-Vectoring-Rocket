#ifndef LOGGER_H_
#define LOGGER_H_

#include "SD.h"
#include "SPI.h"

enum LogType {
  MotorThrust,
  Altitude,
  AccelX,
  AccelY,
  AccelZ,
  GyroX,
  GyroY,
  GyroZ,
};

class Logger {
#define SD_SCK -1
#define SD_MISO -1
#define SD_MOSI -1
#define SD_CS -1

#define ALTITUDE_PATH "/Altitude.txt"
#define ACCELX_PATH "/AccelX.txt"
#define ACCELY_PATH "/AccelY.txt"
#define ACCELZ_PATH "/AccelZ.txt"
#define GYROX_PATH "/GyroX.txt"
#define GYROY_PATH "/GyroY.txt"
#define GYROZ_PATH "/GyroZ.txt"

private:
public:
  bool Init();
  void log(LogType type, String message, unsigned long time);
};

#endif