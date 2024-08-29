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
        runtime = 100
        #initial angle and setpoint in degrees for easier visualization, but program converts it to radians for calculations with trigonometric functions
        initial_rocket_angle = -25
        setpoint = 0
        #tvcLimit in degrees - all tvc calculations done in degrees
        tvcLimit = 10
        #servo can turn 60 degrees in 100 ms
        tvcRotationLimit = 0.6*deltaTime
        
        
        initial_state_vector = {"ay" : 0 , "vy" : 0, "py" : 0, "ax" : 0 , "vx" : 0, "px" : 0 , "alpha": 0.0, "omega" : 0, "theta" : initial_rocket_angle*pi/180, "tvcAngle": 0}
                
        #initial_state_vector, mass, mmoi, tvcLimit, distance_TVC_COM, tvcRotationLimit
        rocket = Rocket.Rocket(initial_state_vector, 0.65, 0.02, tvcLimit, 0.2, tvcRotationLimit)
        
        #if csv file has point (0,0), delete that point
        thrust = MotorThrustCurve.ThrustCurve("F42.csv")
        
        #kp, ki, kd, setpoint
        pid = PID.PID(45, 0.5, 15, setpoint*pi/180, initial_rocket_angle * pi/180)
        
        graph = Grapher.Grapher()
        
        timeArray = []
        orientationArray = []
        xPositionArray = []
        yPositionArray = []
        tvcAngleArray = []
        pidCommandArray = []
        
        orientationGraph = {"x" : "time(s)", "y" : "Rocket angle (deg)", "title" : "Theta"}
        xPositionGraph = {"x" : "time(s)", "y" : "Pos X (m)", "title" : "Position X"}
        yPositionGraph = {"x" : "time(s)", "y" : "Pos Y (y)", "title" : "Position Y"}
        tvcAngleGraph = {"x" : "time(s)", "y" : "TVC angle (deg)", "title" : "TVC Angle"}
        pidCommandGraph = {"x" : "time(s)", "y" : "PID Command", "title" : "PID Command"}
        
        graphs_dict = [orientationGraph, xPositionGraph, yPositionGraph, tvcAngleGraph, pidCommandGraph]
        graph.graphsHandler(5, graphs_dict)
        print(pidCommandArray)
        while(time <= runtime):

            motorThrust = thrust.getThrust(time/1000)
            forces = rocket.rocketPhysics(motorThrust, deltaTime/1000)
            rocket.inputForces(forces, deltaTime/1000)
            
            # simulated rocket disturbance
            #if( time == 1000 ):
                #rocket.state_vector["theta"] += 5*pi/180.
            
            timeArray.append(time/1000)
            orientationArray.append(rocket.state_vector["theta"] * 180/pi)
            xPositionArray.append(rocket.state_vector["px"])
            yPositionArray.append(rocket.state_vector["py"])
            tvcAngleArray.append(rocket.state_vector["tvcAngle"])
            
            pidCommand = pid.compute(rocket.state_vector["theta"], deltaTime/1000)
            pidCommandArray.append(pidCommand)
            rocket.tvcCalculations(pidCommand)
            time += deltaTime

        graphs = [(timeArray, orientationArray), (timeArray, xPositionArray), (timeArray, yPositionArray), (timeArray, tvcAngleArray), (timeArray, pidCommandArray)]
        graph.showGraphs(graphs)
        print(pidCommandArray)
 
    if __name__ == "__main__":
        run()


