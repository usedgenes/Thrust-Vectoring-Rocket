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
  bool *armed;
  bool *bluetoothConnected;
  bool *sendBluetoothData;
  bool *bluetoothBypassOnPad;
  bool *bluetoothBypassTVCActive;
  bool *bluetoothBypassCoasting;
  bool *bluetoothBypassParachuteOut;
  bool *sendLoopTime;
  bool *sendBluetoothBMI088;
  bool *sendBluetoothOrientation;
  bool *sendBluetoothAltimeter;
  bool *sendBluetoothPID;

public:
  void Init(Servos &_servos, IMU &_imu, Altimeter &_altimeter, PID &_pitchPID, PID &_rollPID, bool *_armed, bool *_bluetoothConnected, bool *_sendLoopTime, bool *_sendBluetoothBMI088, bool *_sendBluetoothOrientation, bool *_sendBluetoothAltimeter, bool *sendBluetoothPID, bool *_bluetoothBypassOnPad, bool *_bluetoothBypassTVCActive, bool *_bluetoothBypassCoasting, bool *_bluetoothBypassParachuteOut);
  void writeServo(String message);
  void writePID(String message);
  void writeIMU(String message);
  void writeAltimeter(String message);
  void writeUtilitiesNotifications(String message);
  void writeUtilitiesEvents(String message);
  void writeUtilities(String message);
};


class MyServerCallbacks : public BLEServerCallbacks {
private:
  bool *bluetoothConnected;
public:
  MyServerCallbacks(bool *_bluetoothConnected) {
    bluetoothConnected = _bluetoothConnected;
  }
  void onConnect(BLEServer *pServer) {
    Serial.println("Connected");
    *bluetoothConnected = true;
  };
  void onDisconnect(BLEServer *pServer) {
    Serial.println("Disconnected");
    *bluetoothConnected = false;
  };
};

class UtilitiesCallbacks : public BLECharacteristicCallbacks {
private:
  bool *armed;
  bool *bluetoothBypassOnPad;
  bool *bluetoothBypassTVCActive;
  bool *bluetoothBypassCoasting;
  bool *bluetoothBypassParachuteOut;
  bool *sendLoopTime;
  bool *sendBluetoothBMI088;
  bool *sendBluetoothOrientation;
  bool *sendBluetoothAltimeter;
  bool *sendBluetoothPID;

public:
  void (*resetFunc)(void) = 0;
  UtilitiesCallbacks(bool *_armed, bool *_sendLoopTime, bool *_sendBluetoothBMI088, bool *_sendBluetoothOrientation, bool *_sendBluetoothAltimeter, bool *_sendBluetoothPID, bool *_bluetoothBypassOnPad, bool *_bluetoothBypassTVCActive, bool *_bluetoothBypassCoasting, bool *_bluetoothBypassParachuteOut) {
    armed = _armed;
    sendLoopTime = _sendLoopTime;
    sendBluetoothBMI088 = _sendBluetoothBMI088;
    sendBluetoothOrientation = _sendBluetoothOrientation;
    sendBluetoothAltimeter = _sendBluetoothAltimeter;
    sendBluetoothPID = _sendBluetoothPID;
    bluetoothBypassOnPad = _bluetoothBypassOnPad;
    bluetoothBypassTVCActive = _bluetoothBypassTVCActive;
    bluetoothBypassCoasting = _bluetoothBypassCoasting;
    bluetoothBypassParachuteOut = _bluetoothBypassParachuteOut;
  };
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value == "Arm") {
      *armed = true;
      pCharacteristic->setValue("Armed");
      pCharacteristic->notify();
    } else if (value == "Reset") {
      resetFunc();
    } else if (value == "Bypass Pad") {
      *bluetoothBypassOnPad = true;
    } else if (value == "Bypass TVC") {
      *bluetoothBypassTVCActive = true;
    } else if (value == "Bypass Coasting") {
      *bluetoothBypassCoasting = true;
    } else if (value == "Bypass Parachute") {
      *bluetoothBypassParachuteOut = true;
    } else if (value == "BMI088 Get") {
      *sendBluetoothBMI088 = true;
    } else if (value == "BMI088 Stop") {
      *sendBluetoothBMI088 = false;
    } else if (value == "Orientation Get") {
      *sendBluetoothOrientation = true;
    } else if (value == "Orientation Stop") {
      *sendBluetoothOrientation = false;
    } else if (value == "PID Get") {
      *sendBluetoothPID = true;
    } else if (value == "PID Stop") {
      *sendBluetoothPID = false;
    } else if (value == "Altimeter Get") {
      *sendBluetoothAltimeter = true;
    } else if (value == "Altimeter Stop") {
      *sendBluetoothAltimeter = false;
    } else if (value == "Time Get") {
      *sendLoopTime = true;
    } else if (value == "Time Stop") {
      *sendLoopTime = false;
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
    } else if (value.substring(0, 1) == "Open Parachute") {
      servos.openParachuteServo();
    } else if (value.substring(0, 1) == "Close Parachute") {
      servos.closeParachuteServo();
    } else if (value.substring(0, 1) == "4") {
      servos.bluetoothWriteGimbalServoPosition(0, value.substring(1, value.length()).toInt());
    } else if (value.substring(0, 1) == "5") {
      servos.bluetoothWriteGimbalServoPosition(1, value.substring(1, value.length()).toInt());
    } else if (value.substring(0, 1) == "6") {
      int output[] = { 0, 0 };
      servos.getGimbalServosStartingPositions(output);
      pCharacteristic->setValue("0" + String(output[0]) + "," + String(output[1]));
      pCharacteristic->notify();
    } else if (value.substring(0, 1) == "7") {
      servos.setGimbalServosStartingPosition(value.substring(1, 2).toInt(), value.substring(2, value.length()).toInt());
    } else if (value == "Get Max Position") {
      pCharacteristic->setValue("91" + servos.getMaxGimbalPosition());
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
  void onWrite(BLECharacteristic *pCharacteristic){};
};

class BMP390Callbacks : public BLECharacteristicCallbacks {
private:
  Altimeter altimeter;
public:
  BMP390Callbacks(Altimeter &_altimeter) {
    altimeter = _altimeter;
  };
  void onWrite(BLECharacteristic *pCharacteristic){};
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
      Serial.println("Pitch PID: " + String(pitchPID.Kp) + "\t" + String(pitchPID.Ki) + "\t" + String(pitchPID.Ki));
    }
    if (value.substring(0, 1) == "1") {
      rollPID.Kp = value.substring(1, value.indexOf(',')).toFloat();
      rollPID.Ki = value.substring(value.indexOf(',') + 1, value.indexOf('!')).toFloat();
      rollPID.Kd = value.substring(value.indexOf('!') + 1, value.length()).toFloat();
      Serial.println("Roll PID: " + String(rollPID.Kp) + "\t" + String(rollPID.Ki) + "\t" + String(rollPID.Ki));
    }
  };
};

#endif