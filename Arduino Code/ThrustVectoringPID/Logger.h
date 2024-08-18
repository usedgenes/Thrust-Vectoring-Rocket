#ifndef PID_H_
#define PID_H_

#include "SD.h"
#include "SPI.h"

class Logger {
#define SD_SCK = -1;
#define SD_MISO = -1;
#define SD_MOSI = -1;
#define SD_CS = -1;

#define FILE_PATH "/Logs.txt"

private:
public:
  void Init();
  void log(String message);
};

#endif