#include "Bluetooth.h"
#include "IMU.h"
#include "Servos.h"
#include "Altimeter.h"
#include "Calculations.h"
#include "Logger.h"
#include "PID.h"
#include "Utilities.h"

#define SPI1_SCK 5
#define SPI1_MISO 16
#define SPI1_MOSI 17
#define SPI1_CS 21
#define SPI2_SCK 27
#define SPI2_MISO 25
#define SPI2_MOSI 26
#define SPI2_CS 33

#define BLUETOOTH_REFRESH_THRESHOLD 50
#define LAUNCH_ALTITUDE_THRESHOLD_METERS 4
#define MOTOR_BURN_TIME_MILLISECONDS 100000
#define PARACHUTE_EJECTION_VELOCITY_THRESHOLD 3
#define RECOVERY_ALTITUDE_THRESHOLD_METERS 1000

#define ON_PAD_DATA_FREQUENCY 1000
#define TVC_ACTIVE_DATA_FREQUENCY 1000
#define COASTING_DATA_FREQUENCY 1000
#define PARACHUTE_OUT_DATA_FREQUENCY 1000
#define ON_GROUND_DATA_FREQUENCY 1000

#define RAD_TO_DEG 57.29577
#define DEG_TO_RAD 0.01745

SPIClass* vspi = NULL;
SPIClass* hspi = NULL;

Bluetooth bluetooth;
IMU imu;
Servos servos;
Altimeter altimeter;
Calculations kalmanX, kalmanY;
Logger logger;
PID pitchPID, rollPID;
Utilities utilities;

unsigned long currentTime = 0;
unsigned long previousTime = 0;
unsigned long loopTime = 0;

unsigned long lastDataLog = 0;

float currentAltitude = 0;
float currentTemperature = 0;
float currentPressure = 0;
float launchAltitude = 0;
unsigned long motorIgnitionTime = 0;
float previousAltitude = 0;

float accelerometer[] = { 0, 0, 0 };
float gyroscope[] = { 0, 0, 0 };

double roll, pitch;
double kalAngleX, kalAngleY;
double adjustedKalAngleX;

float pitchCommand = 0, rollCommand = 0;
float servo0Position = 0, servo1Position = 0;
float apogee = 0;

bool sendBluetoothData = false;
bool bluetoothConnected = false;
bool armed = false;
bool bluetoothBypassOnPad = false;
bool bluetoothBypassTVCActive = false;
bool bluetoothBypassCoasting = false;
bool bluetoothBypassParachuteOut = false;
bool sendLoopTime = false;
bool sendBluetoothBMI088 = false;
bool sendBluetoothAltimeter = false;
bool sendBluetoothPID = false;
bool sendBluetoothOrientation = false;
bool sendBluetoothServo = false;

