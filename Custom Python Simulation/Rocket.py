import numpy as np
from pylab import * 

class Rocket():
    
    #mass in kg
    def __init__(self, initial_state_vector, mass, mmoi, tvcLimit, distance_TVC_COM, tvcRotationLimit):
        self.state_vector = initial_state_vector
        self.mass = mass
        self.mmoi = mmoi
        self.tvcLimit = tvcLimit
        self.G = -9.81
        self.distance_TVC_COM = distance_TVC_COM
        self.tvcRotationLimit = tvcRotationLimit
        self.previousTvcState = initial_state_vector["tvcAngle"]
        
    #alpha: angular acceleration
    #omega: angular velocity
    #theta: angular position
    def inputForces(self, input_force_vector, dt):
        self.state_vector["ay"] = (input_force_vector[0] / self.mass) + self.G
        self.state_vector["ax"] = input_force_vector[1] / self.mass
        self.state_vector["alpha"] = input_force_vector[2] / self.mmoi
        self.state_vector["vy"] += self.state_vector["ay"] * dt
        self.state_vector["vx"] += self.state_vector["ax"] * dt
        self.state_vector["omega"] += self.state_vector["alpha"] * dt
        self.state_vector["py"] += self.state_vector["vy"] * dt
        self.state_vector["px"] += self.state_vector["vx"] * dt
        self.state_vector["theta"] += self.state_vector["omega"] * dt
        if(self.state_vector["py"] <= 0):
            self.state_vector["py"] = 0
            self.state_vector["vy"] = 0
        return self.state_vector
    
    #angle in rads
    #theta - rocket's angle from verticle
    #input_angle - tvc mechanism's angle from rocket's center line
    def rocketPhysics(self, thrust, dt): 
        Fx = np.sin(self.state_vector["theta"] - self.state_vector["tvcAngle"]*pi/180) * thrust
        Fy = np.cos(self.state_vector["theta"] - self.state_vector["tvcAngle"]*pi/180) * thrust
        #torque applied to the rocket from the tvc's angle
        Tau = np.sin(self.state_vector["tvcAngle"]*pi/180) * thrust * self.distance_TVC_COM
        return [Fy,Fx,Tau]
    
    def tvcCalculations(self, pidCommand):
        if(pidCommand - self.state_vector["tvcAngle"] > self.tvcRotationLimit):
            if(pidCommand < 0):
                self.state_vector["tvcAngle"] -= self.tvcRotationLimit
            else:
                self.state_vector["tvcAngle"] += self.tvcRotationLimit
        else:
            self.state_vector["tvcAngle"] += pidCommand
        if(self.state_vector["tvcAngle"] > self.tvcLimit):
            self.state_vector["tvcAngle"] = self.tvcLimit
        if(self.state_vector["tvcAngle"] < -self.tvcLimit):
            self.state_vector["tvcAngle"] = -self.tvcLimit
            
        