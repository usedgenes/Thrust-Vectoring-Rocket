// #include "SD.h"
// #include "Logger.h"

// void Logger::Init() {
//   SPI.begin(SD_SCK, SCK_MISO, SD_MOSI, SD_CS);
//   SD.begin(SD_CS);  
// }

// void Logger::log(String message) {
//   File file = SD.open(FILE_PATH, FILE_APPEND);
//   if (!file) {
//     return;
//   }
//   const char* temp = message.c_str();
//   file.print(temp);
//   file.close();
// }