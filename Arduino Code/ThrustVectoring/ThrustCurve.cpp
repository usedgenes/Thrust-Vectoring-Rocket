#include "ThrustCurve.h"
void ThrustCurve::Init() {
  thrustCSV = SD.open("F15_Thrust.csv", FILE_WRITE);
  thrustCSV.seek(0);
  float array[ROW_DIM][COL_DIM];
  int i = 0;     // First array index.
  int j = 0;     // Second array index
  size_t n;      // Length of returned field with delimiter.
  char str[20];  // Must hold longest field with delimiter and zero byte.
  char* ptr;     // Test for valid field.
  char delim = 0;
  while (true) {
    n = readField(&file, str, sizeof(str), ",\n");
    if (n == 0) {
      break;
    }
    if (delim == '\n') {
      if (++i >= ROW_DIM) {
        log.log(MotorThrust, "Too many lines");
      }
      if (j != (COL_DIM - 1)) {
        log.log(MotorThrust, "Missing field");
      }
      j = 0;
    } else if (delim == ',') {
      if (++j >= COL_DIM) {
        log.log(MotorThrust, "Too many fields");
      }
    }
    array[i][j] = strtol(str, &ptr, 10);
    if (ptr == str) {
      log.log(MotorThrust, "bad number");
    }
    while (*ptr == ' ') {
      ptr++;
    }
    delim = *ptr;

    if (delim != ',' && delim != '\n' && delim != 0) {
      log.log(MotorThrust, "extra data in field");
    }
    if (delim == 0 && file.available() != 0) {
      log.log(MotorThrust, "read error or long line");
    }
  }
}

size_t ThrustCurve::readField(char* str, size_t size, char* delim) {
  char ch;
  size_t n = 0;
  while ((n + 1) < size && thrustCSV.read(&ch, 1) == 1) {
    // Delete CR.
    if (ch == '\r') {
      continue;
    }
    str[n++] = ch;
    if (strchr(delim, ch)) {
      break;
    }
  }
  str[n] = '\0';
  return n;
}

float ThrustCurve::getThrust(int currentTime) {
  if (time == 0) {
    return 0
  }
        for
          i in range(len(self.thrustPoints)) {
            if (time <= self.thrustPoints[i][0]) {
              slope = (self.thrustPoints[i][1] - self.thrustPoints[i - 1][1]) / (self.thrustPoints[i][0] - self.thrustPoints[i - 1][0]) return self.thrustPoints[i - 1][1] + (time - self.thrustPoints[i - 1][0]) * slope
            } else {
              i += 1;
            }
          }
        return 0
}
