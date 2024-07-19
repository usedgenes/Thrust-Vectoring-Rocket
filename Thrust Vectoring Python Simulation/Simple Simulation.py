import math
import matplotlib.pyplot as plt
import argparse
import MotorThrustCurve 

rocketAngle = []
tvcAngle = []
time = []
angleVelocity = []
angleAcceleration = []
force = []
dt = 1
proportional = 0;
derivative = 0;
integral = 0;

def setup(pGain, iGain, dGain, momentInertia, distance, delay, initialAngle):
    global Kp, Ki, Kd
    global mmoi, distanceToCenterOfMass, servoDelay, thrust
    Kp = pGain
    Ki = iGain
    Kd = dGain
    
    mmoi = momentInertia
    distanceToCenterOfMass = distance
    servoDelay = delay
    
    for x in range(0, int(servoDelay / dt)):
        rocketAngle.append(initialAngle)
        tvcAngle.append(0)
        angleVelocity.append(0)
        angleAcceleration.append(0)
        force.append(0)
        time.append(x*dt)

def getForce(tvc_angle, iteration):
    if tvc_angle[iteration] > 10:
        tvc_angle[iteration] = 10
    elif tvc_angle[iteration] < -10:
        tvc_angle[iteration] = -10
    print(thrust.getThrust(iteration/1000))
    force.append(thrust.getThrust(iteration/1000) *  
              math.sin(math.radians(tvcAngle[iteration-int(servoDelay/dt)])))
    return thrust.getThrust(iteration/1000)*math.sin(math.radians(tvcAngle[iteration-int(servoDelay/dt)]))
    
def getAngle(force, iteration):
    angleAcceleration.append(math.degrees(
        (force * distanceToCenterOfMass) / mmoi))
    angleVelocity.append(
        angleVelocity[iteration] + angleAcceleration[iteration + 1] * dt)
    rocketAngle.append(
        rocketAngle[iteration] + angleVelocity[iteration + 1] * dt)


def loop(iteration):
    global integral
    tvcForce = getForce(tvcAngle, iteration)
    getAngle(tvcForce, iteration)
    proportional = Kp * rocketAngle[iteration+1]
    integral += Ki * rocketAngle[iteration+1] * dt
    derivative = Kd * \
        (rocketAngle[iteration+1] - rocketAngle[iteration]) / dt
    tvcAngle.append(proportional + integral + derivative)
    time.append(time[iteration] + dt)
    
def plot():
    plt.figure('TVC Simulator')

    grid = plt.GridSpec(2, 2, hspace=0.3)

    plt.subplot(grid[0, 0])
    plt.plot(time, rocketAngle, color='red')
    plt.title("Rocket angle")
    plt.xlabel("time (ms)")
    plt.ylabel("angle (deg)")

    plt.subplot(grid[0, 1])
    plt.plot(time, tvcAngle, color='red')
    plt.title("TVC angle")
    plt.xlabel("time (ms)")
    plt.ylabel("angle (deg)")

    plt.subplot(grid[1, 0])
    plt.plot(time, angleVelocity, color='red')
    plt.title("Angle velocity")
    plt.xlabel("time (ms)")
    plt.ylabel("angle velocity (deg/s)")

    plt.subplot(grid[1, 1])
    plt.plot(time, force, color='red')
    plt.title("Angle acceleration")
    plt.xlabel("time (ms)")
    plt.ylabel("angle acceleration (deg/s^2)")

    plt.show()
    
if __name__ == "__main__":
    global thrust
    #pGain, iGain, dGain, momentInertia, distanceFromEngineToCenterOfMass, seroDelay, initialAngle
    setup(0.5, 0.2, 0.2, 0.03, 0.21, 50, 10)
    thrust = MotorThrustCurve.ThrustCurve("AeroTech_F67W.csv", 0.08, 0.03)
    
    
    for x in range(int(servoDelay / dt) - 1, int(5000/ dt)):
        loop(x)

    plot()