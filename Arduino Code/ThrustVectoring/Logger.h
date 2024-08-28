#ifndef LOGGER_H_
#define LOGGER_H_

#include "SD.h"
#include "SPI.h"

class Logger {
#define SD_SCK 5
#define SD_MISO 16
#define SD_MOSI 17
#define SD_CS 18

private:
  File file;
  SPIClass vspi;
  bool isConnected;
public:
  bool Init(SPIClass& vspi);
  void log(LogType type, String _message, unsigned long time);
  void logData();
  void logEvent();
  void stopLogging();
};

#endif