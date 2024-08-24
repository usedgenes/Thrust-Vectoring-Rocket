#include "SD.h"
#include "Logger.h"

bool Logger::Init(SPIClass & _vspi) {
  vspi = _vspi;
  if(!SD.begin(SD_CS, vspi)) {
    return false;
  }
  uint8_t cardType = SD.cardType();
  if (cardType == CARD_NONE) {
    return false;
  }
  digitalWrite(SD_CS, HIGH);
  return true;
}

void Logger::log(LogType type, String _message, unsigned long time) {
  SD.begin(SD_CS, vspi);
  String filePath;
  switch (type) {
    case Altitude:
      filePath = "/Altitude.txt";
      break;
    case Accelerometer:
      filePath = "/Accelerometer.txt";
      break;
    case Gyroscope:
      filePath = "/Gyroscope.txt";
      break;
    case Events:
      filePath = "/Events.txt";
      break;
    case Pid:
      filePath = "/Pid.txt";
      break;
  }
  File file = SD.open(filePath, FILE_APPEND);
  String message = String(time) + "\t" + _message;
  file.println(message);
  file.close();
  digitalWrite(SD_CS, HIGH);
}