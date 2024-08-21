#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include "IMU.h"
#include "Servos.h"
#include "Altimeter.h"
#include "Calculations.h"
#include "Logger.h"
#include "PID.h"

#define DEVICE_NAME "ESP_32"
#define SERVICE_UUID "9a8ca9ef-e43f-4157-9fee-c37a3d7dc12d"
#define SERVO_UUID "f74fb3de-61d1-4f49-bd77-419b61d188da"
#define BMI088_UUID "56e48048-19da-4136-a323-d2f3e9cb2a5d"
#define PID_UUID "a979c0ba-a2be-45e5-9d7b-079b06e06096"
#define UTILITIES_UUID "fb02a2fa-2a86-4e95-8110-9ded202af76b"

#define BLUETOOTH_REFRESH_THRESHOLD 50

BLECharacteristic *pServo;
BLECharacteristic *pBMI088;
BLECharacteristic *pPID;
BLECharacteristic *pBMP390;
BLECharacteristic *pUtilities;

IMU imu;
Servos servos;
Altimeter altimeter;
Calculations calculations;
Logger logger;
PID thetaPID, phiPID;

int bluetoothRefreshRate = 0;
unsigned long previousTime = 0;
bool manualServoControl = false;
bool armed = false;
bool recieveBluetoothData = true;

// void (*resetFunc)(void) = 0;

class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer *pServer) {
    Serial.println("Connected");
  };

  void onDisconnect(BLEServer *pServer) {
    Serial.println("Disconnected");
    // resetFunc();
  }
};

class ServoCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if (value.substring(0, 1) == "0") {
      servos.WriteServoPosition(0, value.substring(1, value.length()).toInt());
    } else if (value.substring(0, 1) == "1") {
      servos.WriteServoPosition(1, value.substring(1, value.length()).toInt());
    }
  }
};

class UtilitiesCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
    if(value == "Arm") {
      armed = true;
    }
    if(value == "Disarmed") {
      armed = false;
    }
  }
};

class BMI088Callbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) {
    String value = pCharacteristic->getValue();
  }
};

class PIDCallbacks : public BLECharacteristicCallbacks {
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
  }
};

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

  pUtilities = pService->createCharacteristic(UTILITIES_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_WRITE);
  pUtilities->setCallbacks(new UtilitiesCallbacks());

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

  pUtilities->setValue(imu.Init());
  pUtilities->notify();

  pUtilities->setValue(altimeter.Init());
  pUtilities->notify();

  pUtilities->setValue(servos.Init());
  pUtilities->notify();

  pUtilities->setValue(logger.Init());
  pUtilities->notify();

  //Kp, Ki, Kd
  thetaPID.Init(1, 0.5, 0.2);
  phiPID.Init(1, 0.5, 0.2);

  pUtilities->setValue("Flight Computer Initialized");
  pUtilities->notify();

  while(!armed) {
    delay(10);
  }
}

void loop() {
  bluetoothRefreshRate += 1;
  unsigned long loopTime = millis() - previousTime;
  previousTime = millis();
  float temperature, pressure, altitude;
  altimeter.GetReading(temperature, pressure, altitude);
  float accelerometer[] = { 0, 0, 0 };
  float gyroscope[] = { 0, 0, 0 };
  imu.getIMUData(accelerometer, gyroscope);

  float theta, phi;
  calculations.applyKalmanFilter(accelerometer, gyroscope, loopTime, theta, phi);
  float thetaCommand = thetaPID.ComputeCorrection(theta, loopTime);
  float phiCommand = phiPID.ComputeCorrection(phi, loopTime);
  int servo0pos = -1;
  int servo1pos = -1;
  if (!manualServoControl) {
    int servo0pos = servos.WriteServoPosition(0, thetaCommand);
    int servo1pos = servos.WriteServoPosition(1, phiCommand);
  }

  if (bluetoothRefreshRate == BLUETOOTH_REFRESH_THRESHOLD && recieveBluetoothData) {
    pBMI088->setValue("90" + String(accelerometer[0]));
    pBMI088->setValue("91" + String(accelerometer[1]));
    pBMI088->setValue("92" + String(accelerometer[2]));
    pBMI088->setValue("93" + String(gyroscope[0]));
    pBMI088->setValue("94" + String(gyroscope[1]));
    pBMI088->setValue("95" + String(gyroscope[2]));
    pBMI088->notify();

    pBMP390->setValue("90" + String(altitude));
    pBMP390->notify();

    pPID->setValue("90" + String(theta));
    pPID->setValue("92" + String(phi));
    pPID->setValue("92" + String(thetaCommand));
    pPID->setValue("93" + String(phiCommand));

    pServo->setValue("90" + String(servo0pos));
    pServo->setValue("91" + String(servo1pos));
    bluetoothRefreshRate = 0;

    Serial.println("Theta: " + String(theta) + "\t Phi: " + String(phi));
  }

  logger.log(AccelX, "Accel X: " + String(accelerometer[0]));
  logger.log(AccelY, "Accel Y: " + String(accelerometer[1]));
  logger.log(AccelZ, "Accel Z: " + String(accelerometer[2]));
  logger.log(GyroX, "Gyro X: " + String(accelerometer[0]));
  logger.log(GyroY, "Gyro Y: " + String(accelerometer[1]));
  logger.log(GyroZ, "Gyro Z: " + String(accelerometer[2]));
}