void setup() {
  Serial.begin(115200);
  bluetooth.Init(&servos, &imu, &altimeter, &pitchPID, &rollPID, &armed, &bluetoothConnected, &sendLoopTime, &sendBluetoothBMI088, &sendBluetoothOrientation, &sendBluetoothAltimeter, &sendBluetoothPID, &bluetoothBypassOnPad, &bluetoothBypassTVCActive, &bluetoothBypassCoasting, &bluetoothBypassParachuteOut, &sendBluetoothServo);
  while (!bluetoothConnected) {
    delay(1000);
  }
  vspi = new SPIClass(VSPI);
  hspi = new SPIClass(HSPI);
  vspi->begin(SPI1_SCK, SPI1_MISO, SPI1_MOSI, SPI1_CS);
  hspi->begin(SPI2_SCK, SPI2_MISO, SPI2_MOSI, SPI2_CS);
  // utilities.Init();
  kalmanX.Init();
  kalmanY.Init();
  servos.Init();
  pitchPID.Init(45, 0.5, 15);
  rollPID.Init(45, 0.5, 15);
  pitchPID.setSetpoint(0);
  rollPID.setSetpoint(0);
  if (!imu.Init(*hspi)) {
    bluetooth.writeUtilitiesNotifications("IMU Initialization Error");
    Serial.println("IMU Initialization Error");
    while (1) {}
  }
  if (!altimeter.Init(vspi)) {
    bluetooth.writeUtilitiesNotifications("Altimeter Initialization Error");
    Serial.println("BMP390 Initialization Error");
    while (1) {}
  }
  if (!logger.Init(*vspi)) {
    bluetooth.writeUtilitiesNotifications("SD Initialization Error");
    Serial.println("SD Initialization Error");
  }

  // utilities.initialized();

  while (!armed) {
    dataLoop();
    logData(ON_PAD_DATA_FREQUENCY);
  }

  roll = atan2(accelerometer[1], accelerometer[2]) * RAD_TO_DEG;
  pitch = atan(-accelerometer[0] / sqrt(accelerometer[1] * accelerometer[1] + accelerometer[2] * accelerometer[2])) * RAD_TO_DEG;
  kalmanX.setAngle(roll);  // Set starting angle
  kalmanY.setAngle(pitch);

  previousTime = 0;
  launchAltitude = altimeter.getAltitude();
  bluetooth.writeUtilitiesNotifications("Launch Altitude: " + String(launchAltitude));
  logger.logEvent("Launch Altitude: " + String(launchAltitude) + ", " + String(millis()));
  Serial.println("Launch Altitude: " + String(launchAltitude));

  // utilities.armed();
  bluetooth.writeUtilitiesEvents("On Pad");
  logger.logEvent("On Pad, " + String(millis()));
  Serial.println("On Pad");
  while (altimeter.getFilteredAltitude() - launchAltitude < LAUNCH_ALTITUDE_THRESHOLD_METERS && !bluetoothBypassOnPad) {
    onPad();
  }

  motorIgnitionTime = millis();
  bluetooth.writeUtilitiesEvents("TVC Active");
  logger.logEvent("TVC Active, " + String(millis()));
  Serial.println("Thrust Vector Active");
  while (millis() - motorIgnitionTime < MOTOR_BURN_TIME_MILLISECONDS && !bluetoothBypassTVCActive) {
    thrustVectorActive();
  }

  bluetooth.writeUtilitiesEvents("Coasting");
  logger.logEvent("Coasting, " + String(millis()));
  Serial.println("Coasting");
  while ((altimeter.getFilteredAltitude() - previousAltitude) / loopTime < PARACHUTE_EJECTION_VELOCITY_THRESHOLD && !bluetoothBypassCoasting) {
    coasting();
  }

  logger.logEvent("Launch Altitude: " + String(currentAltitude) + ", " + String(millis()));
  deployParachute();

  bluetooth.writeUtilitiesEvents("Parachute Out");
  logger.logEvent("Parachute Out, " + String(millis()));
  Serial.println("Parachute Out");
  while (altimeter.getFilteredAltitude() - launchAltitude > RECOVERY_ALTITUDE_THRESHOLD_METERS && !bluetoothBypassParachuteOut) {
    parachuteOut();
  }

  bluetooth.writeUtilitiesEvents("Touchdown");
  logger.logEvent("Touchdown, " + String(millis()));
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
  pitchCommand = pitchPID.ComputeCorrection(kalAngleY * DEG_TO_RAD, loopTime);
  rollCommand = rollPID.ComputeCorrection(adjustedKalAngleX * DEG_TO_RAD, loopTime);
  servo0Position = servos.writeGimbalServoPosition(0, pitchCommand);
  servo1Position = servos.writeGimbalServoPosition(1, rollCommand);
  logger.logData("PID Log\t" + String(currentTime) + "\t" + String(pitchCommand) + "\t" + String(rollCommand));
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
  float dt = loopTime / 1000.0;

  imu.getIMUData(accelerometer, gyroscope);

  roll = atan2(accelerometer[1], accelerometer[2]) * RAD_TO_DEG;
  pitch = atan(-accelerometer[0] / sqrt(accelerometer[1] * accelerometer[1] + accelerometer[2] * accelerometer[2])) * RAD_TO_DEG;
  double gyroXrate = gyroscope[0] / 131.0;  // Convert to deg/s
  double gyroYrate = gyroscope[1] / 131.0;  // Convert to deg/s
  if ((roll < -90 && kalAngleX > 90) || (roll > 90 && kalAngleX < -90)) {
    kalmanX.setAngle(roll);
    kalAngleX = roll;
  } else {
    kalAngleX = kalmanX.getAngle(roll, gyroXrate, dt);  
  }
  if (abs(kalAngleX) > 90) {
    gyroYrate = -gyroYrate;  // Invert rate, so it fits the restriced accelerometer reading
  }
  kalAngleY = kalmanY.getAngle(pitch, gyroYrate, dt);
  if(kalAngleX < 0) {
    adjustedKalAngleX = kalAngleX + 180;
  } else {
    adjustedKalAngleX = kalAngleX - 180;
  }


  currentAltitude = altimeter.getAltitude();
  altimeter.getTempAndPressure(currentTemperature, currentPressure);
}

