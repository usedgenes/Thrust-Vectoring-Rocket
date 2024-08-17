#include "SD.h"

void SD::Init() {
  SPI.begin(SD_SCK, SCK_MISO, SD_MOSI, SD_CS);
}