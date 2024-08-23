#ifndef UTILITIES_H_
#define UTILITIES_H_

#include "Arduino.h"
#include "driver/adc.h"

class Utilities {
private:
#define BUZZER_PIN 5
#define MAX_BATTERY_VOLTAGE 8.4
#define MIN_BATTERY_VOLTAGE 7.4
#define R1 37000  //R1 resistance (in ohms)
#define R2 10000 //R2 resistance (in ohms)

public:
  //tone(pin, frequency, duration (ms))
  void initialized();
  float readVoltage();
  void readBatteryVoltage();
  void armed();
  void readApogee(int apogee);
};


#endif