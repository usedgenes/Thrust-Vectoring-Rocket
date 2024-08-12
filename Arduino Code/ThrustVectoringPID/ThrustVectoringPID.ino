#include <ESP32Servo.h>
#include <SD.h>
#include "BMI088.h"

#define PRINT_IMU_DATA 0
#define PRINT_CORRECTED_IMU 0
#define PRINT_SERVO_POSITION 0
#define PRINT_VECTOR_NORMALIZE 0

#define BMP_SCK 13
#define BMP_MISO 12
#define BMP_MOSI 11
#define BMP_CS 10
#define Kp 0
#define Ki 0
#define Kd 0

#define SERVO_X_PIN 0
#define SERVO_Y_PIN 0
#define SPI_SCK 0
#define SPI_MISO 0
#define SPI_MOSI 0
#define IMU_CS 0
#define COMPLEMENTARY_FILTER_CONSTANT 0
#define MAX_SERVO_POSITION 0
#define MIN_SERVO_POSITION 0

//add filters

SPIClass vspi = SPIClass(VSPI);
Bmi088Accel accel(vspi, 33);
Bmi088Gyro gyro(vspi, 32);
File myFile;
Servo servoX;
Servo ServoY;

float accelerometerCorrected[] = { 0, 0, 0 };
float gyroscopeCorrected[] = { 0, 0, 0 };

int servoStartingPosition[2] = { 10, 100 };
int servoPosition_X = 100;
int servoPosition_Y = 100;
int minPosition = 0;
int maxPosition = 60;

void setup() {
  initIMU();
}

void loop() {
  // put your main code here, to run repeatedly:
}

float pid(float currentAltitude, unsigned long currentTime) {
  unsigned long dt = currentTime - previousTime;
  if (dt == 0) {
    return 0;
  }
  previousTime = currentTime;
  float error = adjustedTargetAltitude - currentAltitude;
  float derivativeError = (error - previousError) / dt;
  integralError += error * dt;
  float output = Kp * error + Ki * integralError + Kd * derivativeError;
  previousError = error;

  if (output > MAX_OUTPUT) {
    output = MAX_OUTPUT;
  } else if (output < MIN_OUTPUT) {
    output = MIN_OUTPUT;
  }

  pidLogger(currentTime, dt, error, derivativeError, integralError, output);
}

void logger(unsigned long time, float altitude, float pressure, int servoPosition) {
  myFile = SD.open("ALTITUDE.TXT", FILE_WRITE);

  if (myFile) {
    myFile.print(time);
    myFile.print(" ");
    myFile.print(altitude);
    myFile.print(" ");
    myFile.print(pressure);
    myFile.print(" ");
    myFile.println(servoPosition);
    myFile.close();
  }
}

void getCorrectedIMU() {
  float accelerometerTemp[] = { 0, 0, 0 };
  float gyroscopeTemp[] = { 0, 0, 0 };
  for (int i = 0; i < 10; i++) {
    accel.readSensor();
    gyro.readSensor();

    accelerometerTemp[0] += accel.getAccelX_mss();
    accelerometerTemp[1] += accel.getAccelY_mss();
    accelerometerTemp[2] += accel.getAccelZ_mss();

    gyroscopeTemp[0] = gyro.getGyroX_rads();
    gyroscopeTemp[1] = gyro.getGyroY_rads();
    gyroscopeTemp[2] = gyro.getGyroZ_rads();
  }

  for (int i = 0; i < 3; i++) {
    accelerometerCorrected[i] = accelerometerTemp[i] / 10;
    gyroscopeCorrected[i] = gyroscopeTemp[i] / 10;
  }

  //correcting for gravity
  accelerometerCorrected[2] = accelerometerCorrected[2] - 9.8;

#ifdef PRINT_CORRECTED_IMU
  Serial.print("Accelerometer: ");
  Serial.print("\t");
  Serial.print(accelerometerCorrected[0]);
  Serial.print("\t");
  Serial.print(accelerometerCorrected[1]);
  Serial.print("\t");
  Serial.println(accelerometerCorrected[2]);

  Serial.print("Gyroscope: ");
  Serial.print("\t");
  Serial.print(gyroscopeCorrected[0]);
  Serial.print("\t");
  Serial.print(gyroscopeCorrected[1]);
  Serial.print("\t");
  Serial.println(gyroscopeCorrected[2]);
#endif
}

