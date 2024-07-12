#include <ESP32Servo.h>
#include <Wire.h>
#include <SPI.h>
#include <Adafruit_Sensor.h>
#include "Adafruit_BMP3XX.h"
#include <SD.h>

#define BMP_SCK 13
#define BMP_MISO 12
#define BMP_MOSI 11
#define BMP_CS 10

Adafruit_BMP3XX bmp;
File myFile;
Servo servoX;
servo ServoY;

int xPosition = 100;
int yPosition = 100;
void setup() {
  servoX.attach(27);
  servoX.write(xPosition);
  servoY.attach(13);
  servoY.write(yPosition);
}

void loop() {
  // put your main code here, to run repeatedly:
  
}

float pid(float currentAltitude, unsigned long currentTime) {
  unsigned long dt = currentTime - previousTime;
  if(dt == 0) {
    return 0;
  }
  previousTime = currentTime;
  float error = adjustedTargetAltitude - currentAltitude;
  float derivativeError = (error - previousError) / dt;
  integralError += error * dt;
  float output = Kp*error + Ki*integralError + Kd*derivativeError;
  previousError = error;

  if (output > MAX_OUTPUT) {
    output = MAX_OUTPUT;
  }
  else if (output < MIN_OUTPUT) {
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
