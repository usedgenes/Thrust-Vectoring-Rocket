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
        derivative_error = (error - self.error_last) / dt #find the derivative of the error (how the error changes with time)
        self.integral_error += error * dt #error build up over time
        output = self.kp*error + self.ki*self.integral_error + self.kd*derivative_error 
        self.error_last = error
        if output > self.saturation_max and self.saturation_max is not None:
            output = self.saturation_max
        elif output < self.saturation_min and self.saturation_min is not None:
            output = self.saturation_min
        return output

