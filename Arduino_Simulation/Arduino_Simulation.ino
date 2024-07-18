//Based on https://medium.com/@danaclarkeiii/how-to-code-a-pid-controller-thrust-vector-example-eb92c899dc98
#include "SD.h"
#include "SPI.h"

#define SD_SCK -1
#define SD_MISO -1
#define SD_MOSI -1
#define SD_CS -1

#define MOTORTHRUSTCURVEPATH "/AeroTech_F42T_L"
#define MASS 0.65 //kg
#define SERVOGIMBALLIMIT 0.17 //radians
#define P_GAIN 0.5
#define I_GAIN 0.2
#define D_GAIN 0.2
#define TIMEINTERVAL 20

int** motorThrust;
File motorThrustCurve;
float radius; //meters
float PID;
float torque;
float angularSpeed;
float gyroDegree;
float gyroDegreePrevious;
unsigned long currentTime;
float P;
float I;
float D;

void setup() {
  SPI.begin(SD_SCK, SD_MISO, SD_MOSI, SD_CS);
  while(!SD.begin(SD_CS)) {
    Serial.println("No SD Card");
  }
  //Format: Time (s), Thrust (N)
  motorThrustCurve = SD.open(MOTORTHRUSTCURVEPATH);
  int i = 0;
  while(motorThrustCurve.available()) {
    if(motorThrustCurve.read() == '\n') {
      i++;
    }
  }
  motorThrust = readCSVFile(i);
}

void loop() {
  P = gyroDegree * P_GAIN;
  I = (I + gyroDegree) * I_GAIN;
  D = ((gyroDegree - gyroDegreePrevious) / TIMEINTERVAL) * D_GAIN;
  physics();
}

int** readCSVFile(int numberOfLines) {
  int motorThrust[numberOfLines][2];
  int index = 0;
  int array[7];
  while(motorThrustCurve.available()) {
    int character = motorThrustCurve.read();
    if((char) character ==  '\n') {
      array[index] = -1;
    }
    else {
      array[index] = character;
      index++;
    }
  }
}

float getThrust() {

}

void physics() {
  if (PID <= SERVOGIMBALLIMIT && PID >= -SERVOGIMBALLIMIT) {
    torque = radius * getThrust() * sin(PID);
  }
  else if (PID > 5) {
    torque = radius * getThrust() * sin(5);
  }
  else {
    torque = radius * getThrust() * sin(-5);
  }

  angularSpeed = angularSpeed + (((torque / radius) / MASS) * TIMEINTERVAL);

  gyroDegree = gyroDegree + (((angularSpeed * TIMEINTERVAL) + random(-100, 100) / 90));
}

