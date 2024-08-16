import numpy as np
import PID
import Grapher 
import Rocket
import MotorThrustCurve
#Units are SI units... m/s/radians/kg

class Simulator():
    
    def run():
        #ms
        time = 0
        deltaTime = 100
        runtime = 10000
        state_vector = {"ay" : 0 ,"vy" : 0,"py" : 0,"ax" : 0 ,"vx" : 0,"px" : 0 ,"alpha": 0.0,"omega" : 0,"theta" : 0.0}
        
        rocket = Rocket.Rocket()
        thrust = MotorThrustCurve.ThrustCurve("AeroTech_F67W.csv", 0.08, 0.03)
        pid = PID.PID(0.01, 0.01, 0.01, 60, 50)
        graph = Grapher(deltaTime)
        
        while(time <= runtime):
            time += deltaTime

