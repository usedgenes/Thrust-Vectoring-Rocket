#include "SD.h"
#include "Logger.h"

bool Logger::Init(SPIClass& _vspi) {
  vspi = _vspi;
  if (!SD.begin(SD_CS, vspi)) {
    isConnected = false;
    return false;
  }
  uint8_t cardType = SD.cardType();
  if (cardType == CARD_NONE) {
    isConnected = false;
    return false;
  }
  File file = SD.open("/TVC_DATA.txt", FILE_APPEND);
  digitalWrite(SD_CS, HIGH);
  isConnected = true;
  return true;
}

void Logger::logData(String message) {
  if (isConnected) {
    digitalWrite(SD_CS, LOW);
    file.println(message);
    digitalWrite(SD_CS, HIGH);
  }
}

void Logger::logEvent(String message) {
  if (isConnected) {
    digitalWrite(SD_CS);
    file.close();
    file = SD.open("\TVC_EVENTS.txt", FILE_APPEND);
    file.println(message);
    file.close();
    file = SD.open("/TVC_DATA.txt", FILE_APPEND);
    digitalWrite(SD_CS, HIGH);
  }
}

void Logger::stopLogging() {
  file.close();
}