class PID():

    def __init__(self, kp, ki, kd, setpoint, previousError):
        self.kp = kp
        self.ki = ki
        self.kd = kd
        self.setpoint = setpoint
        self.integralError = 0
        self.previousError = previousError

    def compute(self, pos, dt):
        error = self.setpoint - pos #compute the error
        derivativeError = (error - self.previousError) / dt 
        self.integralError += error * dt #error build up over time
        output = self.kp*error + self.ki*self.integralError + self.kd*derivativeError 
        self.previousError = error
        #print('%.2f' % dt + " " + '%.2f' % error + " " + '%.2f' % self.integralError + " " + '%.2f' % derivativeError + " " + '%.2f' % output + " " + '%.2f' % self.previousError)
        return output