void logData(int dataLoggingFrequencyInMilliseconds) {
  if (millis() - lastDataLog >= dataLoggingFrequencyInMilliseconds) {
    lastDataLog = millis();
    if (sendBluetoothBMI088) {
      Serial.println("Sending Bluetooth BMI088");
      bluetooth.writeIMU("90" + String(accelerometer[0]));
      bluetooth.writeIMU("91" + String(accelerometer[1]));
      bluetooth.writeIMU("92" + String(accelerometer[2]));
      bluetooth.writeIMU("93" + String(gyroscope[0]));
      bluetooth.writeIMU("94" + String(gyroscope[1]));
      bluetooth.writeIMU("95" + String(gyroscope[2]));
    }
    if (sendBluetoothOrientation) {
      Serial.println("Sending Bluetooth Orientation");
      bluetooth.writeIMU("96" + String(kalAngleY));
      bluetooth.writeIMU("97" + String(kalAngleX));
    }
    if (sendBluetoothAltimeter) {
      Serial.println("Sending Bluetooth Altimeter");
      bluetooth.writeAltimeter("90" + String(currentAltitude));
      bluetooth.writeAltimeter("91" + String(currentTemperature));
      bluetooth.writeAltimeter("92" + String(currentPressure));
    }
    if (sendBluetoothPID) {
      Serial.println("Sending Bluetooth PID");
      bluetooth.writePID("90" + String(pitchCommand));
      bluetooth.writePID("91" + String(rollCommand));
    }
    if (sendLoopTime) {
      Serial.println("Sending Bluetooth Loop Time");
      bluetooth.writeUtilities("90" + String(loopTime));
    }
    if (sendBluetoothServo) {
      Serial.println("Sending Bluetooth Servo");
      bluetooth.writeServo("90" + String(servo0Position));
      bluetooth.writeServo("91" + String(servo1Position));
    }
    logger.logData("Data log\t" + String(currentTime) + "\t" + String(accelerometer[0]) + "\t" + String(accelerometer[1]) + "\t" + String(accelerometer[2]) + String(gyroscope[0]) + "\t" + String(gyroscope[1]) + "\t" + String(gyroscope[2]) + "\t" + String(currentAltitude));
    printToSerial();
  }
}

void printToSerial() {
  // Serial.println("Accelerometer: " + String(accelerometer[0]) + "\t" + String(accelerometer[1]) + "\t" + String(accelerometer[2]));
  // Serial.println("Gyroscope: " + String(gyroscope[0]) + "\t" + String(gyroscope[1]) + "\t" + String(gyroscope[2]));
  // Serial.println("Pitch: " + String(pitch) + "\tRoll: " + String(roll));
  Serial.println("Pitch: " + String(kalAngleY) + "\tRoll: " + String(adjustedKalAngleX));
  // Serial.println("Altitude: " + String(currentAltitude) + "\tTemperature: " + String(currentTemperature) + "\tPressure: " + String(currentPressure));
}