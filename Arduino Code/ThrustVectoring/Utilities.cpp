#include "Utilities.h"

void Utilities::Init() {
  digitalWrite(BUZZER_PIN, LOW);
}

void Utilities::readBatteryVoltage() {
  float voltage = readVoltage();
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < static_cast<int>(voltage); j++) {
      tone(BUZZER_PIN, 440, 1000);
      delay(500);
      voltage = voltage * 10;
      voltage = static_cast<int>(voltage) % 10;
    }
    delay(1000);
  }
}

void Utilities::readApogee(int apogee) {
  int amountOfDigits;
  if (apogee < 10) {
    amountOfDigits = 1;
  } else if (apogee < 100) {
    amountOfDigits = 2;
  } else if (apogee < 1000) {
    amountOfDigits = 3;
  } else {
    amountOfDigits = 4;
  }
  int array[4] = { 0, 0, 0, 0 };
  int counter = 0;
  while (apogee > 0) {
    array[counter] = apogee % 10;
    apogee = apogee / 10;
    counter++;
  }
  for (int i = amountOfDigits - 1; i >= 0; i--) {
    int digit = array[i];
    if (digit == 0) {
      digit = 10;
    }
    for (int j = 0; j < digit; j++) {
      tone(BUZZER_PIN, 880, 150);
      delay(300);
    }
    delay(1000);
  }
}

void Utilities::initialized() {
  tone(BUZZER_PIN, 587, 1500);
}

void Utilities::armed() {
  tone(BUZZER_PIN, 587, 500);
  delay(1000);
  tone(BUZZER_PIN, 587, 500);
  delay(1000);
  tone(BUZZER_PIN, 587, 500);
}

float Utilities::readVoltage() {
  //https://stackoverflow.com/questions/56833346/how-to-measure-battery-voltage-with-internal-adc-esp32
  long sum = 0;         // sum of samples taken
  float voltage = 0.0;  // calculated voltage
  float output = 0.0;   // output value

  for (int i = 0; i < 500; i++) {
    sum += adc1_get_raw(ADC1_CHANNEL_0);
    delayMicroseconds(1000);
  }
  // calculate the voltage
  voltage = sum / (float)500;
  voltage = (voltage * 1.1) / 4096.0;  // for internal 1.1v reference
  // use it with divider circuit
  // voltage = voltage / (R2/(R1+R2));
  //round to two decimal places
  voltage = roundf(voltage * 100) / 100;
  Serial.print("voltage: ");
  Serial.println(voltage, 2);
  output = ((voltage - MIN_BATTERY_VOLTAGE) / (MAX_BATTERY_VOLTAGE - MIN_BATTERY_VOLTAGE)) * 100;
  if (output < 100)
    return output;
  else
    return 100.0f;
}