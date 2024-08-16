import numpy as np

class Rocket():
    
    #mass in kg
    def __init__(self, initial_state_vector, mass, mmoi, servoLimit, distance_TVC_COM):
        self.state_vector = initial_state_vector
        self.mass = mass
        self.mmoi = mmoi
        self.servoLimit = servoLimit
        self.G = -9.81
        self.distance_TVC_COM = distance_TVC_COM
        
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
        return self.state_vector
    
    #angle in rads
    def tvcPhysics(self, input_angle, thrust, dt): 
        if input_angle > self.servoLimit:
            input_angle = self.servoLimit
        if input_angle < -self.servoLimit:
            input_angle = -self.servoLimit
        Fx = np.sin(self.state_vector["theta"])*np.sin(input_angle) * thrust
        Fy = np.cos(self.state_vector["theta"])*np.cos(input_angle) * thrust
        Tau = np.sin(input_angle) * thrust * self.distance_TVC_COM
        self.actuator_state = input_angle
        self.input_last = input_angle
        return [Fy,Fx,Tau]