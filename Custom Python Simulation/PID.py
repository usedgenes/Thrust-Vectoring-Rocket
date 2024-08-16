class PID():
    kp: float 
    ki: float 
    kd: float
    maxOutput: float
    minOutput: float
    previousError = 0
    integralError = 0

    def __init__(self, kp, ki, kd, maxOutput, minOutput):
        self.kp = kp
        self.ki = ki
        self.kd = kd
        self.maxOutput = maxOutput
        self.minOutput = minOutput

    def compute(self, pos, dt):
        error = self.sp - pos #compute the error
        derivative_error = (error - self.previousError) / dt 
        self.integralError += error * dt #error build up over time
        output = self.kp*error + self.ki*self.integral_error + self.kd*derivative_error 
        self.error_last = error
        if output > self.maxOutput: 
            output = self.maxOutput
        elif output < self.minOutput:
            output = self
        return output

