#include "Bluetooth.h"

void Bluetooth::Init(IMU& _imu, Servos& _servos, Altimeter& _altimeter, Logger& _logger, PID& _thetaPID, PID& _phiPID)
  imu = _imu;
  servos = _servos;
  altimeter = _altimeter;
  logger = _logger;
  thetaPID = _thetaPID;
  phiPID = _phiPID;

  bool *armed;) {
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
}

// class MyServerCallbacks : public BLEServerCallbacks {
//   void onConnect(BLEServer *pServer) {
//     Serial.println("Connected");
//   };

//   void onDisconnect(BLEServer *pServer) {
//     Serial.println("Disconnected");
//     // resetFunc();
//   }
// };


// class ServoCallbacks : public BLECharacteristicCallbacks {
//   void onWrite(BLECharacteristic *pCharacteristic) {
//     String value = pCharacteristic->getValue();
//     if (value.substring(0, 1) == "0") {
//       servos->WriteServoPosition(0, value.substring(1, value.length()).toInt());
//     } else if (value.substring(0, 1) == "1") {
//       servos->WriteServoPosition(1, value.substring(1, value.length()).toInt());
//     }
//   }
// };

// class UtilitiesCallbacks : public BLECharacteristicCallbacks {
//   void onWrite(BLECharacteristic *pCharacteristic) {
//     String value = pCharacteristic->getValue();
//     if (value == "Arm") {
//       *armed = true;
//     }
//     if (value == "Disarmed") {
//       *armed = false;
//     }
//   }
// };

// class BMI088Callbacks : public BLECharacteristicCallbacks {
//   void onWrite(BLECharacteristic *pCharacteristic) {
//     String value = pCharacteristic->getValue();
//   }
// };

// class PIDCallbacks : public BLECharacteristicCallbacks {
//   void onWrite(BLECharacteristic *pCharacteristic) {
//     String value = pCharacteristic->getValue();
//     if (value.substring(0, 1) == "0") {
//       *phiPID.Kp = value.substring(1, value.indexOf(',')).toFloat();
//       *phiPID.Ki = value.substring(value.indexOf(',') + 1, value.indexOf('!')).toFloat();
//       *phiPID.Kd = value.substring(value.indexOf('!') + 1, value.length()).toFloat();
//     }
//     if (value.substring(0, 1) == "1") {
//       *thetaPID.Kp = value.substring(1, value.indexOf(',')).toFloat();
//       *thetaPID.Ki = value.substring(value.indexOf(',') + 1, value.indexOf('!')).toFloat();
//       *thetaPID.Kd = value.substring(value.indexOf('!') + 1, value.length()).toFloat();
//     }
//   }
// };
