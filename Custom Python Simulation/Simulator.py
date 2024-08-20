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
        initial_state_vector = {"ay" : 0 ,"vy" : 0,"py" : 0,"ax" : 0 ,"vx" : 0,"px" : 0 ,"alpha": 0.0,"omega" : 0,"theta" : 1}
        tvcAngle= 0
        #initial_state_vector, mass, mmoi, servoLimit, distance_TVC_COM
        rocket = Rocket.Rocket(initial_state_vector, 0.65, 0.1, 0.27, 0.3)
        Thrust = MotorThrustCurve.ThrustCurve("AeroTech_F67W.csv", 0.08, 0.03)
        Pid = PID.PID(0.01, 0.01, 0.01, 60, 0)
        Graph = Grapher.Grapher()
        
        timeArray = []
        orientationArray = []
        xPositionArray = []
        yPositionArray = []
        
        orientationGraph = {"x" : "time(s)", "y" : "angle(theta)", "title" : "Theta"}
        xPositionGraph = {"x" : "time(s)", "y" : "Pos X", "title" : "Position X"}
        yPositionGraph = {"x" : "time(s)", "y" : "Pos Y", "title" : "Position Y"}
        graphs_dict = [orientationGraph, xPositionGraph, yPositionGraph]
        Graph.graphsHandler(3, graphs_dict)
        
        
        while(time <= runtime):
            thrust = Thrust.getThrust(time/1000)
            forces = rocket.tvcPhysics(tvcAngle, thrust, deltaTime/1000)
            rocket.inputForces(forces, deltaTime/1000)
            
            timeArray.append(time/1000)
            orientationArray.append(rocket.state_vector["theta"])
            xPositionArray.append(rocket.state_vector["px"])
            yPositionArray.append(rocket.state_vector["py"])

            time += deltaTime

        graphs = [(timeArray, orientationArray), (timeArray, xPositionArray), (timeArray, yPositionArray)]
        Graph.showGraphs(graphs)
 
    if __name__ == "__main__":
        run()


