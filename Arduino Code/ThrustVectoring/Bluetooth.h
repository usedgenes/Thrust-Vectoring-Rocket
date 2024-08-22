#ifndef BLUETOOTH_H_
#define BLUETOOTH_H_

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include "IMU.h"
#include "Servos.h"
#include "Altimeter.h"
#include "Logger.h"
#include "PID.h"

class Bluetooth {
#define DEVICE_NAME "ESP_32"
#define SERVICE_UUID "9a8ca9ef-e43f-4157-9fee-c37a3d7dc12d"
#define SERVO_UUID "f74fb3de-61d1-4f49-bd77-419b61d188da"
#define BMI088_UUID "56e48048-19da-4136-a323-d2f3e9cb2a5d"
#define PID_UUID "a979c0ba-a2be-45e5-9d7b-079b06e06096"
#define UTILITIES_UUID "fb02a2fa-2a86-4e95-8110-9ded202af76b"
private:
  BLECharacteristic *pServo;
  BLECharacteristic *pBMI088;
  BLECharacteristic *pPID;
  BLECharacteristic *pBMP390;
  BLECharacteristic *pUtilities;

  IMU imu;
  Servos servos;
  Altimeter altimeter;
  Logger logger;
  PID thetaPID;
  PID phiPID;
  bool armed;

public:
  void Init(IMU& _imu, Servos& _servos, Altimeter& _altimeter, Logger& _logger, PID& _thetaPID, PID& _phiPID, bool& _armed);
  void writeServo();
  void writePID();
  void writeIMU();
  void writeUtilities(String message);
};


class MyServerCallbacks : public BLEServerCallbacks {
  void (*resetFunc)(void) = 0;
  void onConnect(BLEServer *pServer) {
    Serial.println("Connected");
  };
  void onDisconnect(BLEServer *pServer) {
    Serial.println("Disconnected");
    resetFunc();
  };
};


class ServoCallbacks : public BLECharacteristicCallbacks {
  Servos servos;
  ServoCallbacks(Servos& _servos) {
    servos = _servos;
  };
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value.substring(0, 1) == "0") {
      servos.WriteServoPosition(0, value.substring(1, value.length()).toInt());
    } else if (value.substring(0, 1) == "1") {
      servos.WriteServoPosition(1, value.substring(1, value.length()).toInt());
    }
  };
};

class UtilitiesCallbacks : public BLECharacteristicCallbacks {
  bool armed;
  void (*resetFunc)(void) = 0;
  UtilitiesCallbacks(bool& _armed) {
    armed = _armed
  };
  void onWrite(BLECharacteristic *pCharacteristic) {
    void UtilitiesCallbacks::onWrite(BLECharacteristic * pCharacteristic) {
      String value = pCharacteristic->getValue();
      if (value == "Arm") {
        armed = true;
      }
      else if (value == "Disarmed") {
        armed = false;
      }
      else if (value == "Reset") {
        resetFunc();
      }
    }
  };
};

class BMI088Callbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
  };
};

class PIDCallbacks : public BLECharacteristicCallbacks {
  PID phiPID, thetaPID;
  PIDCallbacks(PID& _phiPID, PID& _thetaPID) {
    phiPID = _phiPID;
    thetaPID = _thetaPID;
  };
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value.substring(0, 1) == "0") {
      phiPID.Kp = value.substring(1, value.indexOf(',')).toFloat();
      phiPID.Ki = value.substring(value.indexOf(',') + 1, value.indexOf('!')).toFloat();
      phiPID.Kd = value.substring(value.indexOf('!') + 1, value.length()).toFloat();
    }
    if (value.substring(0, 1) == "1") {
      thetaPID.Kp = value.substring(1, value.indexOf(',')).toFloat();
      thetaPID.Ki = value.substring(value.indexOf(',') + 1, value.indexOf('!')).toFloat();
      thetaPID.Kd = value.substring(value.indexOf('!') + 1, value.length()).toFloat();
    }
  };
};

#endif