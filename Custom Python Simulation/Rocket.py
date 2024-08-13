import numpy as np

class Rocket():
    mass: float
    mmoi: float
    distance_TVC_COM: float
    servoLimit: int
    state_vector: []
    servoPostionX = 0
    servoPositionY = 0
    
    def __init__(self, initial_state_vector, mass, mmoi, servoLimit):
        self.state_vector = initial_state_vector
        self.mass = mass
        self.mmoi = mmoi
        self.servoLimit = servoLimit
        
    def inputForces(self, input_force_vector, dt):
        self.state_vector["ay"] = (input_force_vector[0] / self.mass) -9.18
        self.state_vector["ax"] = input_force_vector[1] / self.mass
        self.state_vector["alpha"] = input_force_vector[2] / self.mmoi
        self.state_vector["vy"] += self.state_vector["ay"] * dt
        self.state_vector["vx"] += self.state_vector["ax"] * dt
        self.state_vector["omega"] += self.state_vector["alpha"] * dt
        self.state_vector["py"] += self.state_vector["vy"] * dt
        self.state_vector["px"] += self.state_vector["vx"] * dt
        self.state_vector["theta"] += self.state_vector["omega"] * dt
    
    #angle in rads
    def tvcPhysics(self, input_angle, thrust, dt): 
        global servoLimit
        if input_angle > servoLimit:
            input_angle = servoLimit
        if input_angle < -servoLimit:
            input_angle = -servoLimit
        servo_rate = (self.input_last - input_angle) / dt
        Fz = np.sin(self.state_vector["theta"])*np.sin(input_angle) * thrust
        Fx = np.cos(self.state_vector["theta"])*np.cos(input_angle) * thrust
        Tau = np.sin(input_angle) * thrust * distance_TVC_COM
        self.actuator_state = input_angle
        self.input_last = input_angle
        return [Fx,Fz,Tau]