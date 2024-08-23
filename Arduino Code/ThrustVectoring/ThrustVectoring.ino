//change BMI088 G range
#include "Bluetooth.h"
#include "IMU.h"
#include "Servos.h"
#include "Altimeter.h"
#include "Calculations.h"
#include "Logger.h"
#include "PID.h"
#include "Utilities.h"

#define BLUETOOTH_REFRESH_THRESHOLD 50
#define LAUNCH_ALTITUDE_THRESHOLD_METERS 4
#define MOTOR_BURN_TIME_MILLISECONDS 3000
#define PARACHUTE_EJECTION_VELOCITY_THRESHOLD 3
#define RECOVERY_ALTITUDE_THRESHOLD_METERS 3

#define ON_PAD_DATA_FREQUENCY 0
#define TVC_ACTIVE_DATA_FREQUENCY 0
#define COASTING_DATA_FREQUENCY 0
#define PARACHUTE_OUT_DATA_FREQUENCY 0
#define ON_GROUND_DATA_FREQUENCY 0

Bluetooth bluetooth;
IMU imu;
Servos servos;
Altimeter altimeter;
Calculations calculations;
Logger logger;
PID pitchPID, rollPID;
Utilities utilities;

unsigned long currentTime = 0;
unsigned long previousTime = 0;
unsigned long loopTime = 0;

unsigned long lastDataLog = 0;

bool bluetoothConnected = false;
bool armed = false;

float currentAltitude;
float launchAltitude;
unsigned long motorIgnitionTime;
float previousAltitude;

float accelerometer[] = { 0, 0, 0 };
float gyroscope[] = { 0, 0, 0 };
float pitch, roll;
float pitchCommand, rollCommand;

void setup() {
  Serial.begin(115200);

  bluetooth.Init(servos, imu, altimeter, pitchPID, rollPID, armed, bluetoothConnected);
  servos.Init();
  pitchPID.Init(1, 0.5, 0.2);
  rollPID.Init(1, 0.5, 0.2);
  if (!imu.Init()) {
    bluetooth.writeUtilities("IMU Initialization Error");
    while (1) {}
  }
  if (!altimeter.Init()) {
    bluetooth.writeUtilities("Altimeter Initialization Error");
    while (1) {}
  }
  if (!logger.Init()) {
    bluetooth.writeUtilities("SD Initialization Error");
    while (1) {}
  }
  
  previousTime = 0;
  launchAltitude = altimeter.getAltitude();

  bluetooth.writeUtilities("Launch Altitude: " + String(launchAltitude));
  Serial.println("Launch Altitude: " + String(launchAltitude));

  bluetooth.writeUtilities("Flight Computer Initialized");

  // while (!armed) {
  //   delay(100);
  // }

  bluetooth.writeUtilities("Flight Computer Armed");

  while (altimeter.getAltitude() - launchAltitude < LAUNCH_ALTITUDE_THRESHOLD_METERS) {
    onPad();
  }

  motorIgnitionTime = millis();

  while (millis() - motorIgnitionTime < MOTOR_BURN_TIME_MILLISECONDS) {
    thrustVectorActive();
  }

  while ((altimeter.getAltitude() - previousAltitude) / loopTime < PARACHUTE_EJECTION_VELOCITY_THRESHOLD) {
    coasting();
  }

  deployParachute();

  while (altimeter.getAltitude() - launchAltitude > RECOVERY_ALTITUDE_THRESHOLD_METERS) {
    parachuteOut();
  }

  while (true) {
    touchdown();
  }
}

void loop() {
}

void onPad() {
  dataLoop();
  logData(ON_PAD_DATA_FREQUENCY);
}

void thrustVectorActive() {
  dataLoop();
  pitchCommand = pitchPID.ComputeCorrection(pitch, loopTime);
  rollCommand = rollPID.ComputeCorrection(roll, loopTime);
  servos.writeGimbalServoPosition(0, pitchCommand);
  servos.writeGimbalServoPosition(1, rollCommand);
  logger.log(PitchCommand, String(pitchCommand), currentTime);
  logger.log(RollCommand, String(rollCommand), currentTime);
  Serial.println("Pitch Command: " + String(pitchCommand));
  Serial.println("Roll Command: " + String(rollCommand));
  logData(TVC_ACTIVE_DATA_FREQUENCY);
}

void coasting() {
  dataLoop();
  logData(COASTING_DATA_FREQUENCY);
}

void deployParachute() {
  servos.openParachuteServo();
}

void parachuteOut() {
  dataLoop();
  logData(PARACHUTE_OUT_DATA_FREQUENCY);
}

void touchdown() {
  dataLoop();
  logData(ON_GROUND_DATA_FREQUENCY);
  utilities.readApogee();
}

void dataLoop() {
  currentTime = millis();
  loopTime = millis() - previousTime;
  previousTime = currentTime;

  imu.getIMUData(accelerometer, gyroscope);
  calculations.applyKalmanFilter(accelerometer, gyroscope, loopTime, pitch, roll);
  currentAltitude = altimeter.getFilteredAltitude();
}

void logData(int dataLoggingFrequencyInMilliseconds) {
  if (millis() - lastDataLog >= dataLoggingFrequencyInMilliseconds) {
    lastDataLog = millis();
    if (bluetoothConnected) {
      bluetooth.writeIMU("90" + String(accelerometer[0]));
      bluetooth.writeIMU("91" + String(accelerometer[1]));
      bluetooth.writeIMU("92" + String(accelerometer[2]));
      bluetooth.writeIMU("93" + String(gyroscope[0]));
      bluetooth.writeIMU("94" + String(gyroscope[1]));
      bluetooth.writeIMU("95" + String(gyroscope[2]));
      bluetooth.writeIMU("96" + String(pitch));
      bluetooth.writeIMU("96" + String(roll));

      bluetooth.writeAltimeter("90" + String(currentAltitude));

      bluetooth.writePID("90" + String(pitch));
      bluetooth.writePID("92" + String(roll));
      bluetooth.writePID("92" + String(pitchCommand));
      bluetooth.writePID("93" + String(rollCommand));
    }
    logger.log(AccelX, String(accelerometer[0]), currentTime);
    logger.log(AccelY, String(accelerometer[1]), currentTime);
    logger.log(AccelZ, String(accelerometer[2]), currentTime);
    logger.log(GyroX, String(accelerometer[0]), currentTime);
    logger.log(GyroY, String(accelerometer[1]), currentTime);
    logger.log(GyroZ, String(accelerometer[2]), currentTime);
    logger.log(Altitude, String(currentAltitude), currentTime);
    printToSerial();
  }
}

void printToSerial() {
  Serial.println("Accelerometer: " + String(accelerometer[0]) + "\t" + String(accelerometer[1]) + "\t" + String(accelerometer[2]));
  Serial.println("Gyroscope: " + String(gyroscope[0]) + "\t" + String(gyroscope[1]) + "\t" + String(gyroscope[2]));
  Serial.println("Pitch: " + String(pitch));
  Serial.println("Roll: " + String(roll));
  Serial.println("Altitude: " + String(currentAltitude));
}