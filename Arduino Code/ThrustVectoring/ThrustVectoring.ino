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
#define RECOVERY_ALTITUDE_THRESHOLD_METERS 1000

#define ON_PAD_DATA_FREQUENCY 500
#define TVC_ACTIVE_DATA_FREQUENCY 500
#define COASTING_DATA_FREQUENCY 500
#define PARACHUTE_OUT_DATA_FREQUENCY 500
#define ON_GROUND_DATA_FREQUENCY 500

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

float currentAltitude = 0;
float launchAltitude = 0;
unsigned long motorIgnitionTime = 0;
float previousAltitude = 0;

float accelerometer[] = { 0, 0, 0 };
float gyroscope[] = { 0, 0, 0 };
float pitch = 0, roll = 0;
float pitchCommand = 0, rollCommand = 0;
int apogee = 0;

void setup() {
  Serial.begin(115200);

  utilities.Init();
  bluetooth.Init(servos, imu, altimeter, pitchPID, rollPID, armed, bluetoothConnected);
  servos.Init();
  pitchPID.Init(1, 0.5, 0.2);
  rollPID.Init(1, 0.5, 0.2);
  if (!imu.Init()) {
    bluetooth.writeUtilities("IMU Initialization Error");
    Serial.println("IMU error");
    while (1) {}
  }
  if (!altimeter.Init()) {
    bluetooth.writeUtilities("Altimeter Initialization Error");
    Serial.println("BMP390 error");
    while (1) {}
  }
  if (!logger.Init()) {
    bluetooth.writeUtilities("SD Initialization Error");
    Serial.println("SD error");
    while (1) {}
  }
  previousTime = 0;
  launchAltitude = altimeter.getAltitude();

  bluetooth.writeUtilities("Launch Altitude: " + String(launchAltitude));
  logger.log(Event, "Launch Altitude: " + String(launchAltitude), millis());
  Serial.println("Launch Altitude: " + String(launchAltitude));

  // while (!armed) {
  //   delay(100);
  // }

  bluetooth.writeUtilities("Flight Computer Armed");

  Serial.println("On Pad");
  while (altimeter.getFilteredAltitude() - launchAltitude < LAUNCH_ALTITUDE_THRESHOLD_METERS) {
    onPad();
  }

  motorIgnitionTime = millis();

  Serial.println("Thrust Vector Active");
  while (millis() - motorIgnitionTime < MOTOR_BURN_TIME_MILLISECONDS) {
    thrustVectorActive();
  }

  Serial.println("Coasting");
  while ((altimeter.getFilteredAltitude() - previousAltitude) / loopTime < PARACHUTE_EJECTION_VELOCITY_THRESHOLD) {
    coasting();
  }

  deployParachute();

  Serial.println("Parachute Out");
  while (altimeter.getFilteredAltitude() - launchAltitude > RECOVERY_ALTITUDE_THRESHOLD_METERS) {
    parachuteOut();
  }

  Serial.println("Touchdown");
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
  utilities.readApogee(apogee);
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
    logger.log(Accelerometer, String(accelerometer[0]) + "\t" + String(accelerometer[1]) + "\t" + String(accelerometer[2]), currentTime);
    logger.log(Gyroscope, String(gyroscope[0]) + "\t" + String(gyroscope[1]) + "\t" + String(gyroscope[2]), currentTime);
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