class PID():
    kp: float 
    ki: float 
    kd: float
    maxOutput: float
    minOutput: float
    previousError = 0
    integralError = 0

    def __init__(self, kp, ki, kd, setpoint):
        self.kp = kp
        self.ki = ki
        self.kd = kd
        self.setpoint = setpoint

    def compute(self, pos, dt):
        error = self.setpoint - pos #compute the error
        derivative_error = (error - self.previousError) / dt 
        self.integralError += error * dt #error build up over time
        output = self.kp*error + self.ki*self.integral_error + self.kd*derivative_error 
        self.error_last = error
        return output

