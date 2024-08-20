import numpy as np
from pylab import * 
import PID
import Grapher 
import Rocket
import MotorThrustCurve
#Units are SI units... m/s/radians/kg

class Simulator():
    
    def run():
        #ms
        time = 0
        deltaTime = 20
        runtime = 1000
        #initial angle and setpoint in degrees for easier visualization, but program converts it to radians for calculations with trigonometric functions
        initial_rocket_angle = -10 
        setpoint = 0
        #tvcLimit in degrees - all tvc calculations done in degrees
        tvcLimit = 10
        #servo can turn 60 degrees in 100 ms
        tvcRotationLimit = 0.6*deltaTime
        
        
        initial_state_vector = {"ay" : 0 , "vy" : 0, "py" : 0, "ax" : 0 , "vx" : 0, "px" : 0 , "alpha": 0.0, "omega" : 0, "theta" : initial_rocket_angle*pi/180, "tvcAngle": 0}
                
        #initial_state_vector, mass, mmoi, tvcLimit, distance_TVC_COM, tvcRotationLimit
        rocket = Rocket.Rocket(initial_state_vector, 0.65, 0.1, tvcLimit, 0.3, tvcRotationLimit)
        
        #if csv file has point (0,0), delete that point
        thrust = MotorThrustCurve.ThrustCurve("AeroTech_F67W.csv")
        
        #kp, ki, kd, setpoint
        pid = PID.PID(100, 1, 70, setpoint*pi/180)
        
        graph = Grapher.Grapher()
        
        timeArray = []
        orientationArray = []
        xPositionArray = []
        yPositionArray = []
        tvcAngleArray = []
        
        orientationGraph = {"x" : "time(s)", "y" : "Rocket angle (deg)", "title" : "Theta"}
        xPositionGraph = {"x" : "time(s)", "y" : "Pos X (m)", "title" : "Position X"}
        yPositionGraph = {"x" : "time(s)", "y" : "Pos Y (y)", "title" : "Position Y"}
        tvcAngleGraph = {"x" : "time(s)", "y" : "TVC angle (deg)", "title" : "TVC Angle"}
        
        graphs_dict = [orientationGraph, xPositionGraph, yPositionGraph, tvcAngleGraph]
        graph.graphsHandler(4, graphs_dict)
        
        
        while(time <= runtime):
            motorThrust = thrust.getThrust(time/1000)
            forces = rocket.rocketPhysics(motorThrust, deltaTime/1000)
            rocket.inputForces(forces, deltaTime/1000)
            
            pid
            
            timeArray.append(time/1000)
            orientationArray.append(rocket.state_vector["theta"] * 180/pi)
            xPositionArray.append(rocket.state_vector["px"])
            yPositionArray.append(rocket.state_vector["py"])
            tvcAngleArray.append(rocket.state_vector["tvcAngle"])
            
            pidCommand = pid.compute(rocket.state_vector["theta"], deltaTime)
            rocket.tvcCalculations(pidCommand)
            time += deltaTime

        graphs = [(timeArray, orientationArray), (timeArray, xPositionArray), (timeArray, yPositionArray), (timeArray, tvcAngleArray)]
        graph.showGraphs(graphs)
 
    if __name__ == "__main__":
        run()


