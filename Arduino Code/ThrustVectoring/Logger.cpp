#include "SD.h"
#include "Logger.h"

bool Logger::Init(SPIClass & _vspi) {
  vspi = _vspi;
  Serial.println("SD Starting");
  if(!SD.begin(SD_CS, vspi)) {
    return false;
  }
  Serial.println("SD Initializing");
  uint8_t cardType = SD.cardType();
  if (cardType == CARD_NONE) {
    return false;
  }
  digitalWrite(SD_CS, HIGH);
  Serial.println("SD Initialized");
  return true;
}


void Logger::log(LogType type, String message, unsigned long time) {
  SD.begin(SD_CS, vspi);
  digitalWrite(SD_CS, LOW);
  String filePath;
  switch (type) {
    case Altitude:
      filePath = "/Altitude.txt";
    case Accelerometer:
      filePath = "/Accelerometer.txt";
    case Gyroscope:
      filePath = "Gyroscope.txt";
    case Events:
      filePath = "/Events.txt";
    case Pid:
      filePath = "/Pid.txt";
  }
  File file = SD.open(filePath, FILE_WRITE);
  String log = String(time) + "\t" + message;
  file.println(log);
  file.close();
  digitalWrite(SD_CS, HIGH);
}