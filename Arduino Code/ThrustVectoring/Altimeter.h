#ifndef ALTIMETER_H_
#define ALTIMETER_H_

// #include <Adafruit_Sensor.h>
// #include "Adafruit_BMP3XX.h"

class Altimeter {
#define BMP_SCK 13
#define BMP_MISO 12
#define BMP_MOSI 11
#define BMP_CS 10
#define SEALEVELPRESSURE_HPA (1013.25)
private:
// Adafruit_BMP3XX bmp;
public:
  void Init();
  float GetReading(float& temperature, float& pressure, float& altitude);
};

#endif