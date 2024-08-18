#include "IMU.h"
#include "Servos.h"
#include "Altimeter.h"
#include "Calculations.h"
#include "Logger.h"
#include "PID.h"
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

#define DEVICE_NAME "ESP_32"
#define SERVICE_UUID "9a8ca9ef-e43f-4157-9fee-c37a3d7dc12d"
#define SERVO_UUID "f74fb3de-61d1-4f49-bd77-419b61d188da"
#define BMI088_UUID "56e48048-19da-4136-a323-d2f3e9cb2a5d"
#define PID_UUID "a979c0ba-a2be-45e5-9d7b-079b06e06096"
#define RESET_UUID "fb02a2fa-2a86-4e95-8110-9ded202af76b"

#define PRINT_BLUETOOTH_SERVO
#define PRINT_BLUETOOTH_BMI088

BLECharacteristic *pServo;
BLECharacteristic *pBMI088;
BLECharacteristic *pPID;
BLECharacteristic *pBMP390;

IMU imu;
Servos servos;
Altimeter altimeter;
Calculations calculations;
Logger logger;
PID pitchPID, rollPID;
Constants pitchConstants = { .Kp = 10, .Kd = 0.5, .Ki = 0.0 };
Constants rollConstants = { .Kp = 10, .Kd = 0.5, .Ki = 0.0 };

void (*resetFunc)(void) = 0;

class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer *pServer) {
    Serial.println("Connected");
  };

  void onDisconnect(BLEServer *pServer) {
    Serial.println("Disconnected");
    resetFunc();
  }
};

class ServoCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value.substring(0, 1) == "0") {
      servos.WriteServoPosition(0, value.substring(1, value.length()).toInt());
#ifdef PRINT_BLUETOOTH_SERVO
      Serial.print("Writing servo0: ");
      Serial.println(value.substring(1, value.length()).toInt());
#endif
    } else if (value.substring(0, 1) == "1") {
      servos.WriteServoPosition(1, value.substring(1, value.length()).toInt());
#ifdef PRINT_BLUETOOTH_SERVO
      Serial.print("Writing servo1: ");
      Serial.println(value.substring(1, value.length()).toInt());
#endif
    }
    if (value.substring(0, 1) == "2") {
      pCharacteristic->setValue("3" + String(servo0pos));
      pCharacteristic->notify();
      pCharacteristic->setValue("4" + String(servo1pos));
    }
  }
};

class BMI088Callbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value.substring(0, 1) == "0") {
      pCharacteristic->setValue("7" + String(adjustedYaw, 2));
      pCharacteristic->notify();

      pCharacteristic->setValue("8" + String(adjustedPitch));
      pCharacteristic->notify();

      pCharacteristic->setValue("9" + String(adjustedRoll));
      pCharacteristic->notify();

#ifdef PRINT_BLUETOOTH_BMI088
      Serial.print("Writing bluetooth:");
      Serial.print("\t");
      Serial.print(adjustedYaw);
      Serial.print("\t");
      Serial.print(adjustedPitch);
      Serial.print("\t");
      Serial.println(adjustedRoll);
#endif
    }
    if (value.substring(0, 1) == "1") {
    }
  }
};

class PIDCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value.substring(0, 1) == "0") {
      rollConstants.Kp = value.substring(1, value.indexOf(',')).toFloat();
      rollConstants.Ki = value.substring(value.indexOf(',') + 1, value.indexOf('!')).toFloat();
      rollConstants.Kd = value.substring(value.indexOf('!') + 1, value.length()).toFloat();
#ifdef PRINT_BLUETOOTH_PID
      Serial.print("Roll: ");
      Serial.print("\t");
      Serial.print(rollConstants.Kp);
      Serial.print("\t");
      Serial.print(rollConstants.Ki);
      Serial.print("\t");
      Serial.println(rollConstants.Kd);
#endif
    }
    if (value.substring(0, 1) == "1") {
      pitchConstants.Kp = value.substring(1, value.indexOf(',')).toFloat();
      pitchConstants.Ki = value.substring(value.indexOf(',') + 1, value.indexOf('!')).toFloat();
      pitchConstants.Kd = value.substring(value.indexOf('!') + 1, value.length()).toFloat();
#ifdef PRINT_BLUETOOTH_PID
      Serial.print("Pitch: ");
      Serial.print("\t");
      Serial.print(pitchConstants.Kp);
      Serial.print("\t");
      Serial.print(pitchConstants.Ki);
      Serial.print("\t");
      Serial.println(pitchConstants.Kd);
#endif
    }
    if (value.substring(0, 1) == "2") {
      yawConstants.Kp = value.substring(1, value.indexOf(',')).toFloat();
      yawConstants.Ki = value.substring(value.indexOf(',') + 1, value.indexOf('!')).toFloat();
      yawConstants.Kd = value.substring(value.indexOf('!') + 1, value.length()).toFloat();
#ifdef PRINT_BLUETOOTH_PID
      Serial.print("Yaw: ");
      Serial.print("\t");
      Serial.print(yawConstants.Kp);
      Serial.print("\t");
      Serial.print(yawConstants.Ki);
      Serial.print("\t");
      Serial.println(yawConstants.Kd);
#endif
    }
    if (value.substring(0, 1) == "3") {
      pCharacteristic->setValue("4" + String(yawCommand, 3));
      pCharacteristic->notify();
      pCharacteristic->setValue("5" + String(pitchCommand, 3));
      pCharacteristic->notify();
      pCharacteristic->setValue("6" + String(rollCommand, 3));
      pCharacteristic->notify();
    }

    if(value.substring(0, 1) == "7") {
      if(pidOn == true) {
        pidOn = false;
      }
      else {
        pidOn = true;
      }
    }
  }
};


unsigned long previousTime = 0;

void setup() {
  Serial.begin(115200);
  String devName = DEVICE_NAME;
  String chipId = String((uint32_t)(ESP.getEfuseMac() >> 24), HEX);
  devName += '_';
  devName += chipId;

  BLEDevice::init(devName.c_str());
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  BLEService *pService = pServer->createService(SERVICE_UUID);

  pServo = pService->createCharacteristic(SERVO_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_WRITE);
  pServo->setCallbacks(new ServoCallbacks());

  pBMI088 = pService->createCharacteristic(BMI088_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_WRITE);
  pBMI088->setCallbacks(new BMI088Callbacks());

  pService->start();

  BLEAdvertising *pAdvertising = pServer->getAdvertising();

  BLEAdvertisementData adv;
  adv.setName(devName.c_str());
  pAdvertising->setAdvertisementData(adv);

  BLEAdvertisementData adv2;
  adv2.setCompleteServices(BLEUUID(SERVICE_UUID));
  pAdvertising->setScanResponseData(adv2);

  pAdvertising->start();

  previousTime = 0;

  imu.Init();
  servos.Init();
  altimeter.Init();
  calculations.Init();
  logger.Init();
  pitchPID.Init(pitchConstants);
  rollPID.Init(rollConstants);
}

void loop() {
  unsigned long loopTime = millis() - previousTime;
  previousTime = millis();
}




