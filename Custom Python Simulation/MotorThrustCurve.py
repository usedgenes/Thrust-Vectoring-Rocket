import csv

class ThrustCurve():
    def __init__(self, motorFile, weight, propellantWeight):
        with open(motorFile, mode = 'r') as file:
            csvFile = csv.reader(file)
            lineCount = 1;
            self.thrustPoints = []
            self.thrustPoints.append([0,0])
            for row in csvFile:
                if(lineCount >= 6):
                    self.thrustPoints.append([float(x) for x in row])
                lineCount += 1
        self.weight = weight-propellantWeight
        self.propellantWeight = propellantWeight
    
    #Thrust in Newtons
    def getThrust(self, time):
        if(time == 0):
            return 0
        for i in range(len(self.thrustPoints)):
            if(time <= self.thrustPoints[i][0]):
                slope = (self.thrustPoints[i][1] - self.thrustPoints[i-1][1]) / (self.thrustPoints[i][0] - self.thrustPoints[i-1][0])
                return self.thrustPoints[i-1][1] + (time-self.thrustPoints[i-1][0]) * slope
            else:
                i += 1;
        return 0
            
            
        