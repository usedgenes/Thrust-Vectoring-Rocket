class PID():

    def __init__(self, kp, ki, kd, setpoint):
        self.kp = kp
        self.ki = ki
        self.kd = kd
        self.setpoint = setpoint
        self.integralError = 0
        self.previousError = 0

    def compute(self, pos, dt):
        error = self.setpoint - pos #compute the error
        derivativeError = (error - self.previousError) / dt 
        self.integralError += error * dt #error build up over time
        output = self.kp*error + self.ki*self.integralError + self.kd*derivativeError 
        self.previousError = error
        return output

