#include "Bluetooth.h"

void Bluetooth::Init(IMU& _imu, Servos& _servos, Altimeter& _altimeter, Logger& _logger, PID& _thetaPID, PID& _phiPID, bool& _armed) {
  imu = _imu;
  servos = _servos;
  altimeter = _altimeter;
  logger = _logger;
  thetaPID = _thetaPID;
  phiPID = _phiPID;
  armed = _armed;

  String devName = DEVICE_NAME;
  String chipId = String((uint32_t)(ESP.getEfuseMac() >> 24), HEX);
  devName += '_';
  devName += chipId;

  BLEDevice::init(devName.c_str());
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  BLEService *pService = pServer->createService(SERVICE_UUID);

  pServo = pService->createCharacteristic(SERVO_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_WRITE);
  pServo->setCallbacks(new ServoCallbacks(servos));

  pBMI088 = pService->createCharacteristic(BMI088_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_WRITE);
  pBMI088->setCallbacks(new BMI088Callbacks());

  pUtilities = pService->createCharacteristic(UTILITIES_UUID, BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_WRITE);
  pUtilities->setCallbacks(new UtilitiesCallbacks(armed));

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

void Bluetooth::writeUtilities(String message) {
  pUtilities->setValue(message);
  pUtilities->notify();
}
