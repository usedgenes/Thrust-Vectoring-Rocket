#include <ESP32Servo.h>
#include <SD.h>
#include "BMI088.h"

//Debugging
// #define PRINT_IMU_DATA 0
// #define PRINT_CORRECTED_IMU 0
// #define PRINT_SERVO_POSITION 0
// #define PRINT_VECTOR_NORMALIZE 0
#define PRINT_COMPLEMENTARY_FILTER 0

//IMU
#define SPI_SCK 27
#define SPI_MISO 25
#define SPI_MOSI 26
#define IMU_CS 33
SPIClass vspi = SPIClass(VSPI);
Bmi088Accel accel(vspi, 33);
Bmi088Gyro gyro(vspi, 32);
float accelerometerCorrected[] = { 0, 0, 0 };
float gyroscopeCorrected[] = { 0, 0, 0 };

//PID
#define Kp 0
#define Ki 0
#define Kd 0
#define MAX_PID_OUTPUT 0
#define MIN_PID_OUTPUT 0
float integralError = 0;
float previousError = 0;

//Complementary filter
#define PITCH_CONSTANT 0
#define ROLL_CONSTANT 0
float roll = 0;
float pitch = 0;

//Kalman filter
#define Q 0.1
#define R 4
float angularVelocityX = 0;
float angularyVelocityY = 0;
float thetaModel = 0;
float phiModel = 0;
float thetaSensor = 0;
float phiSensor = 0;

float theta_n;      // a priori estimation of Theta
float theta_p = 0;  // a posteriori estimation on Theta (set to zero for the initial time step k=0)
float phi_n;        // a priori estimation of Phi
float phi_p = 0;    // a posteriori estimation on Phi (set to zero for the initial time step k=0)

float P_theta_n;      // a priori cobvariance of Theta
float P_phi_n;        // a priori covariance of Phi
float P_theta_p = 0;  // a posteriori covariance of Theta
float P_phi_p = 0;    // a posteriori covariance of Phi

float K_theta;  // Observer gain or Kalman gain for Theta
float K_phi;    // Observer gain or Kalman gain for Phi

//Servos
#define MAX_SERVO_POSITION 0
#define MIN_SERVO_POSITION 0
#define SERVO_X_PIN 0
#define SERVO_Y_PIN 0
Servo servoX;
Servo servoY;
int servoStartingPosition[2] = { 10, 100 };
int servoPosition_X = 100;
int servoPosition_Y = 100;

File myFile;

float accelerometerData[3] = { 0, 0, 0 };
float gyroscopeData[3] = { 0, 0, 0 };
unsigned long previousTime = 0;

void setup() {
  Serial.begin(115200);
  initIMU();
  previousTime = 0;
}

void loop() {
  unsigned long loopTime = millis() - previousTime;
  previousTime = millis();
  getIMUData(accelerometerData, gyroscopeData);
  float output[2] = { 0, 0 };
  applyComplementaryFilter(accelerometerData, gyroscopeData, loopTime, output);
  delay(800);
}

float pid(float error, unsigned long deltaTime) {
  if (deltaTime == 0) {
    return 0;
  }
  float derivativeError = (error - previousError) / deltaTime;
  integralError += error * deltaTime;
  float output = Kp * error + Ki * integralError + Kd * derivativeError;
  previousError = error;

  if (output > MAX_PID_OUTPUT) {
    output = MAX_PID_OUTPUT;
  } else if (output < MIN_PID_OUTPUT) {
    output = MIN_PID_OUTPUT;
  }
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

#ifdef PRINT_CORRECTED_IMU
  Serial.print("Accelerometer Corrected: ");
  Serial.print("\t");
  Serial.print(accelerometerCorrected[0]);
  Serial.print("\t");
  Serial.print(accelerometerCorrected[1]);
  Serial.print("\t");
  Serial.println(accelerometerCorrected[2]);

  Serial.print("Gyroscope Corrected: ");
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

  accelerometer[0] = accel.getAccelX_mss() - accelerometerCorrected[0];
  accelerometer[1] = accel.getAccelY_mss() - accelerometerCorrected[1];
  accelerometer[2] = accel.getAccelZ_mss() - accelerometerCorrected[2];

  gyroscope[0] = gyro.getGyroX_rads() - gyroscopeCorrected[0];
  gyroscope[1] = gyro.getGyroY_rads() - gyroscopeCorrected[1];
  gyroscope[2] = gyro.getGyroZ_rads() - gyroscopeCorrected[2];

#ifdef PRINT_IMU_DATA
  // Serial.print("Accelerometer: ");
  // Serial.print("\t");
  Serial.print(accelerometer[0]);
  Serial.print("\t");
  Serial.print(accelerometer[1]);
  Serial.print("\t");
  Serial.println(accelerometer[2]);

  // Serial.print("Gyroscope: ");
  // Serial.print("\t");
  // Serial.print(gyroscope[0]);
  // Serial.print("\t");
  // Serial.print(gyroscope[1]);
  // Serial.print("\t");
  // Serial.println(gyroscope[2]);
#endif
}

