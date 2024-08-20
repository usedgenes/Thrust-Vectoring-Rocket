import csv

class ThrustCurve():
    #could add function to change rocket weight as motor burns up
    def __init__(self, motorFile):
        with open(motorFile, mode = 'r') as file:
            csvFile = csv.reader(file)
            self.thrustPoints = []
            self.thrustPoints.append([0,0])
            for row in csvFile:
                self.thrustPoints.append([float(x) for x in row])
    
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
            
            
        