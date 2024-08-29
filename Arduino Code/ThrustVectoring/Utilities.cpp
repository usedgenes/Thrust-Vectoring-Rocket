#include "Utilities.h"

void Utilities::Init() {
  digitalWrite(BUZZER_PIN, LOW);
  adc1_config_width(ADC_WIDTH_12Bit);
  adc1_config_channel_atten(ADC1_CHANNEL_6, ADC_ATTEN_DB_11);  // using GPIO 34 wind direction
  adc1_config_channel_atten(ADC1_CHANNEL_3, ADC_ATTEN_DB_11);  // using GPIO 39 current
  adc1_config_channel_atten(ADC1_CHANNEL_0, ADC_ATTEN_DB_11);  // using GPIO 36 battery volts
}

void Utilities::readBatteryVoltage() {
  float adcValue = 0.0f;
  const float r1 = 50500.0f;  // R1 in ohm, 50K
  const float r2 = 10000.0f;  // R2 in ohm, 10k potentiometer
  float Vbatt = 0.0f;
  int printCount = 0;
  float vRefScale = (3.3f / 4096.0f) * ((r1 + r2) / r2);
  adc1_get_raw(ADC1_CHANNEL_0);  //read and discard
  for (int i = 0; i < 10; i++) {
    adcValue = float(adc1_get_raw(ADC1_CHANNEL_0));                                  //take a raw ADC reading
    KF_ADC_b.setProcessNoise((esp_timer_get_time() - TimePastKalman) / 1000000.0f);  //get time, in microsecods, since last readings
    adcValue = KF_ADC_b.updateEstimate(adcValue);                                    // apply simple Kalman filter
    Vbatt += adcValue * vRefScale;
    xSemaphoreTake(sema_CalculatedVoltage, portMAX_DELAY);
    CalculatedVoltage = Vbatt;
    xSemaphoreGive(sema_CalculatedVoltage);
  }
  Vbatt = Vbatt / 10;
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

float Utilities::readBatteryVoltageSimple() {
  //https://stackoverflow.com/questions/56833346/how-to-measure-battery-voltage-with-internal-adc-esp32
  long sum = 0;         // sum of samples taken
  float voltage = 0.0;  // calculated voltage
  float output = 0.0;   // output value

  for (int i = 0; i < 100; i++) {
    sum += adc1_get_raw(ADC1_CHANNEL_0);
    delayMicroseconds(1000);
  }
  // calculate the voltage
  voltage = sum / (float)500;
  voltage = (voltage * 1.1) / 4096.0;  // for internal 1.1v reference
  // use it with divider circuit
  voltage = voltage * (R1 + R2) / R2;
  //round to two decimal places
  voltage = roundf(voltage * 100) / 100;
  Serial.print("voltage: ");
  Serial.println(voltage, 2);

}