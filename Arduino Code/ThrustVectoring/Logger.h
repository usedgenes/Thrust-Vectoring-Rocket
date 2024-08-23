#ifndef LOGGER_H_
#define LOGGER_H_

#include "SD.h"
#include "SPI.h"

enum LogType {
  MotorThrust,
  Altitude,
  Accelerometer,
  Gyroscope,
  PID,
  Event,
};

class Logger {
#define SD_SCK 5
#define SD_MISO 16
#define SD_MOSI 17
#define SD_CS 18

private:
public:
  bool Init();
  void log(LogType type, String message, unsigned long time);
  void testLog();
};

#endif