#ifndef THRUSTCURVE_H_
#define THRUSTCURVE_H_

#include "SD.h"
#include "Logger.h"

class ThrustCurve {
#define ROW_DIM 5
#define COL_DIM 4

private:
float** thrust;
File thrustCSV;
Logger log;
public:
  void Init();
  size_t readField(char* str, size_t size, char* delim);
};


#endif