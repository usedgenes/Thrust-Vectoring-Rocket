#include "Altimeter.h"

bool Altimeter::Init() {
  if (!bmp.begin_SPI(BMP_CS, BMP_SCK, BMP_MISO, BMP_MOSI)) {  // software SPI mode
    return false;
  }
  bmp.setTemperatureOversampling(BMP3_OVERSAMPLING_8X);
  bmp.setPressureOversampling(BMP3_OVERSAMPLING_4X);
  bmp.setIIRFilterCoeff(BMP3_IIR_FILTER_COEFF_3);
  bmp.setOutputDataRate(BMP3_ODR_50_HZ);
  //first reading is usually garbage
  for(int i = 0; i < 5; i++) {
    bmp.performReading();
  }
  return true;
}

float Altimeter::GetReading(float& temperature, float& pressure, float& altitude) {
  bmp.performReading();
  temperature = bmp.temperature;
  pressure = bmp.pressure;
  altitude = bmp.readAltitude(SEALEVELPRESSURE_HPA);
}

void Altimeter::setLowpassFilterValues(float _cutoffFrequency, float initialAlpha) {
  float timeConstant = 1/(6.283 * _cutoffFrequency);
  alpha = initialAlpha / (initialAlpha + timeConstant);
}

float Altimeter::getFilteredAltitude(float& currentAltitude) {
  return (currentAltitude * alpha) + (previousAltitude * (1 - alpha));
}
