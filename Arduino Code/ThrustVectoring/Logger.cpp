#include "SD.h"
#include "Logger.h"

bool Logger::Init() {
  SPI.begin(SD_SCK, SD_MISO, SD_MOSI, SD_CS);
  if(!SD.begin(SD_CS)) {
    return false;
  }
  uint8_t cardType = SD.cardType();
  if (cardType == CARD_NONE) {
    return false;
  }
  Serial.println("SD Card Initialized");
  testLog();
  digitalWrite(SD_CS, HIGH);
  Serial.println("Yay");
  return true;
}


void Logger::log(LogType type, String message, unsigned long time) {
  SPI.begin(SD_SCK, SD_MISO, SD_MOSI, SD_CS);
  SD.begin(SD_CS);
  String filePath;
  switch (type) {
    case Altitude:
      filePath = "/Altitude.txt"
    case Accelerometer:
      filePath = "/Accelerometer.txt"
    case Gyroscope:
      filePath = "Gyroscope.txt";
    case Event:
      filePath = "/Event.txt";
  }
  File file = SD.open(filePath, FILE_WRITE);
  String log = String(time) + "\t" + message;
  file.println(log);
  file.close();
  digitalWrite(SD_CS, HIGH);
}