void getIMUData(float accelerometer[], float gyroscope[]) {
  accel.readSensor();
  gyro.readSensor();

  accelerometer[0] = accel.getAccelX_mss();
  accelerometer[1] = accel.getAccelY_mss();
  accelerometer[2] = accel.getAccelZ_mss();

  gyroscope[0] = gyro.getGyroX_rads();
  gyroscope[1] = gyro.getGyroY_rads();
  gyroscope[2] = gyro.getGyroZ_rads();

#ifdef PRINT_IMU_DATA
  Serial.print("Accelerometer: ");
  Serial.print("\t");
  Serial.print(accelerometer[0]);
  Serial.print("\t");
  Serial.print(accelerometer[1]);
  Serial.print("\t");
  Serial.println(accelerometer[2]);

  Serial.print("Gyroscope: ");
  Serial.print("\t");
  Serial.print(gyroscope[0]);
  Serial.print("\t");
  Serial.print(gyroscope[1]);
  Serial.print("\t");
  Serial.println(gyroscope[2]);
#endif
}

void initIMU() {
  vspi.begin(SPI_SCK, SPI_MISO, SPI_MOSI, IMU_CS);
  int status;
  /* USB Serial to print data */
  Serial.begin(115200);
  while (!Serial) {}
  status = accel.begin();
  if (status < 0) {
    Serial.println("Accel Initialization Error");
    while (1) {}
  }
  status = gyro.begin();
  if (status < 0) {
    Serial.println("Gyro Initialization Error");
    while (1) {}
  }
  Serial.println("IMU Initialized");
}

void initServos() {
  servoX.attach(SERVO_X_PIN);
  servoY.attach(SERVO_Y_PIN);
}

void writeServos(int servoPosition_X, int servoPosition_Y) {
  if (servoPosition_X < MIN_POSITION) {
    servoPosition_X = MIN_POSITION + servoStartingPosition[0];
  } else if (servoPosition_X > MAX_POSITION) {
    servoPosition_X = MAX_SERVO_POSITION + servoStartingPosition[0];
  } else {
    servoPosition_X = servoPosition_X + servoStartingPosition[0];
  }

  if (servoPosition_Y < MIN_POSITION) {
    servoPosition_Y = MIN_SERVO_POSITION + servoStartingPosition[1];
  } else if (servoPosition_Y > MAX_POSITION) {
    servoPosition_Y = MAX__SERVO_POSITION + servoStartingPosition[1];
  } else {
    servoPosition_Y = servoPosition_Y + servoStartingPosition[1];
  }

  servoX.write(servoPosition_X);
  servoY.write(servoPosition_Y);

#ifdef PRINT_SERVO_POSITION
  Serial.print("Servo X Position: ");
  Serial.println(servoPosition_X);
  Serial.print("Servo Y Position: ");
  Serial.println(servoPosition_Y);
#endif
}

void pidLogger(unsigned long time, unsigned long dt, float error, float derivativeError, float integralError, float output) {
  myFile = SD.open("PID.TXT", FILE_WRITE);

  if (myFile) {
    myFile.print(time);
    myFile.print(" ");
    myFile.print(dt);
    myFile.print(" ");
    myFile.print(error);
    myFile.print(" ");
    myFile.print(derivativeError);
    myFile.print(" ");
    myFile.println(integralError);
    myFile.print(" ");
    myFile.println(output);
    myFile.close();
  }
}

float getAccelerometerAngle(float accelerometerInput[]) {
  float accY = accelerometerInput[1] * ()
}

float applyComplementaryFilter(float accelerometerInput, float gyroInput, int looptime, float currentAngle, float y1) {
  accAngle = accelerometerInput * 180 / PI; 
  gyroRate = gyroInput;

  float deltaTime = float(looptime) / 1000.0;

  float x1 = (accAngle - currentAngle) * COMPLEMENTARY_FILTER_CONSTANT * COMPLEMENTARY_FILTER_CONSTANT;
  y1 = deltaTime * x1 + y1;
  float x2 = y1 + (accAngle - currentAngle) * 2 * COMPLEMENTARY_FILTER_CONSTANT + gyroRate;
  currentAngle = deltaTime*x2 + currentAngle;
  return currentAngle;
}

void normalizeVector(float vector[]) {
  float sum = 0;
  for (int i = 0; i < 3; i++) {
    sum += vector[i] * vector[i];
  }

  sum = sqrt(sum);

  if (sum > 0) {
    for (int i = 0; i < 3; i++) {
      vector[i] = vector[i] / sum;
    }
  }

#ifdef PRINT_VECTOR_NORMALIZE
  Serial.print("Magnitude: ");
  Serial.println(sum);
  Serial.print("Vectors: ");
  Serial.print(vector[0]);
  Serial.print("\t");
  Serial.print(vector[1]);
  Serial.print("\t");
  Serial.println(vector[2]);
#endif
}
