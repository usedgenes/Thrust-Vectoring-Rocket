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
#define BMP390_UUID "94cbc7dc-ff62-4958-9665-0ed477877581"
#define PID_UUID "a979c0ba-a2be-45e5-9d7b-079b06e06096"
#define UTILITIES_UUID "fb02a2fa-2a86-4e95-8110-9ded202af76b"
private:
  BLECharacteristic *pServo;
  BLECharacteristic *pBMI088;
  BLECharacteristic *pPID;
  BLECharacteristic *pBMP390;
  BLECharacteristic *pUtilities;

  Servos servos;
  IMU imu;
  Altimeter altimeter;
  PID pitchPID;
  PID rollPID;
  bool armed;
  bool bluetoothConnected;

public:
  void Init(Servos &_servos, IMU &_imu, Altimeter &_altimeter, PID &_pitchPID, PID &_rollPID, bool &_armed, bool &_bluetoothConnected);
  void writeServo(String message);
  void writePID(String message);
  void writeIMU(String message);
  void writeAltimeter(String message);
  void writeUtilities(String message);
};


class MyServerCallbacks : public BLEServerCallbacks {
private:
  bool bluetoothConnected = false;
public:
  MyServerCallbacks(bool& _bluetoothConnected) {
    bluetoothConnected = _bluetoothConnected;
  }
  void onConnect(BLEServer *pServer) {
    Serial.println("Connected");
    bluetoothConnected = true;
  };
  void onDisconnect(BLEServer *pServer) {
    Serial.println("Disconnected");
    bluetoothConnected = false;
  };
};

class UtilitiesCallbacks : public BLECharacteristicCallbacks {
private:
  bool armed;
public:
  void (*resetFunc)(void) = 0;
  UtilitiesCallbacks(bool &_armed) {
    armed = _armed;
  };
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value == "Arm") {
      armed = true;
    } else if (value == "Disarmed") {
      armed = false;
    } else if (value == "Reset") {
      resetFunc();
    }
  };
};

class ServoCallbacks : public BLECharacteristicCallbacks {
private:
  Servos servos;
public:
  ServoCallbacks(Servos &_servos) {
    servos = _servos;
  };
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value.substring(0, 1) == "0") {
      servos.writeGimbalServoPosition(0, value.substring(1, value.length()).toInt());
    } else if (value.substring(0, 1) == "1") {
      servos.writeGimbalServoPosition(1, value.substring(1, value.length()).toInt());
    } else if (value.substring(0, 1) == "2") {
      servos.openParachuteServo();
    } else if (value.substring(0, 1) == "3") {
      servos.closeParachuteServo();
    }
  };
};

class BMI088Callbacks : public BLECharacteristicCallbacks {
private:
  IMU imu;
public:
  BMI088Callbacks(IMU &_imu) {
    imu = _imu;
  };
  void onWrite(BLECharacteristic *pCharacteristic) {
  };
};

class BMP390Callbacks : public BLECharacteristicCallbacks {
private:
  Altimeter altimeter;
public:
  BMP390Callbacks(Altimeter &_altimeter) {
    altimeter = _altimeter;
  };
  void onWrite(BLECharacteristic *pCharacteristic) {
  };
};

class PIDCallbacks : public BLECharacteristicCallbacks {
private:
  PID pitchPID, rollPID;
public:
  PIDCallbacks(PID &_pitchPID, PID &_rollPID) {
    pitchPID = _pitchPID;
    rollPID = _rollPID;
  };
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value.substring(0, 1) == "0") {
      pitchPID.Kp = value.substring(1, value.indexOf(',')).toFloat();
      pitchPID.Ki = value.substring(value.indexOf(',') + 1, value.indexOf('!')).toFloat();
      pitchPID.Kd = value.substring(value.indexOf('!') + 1, value.length()).toFloat();
    }
    if (value.substring(0, 1) == "1") {
      rollPID.Kp = value.substring(1, value.indexOf(',')).toFloat();
      rollPID.Ki = value.substring(value.indexOf(',') + 1, value.indexOf('!')).toFloat();
      rollPID.Kd = value.substring(value.indexOf('!') + 1, value.length()).toFloat();
    }
  };
};

#endif