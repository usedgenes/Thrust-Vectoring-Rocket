#ifndef ALTIMETER_H_
#define ALTIMETER_H_

#include <Adafruit_Sensor.h>
#include "Adafruit_BMP3XX.h"

class Altimeter {
#define BMP_SCK 5
#define BMP_MISO 16
#define BMP_MOSI 17
#define BMP_CS 21
#define SEALEVELPRESSURE_HPA (1013.25)
private:
  Adafruit_BMP3XX bmp;
  float previousAltitude;
  float alpha;
public:
  bool Init(SPIClass * vspi);
  void selectAltimeter();
  void getReading(float& temperature, float& pressure, float& altitude);
  void setLowpassFilterValues(float _cutoffFrequency, float initialAlpha);
  float getFilteredAltitude();
  float getAltitude();
};

#endif