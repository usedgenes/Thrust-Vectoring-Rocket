#ifndef BLUETOOTH_H_
#define BLUETOOTH_H

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

  IMU* imu;
  Servos* servos;
  Altimeter* altimeter;
  Logger* logger;
  PID* thetaPID, phiPID;

  bool *armed;
public:
  void Init(IMU& imu, Servos& servos, Altimeter& altimeter, Logger& logger, PID& thetaPID, PID& phiPID);
};


class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer *pServer);
  void onDisconnect(BLEServer *pServer);
};


class ServoCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic);
};

class UtilitiesCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic);
};

class BMI088Callbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic);
};

class PIDCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic);
};


#endif