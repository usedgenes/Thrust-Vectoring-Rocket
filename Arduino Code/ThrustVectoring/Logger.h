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
  void logData(String message);
  void logEvent(String message);
  void stopLogging();
};

#endif