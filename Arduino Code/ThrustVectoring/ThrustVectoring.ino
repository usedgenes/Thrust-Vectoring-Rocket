#include "Bluetooth.h"
#include "IMU.h"
#include "Servos.h"
#include "Altimeter.h"
#include "Calculations.h"
#include "Logger.h"
#include "PID.h"

#define BLUETOOTH_REFRESH_THRESHOLD 50

Bluetooth bluetooth;
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


void setup() {
  Serial.begin(115200);
  previousTime = 0;

  // bluetooth.Init();
  servos.Init();
  //Kp, Ki, Kd
  thetaPID.Init(1, 0.5, 0.2);
  phiPID.Init(1, 0.5, 0.2);

  if(!imu.Init()) {
    while(1) {}
  }

  if(!altimeter.Init()) {
    while(1) {}

  }

  if(!logger.Init()) {
    while(1) {}
  }

  // pUtilities->setValue("Flight Computer Initialized");
  // pUtilities->notify();

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
    // pBMI088->setValue("90" + String(accelerometer[0]));
    // pBMI088->setValue("91" + String(accelerometer[1]));
    // pBMI088->setValue("92" + String(accelerometer[2]));
    // pBMI088->setValue("93" + String(gyroscope[0]));
    // pBMI088->setValue("94" + String(gyroscope[1]));
    // pBMI088->setValue("95" + String(gyroscope[2]));
    // pBMI088->notify();

    // pBMP390->setValue("90" + String(altitude));
    // pBMP390->notify();

    // pPID->setValue("90" + String(theta));
    // pPID->setValue("92" + String(phi));
    // pPID->setValue("92" + String(thetaCommand));
    // pPID->setValue("93" + String(phiCommand));

    // pServo->setValue("90" + String(servo0pos));
    // pServo->setValue("91" + String(servo1pos));
    bluetoothRefreshRate = 0;

    Serial.println("Theta: " + String(theta) + "\t Phi: " + String(phi));
  }

  // logger.log(AccelX, "Accel X: " + String(accelerometer[0]));
  // logger.log(AccelY, "Accel Y: " + String(accelerometer[1]));
  // logger.log(AccelZ, "Accel Z: " + String(accelerometer[2]));
  // logger.log(GyroX, "Gyro X: " + String(accelerometer[0]));
  // logger.log(GyroY, "Gyro Y: " + String(accelerometer[1]));
  // logger.log(GyroZ, "Gyro Z: " + String(accelerometer[2]));
}
