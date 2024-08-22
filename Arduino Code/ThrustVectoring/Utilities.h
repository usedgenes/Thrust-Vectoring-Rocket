#ifndef UTILITIES_H_
#define UTILITIES_H_

class Utilities {
private:
#define BUZZER_PIN 5
#define MAX_BATTERY_VOLTAGE 8.4
#define MIN_BATTERY_VOLTAGE 7.4
#define R1 = 37000  //R1 resistance
#define R2 = 10000
  float R1 = 100000.0;  // resistance of R1 (100K)
  float R2 = 10000.0;   // resistance of R2 (10K)
public:
  //tone(pin, frequency, duration (ms))
  void initialized();
  void readVoltage();
};


#endif