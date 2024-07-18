#include "SD.h"
#include "SPI.h"

#define SD_SCK -1
#define SD_MISO -1
#define SD_MOSI -1
#define SD_CS -1

#define MOTORTHRUSTCURVEPATH "/AeroTech_F42T_L"
#define ROCKETMASS 0.65 //kg

int motorThrust[][];
float radius; //meters

void setup() {
  SPI.begin(SD_SCK, SD_MISO, SD_MOSI, SD_CS);
  while(!SD.begin(SD)CS)) {
    Serial.println("No SD Card");
  }
  //Format: Time (s), Thrust (N)
  File motorThrustCurve = SD.open(MOTORTHRUSTCURVEPATH);
  int i = 0;
  while(motorThrustCurve.available()) {
    if(motorThrustCurve.read() == '\n') {
      i++;
    }
  }
  motorThrust = readCSVFile(motorThrustCurve, i);
}

void loop() {
  // put your main code here, to run repeatedly:

}

int[][] readCSVFile(File* file, int numberOfLines) {
  int motorThrust[i][2];
  while(motorThrustCurve.available()) {

  }
}

