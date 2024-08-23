#include "Altimeter.h"

bool Altimeter::Init(SPIClass& vspi) {
  if (!bmp.begin_SPI(BMP_CS, vspi)) {  // software SPI mode
    return false;
  }
  bmp.setTemperatureOversampling(BMP3_OVERSAMPLING_8X);
  bmp.setPressureOversampling(BMP3_OVERSAMPLING_4X);
  bmp.setIIRFilterCoeff(BMP3_IIR_FILTER_COEFF_3);
  bmp.setOutputDataRate(BMP3_ODR_50_HZ);
  //first reading is usually garbage
  for (int i = 0; i < 5; i++) {
    bmp.performReading();
    delay(10);
    Serial.println("BMP Initial Readings: " + String(bmp.readAltitude(SEALEVELPRESSURE_HPA)));
  }
  previousAltitude = getAltitude();
  digitalWrite(BMP_CS, HIGH);
  return true;
}

void Altimeter::getReading(float& temperature, float& pressure, float& altitude) {
  digitalWrite(BMP_CS, LOW);
  while (!bmp.performReading()) {}
  temperature = bmp.temperature;
  pressure = bmp.pressure;
  altitude = bmp.readAltitude(SEALEVELPRESSURE_HPA);
  digitalWrite(BMP_CS, HIGH);
}

float Altimeter::getAltitude() {
  digitalWrite(BMP_CS, LOW);
  while (!bmp.performReading()) {}
  Serial.println("Altitude: " + String(bmp.readAltitude(SEALEVELPRESSURE_HPA)));
  return bmp.readAltitude(SEALEVELPRESSURE_HPA);
  digitalWrite(BMP_CS, HIGH);
}

void Altimeter::setLowpassFilterValues(float _cutoffFrequency, float initialAlpha) {
  float timeConstant = 1 / (6.283 * _cutoffFrequency);
  alpha = initialAlpha / (initialAlpha + timeConstant);
}

float Altimeter::getFilteredAltitude() {
  return (getAltitude() * alpha) + (previousAltitude * (1 - alpha));
}
