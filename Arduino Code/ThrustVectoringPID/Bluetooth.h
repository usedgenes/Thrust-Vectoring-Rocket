#ifndef BLUETOOTH_H_
#define BLUETOOTH_H

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

class Bluetooth {
#define DEVICE_NAME "ESP_32"
#define SERVICE_UUID "9a8ca9ef-e43f-4157-9fee-c37a3d7dc12d"
#define SERVO_UUID "f74fb3de-61d1-4f49-bd77-419b61d188da"
#define BMI088_UUID "56e48048-19da-4136-a323-d2f3e9cb2a5d"
#define PID_UUID "a979c0ba-a2be-45e5-9d7b-079b06e06096"
#define RESET_UUID "fb02a2fa-2a86-4e95-8110-9ded202af76b"

private:
public:
  void Init();
};

#endif