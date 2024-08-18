#include "SD.h"
#include "Logger.h"

void Logger::Init() {
  SPI.begin(SD_SCK, SD_MISO, SD_MOSI, SD_CS);
  SD.begin(SD_CS);
}

void Logger::log(LogType type, String message) {
  String filePath;
  switch (type) {
      case Altitude:
        filePath = ALTITUDE_PATH;
      case AccelX:
        filePath = ACCELX_PATH;
      case AccelY:
        filePath = ACCELY_PATH;
      case AccelZ:
        filePath = ACCELZ_PATH;
      case GyroX:
        filePath = GYROX_PATH;
      case GyroY:
        filePath = GYROY_PATH;
      case GyroZ:
        filePath = GYROZ_PATH;
    }

  File file = SD.open(filePath, FILE_APPEND);
  if (!file) {
    return;
  }
  const char* temp = message.c_str();
  file.print(temp);
  file.close();
}