void initIMU() {
  vspi.begin(SPI_SCK, SPI_MISO, SPI_MOSI, IMU_CS);
  int status;
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
  if (servoPosition_X < MIN_SERVO_POSITION) {
    servoPosition_X = MIN_SERVO_POSITION + servoStartingPosition[0];
  } else if (servoPosition_X > MAX_SERVO_POSITION) {
    servoPosition_X = MAX_SERVO_POSITION + servoStartingPosition[0];
  } else {
    servoPosition_X = servoPosition_X + servoStartingPosition[0];
  }

  if (servoPosition_Y < MIN_SERVO_POSITION) {
    servoPosition_Y = MIN_SERVO_POSITION + servoStartingPosition[1];
  } else if (servoPosition_Y > MAX_SERVO_POSITION) {
    servoPosition_Y = MAX_SERVO_POSITION + servoStartingPosition[1];
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

void applyComplementaryFilter(float accelerometerInput[], float gyroInput[], int loopTime, float output[]) {
  float accelPitch = atan2(-accelerometerInput[0], sqrt(accelerometerInput[1] * accelerometerInput[1] + accelerometerInput[2] * accelerometerInput[2]));
  float accelRoll = atan2(accelerometerInput[1], sqrt(accelerometerInput[0] * accelerometerInput[0] + accelerometerInput[2] * accelerometerInput[2]));
  pitch = PITCH_CONSTANT * (pitch + gyroInput[1] * loopTime / 1000) + (1 - PITCH_CONSTANT) * accelPitch;
  roll = ROLL_CONSTANT * (roll + gyroInput[0] * loopTime / 1000) + (1 - ROLL_CONSTANT) * accelRoll;
#ifdef PRINT_COMPLEMENTARY_FILTER
  // Serial.print("Pitch: ");
  Serial.print(pitch);
  Serial.print("\t");
  // Serial.print("Roll: ");
  Serial.println(roll);
#endif
  output[0] = pitch;
  output[1] = roll;
}

void applyKalmanFilter(float accelerometerInput[], float gyroInput[], int loopTime, float output[]) {
  loopTime = loopTime * 0.001;
  thetaModel = thetaModel - gyroInput[1] * 0.1;
  phiModel = phiModel + gyroInput[0] * 0.1;
  thetaSensor = atan2(accelerometerInput[0] / 9.8, accelerometerInput[2] / 9.8) / 2 / 3.141592654 * 360;
  phiSensor = atan2(accelerometerInput[1] / 9.8, accelerometerInput[2] / 9.8) / 2 / 3.141592654 * 360;
  P_theta_n = P_theta_p + Q;
  K_theta = P_theta_n / (P_theta_n + R);
  theta_n = theta_p - loopTime * gyroInput[1];
  theta_p = theta_n + K_theta * (thetaSensor - theta_n);
  P_theta_p = (1 - K_theta) * P_theta_n;

  P_phi_n = P_phi_p + Q;
  K_phi = P_phi_n / (P_phi_n + R);
  phi_n = phi_p + loopTime * gyroInput[0];
  phi_p = phi_n + K_phi * (phiSensor - phi_n);
  P_phi_p = (1 - K_phi) * P_phi_n;

  output[0] = theta_p;
  output[1] = phi_p;

#ifdef PRINT_COMPLEMENTARY_FILTER
  // Serial.print("Pitch: ");
  Serial.print(pitch);
  Serial.print("\t");
  // Serial.print("Roll: ");
  Serial.println(roll);
#endif
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
