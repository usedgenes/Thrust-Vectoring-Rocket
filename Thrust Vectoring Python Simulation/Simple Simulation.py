import math
import matplotlib.pyplot as plt
import argparse

rocketAngle = []
tvcAngle = []
time = []
angleVelocity = []
angleAcceleration = []
force = []
dt = 0.001
proportional = 0;
derivative = 0;
integral = 0;

def setup(pGain, iGain, dGain, momentInertia, distance, delay):
    global Kp, Ki, Kd
    global mmoi, distanceToCenterOfMass, servoDelay
    Kp = pGain
    Ki = iGain
    Kd = dGain
    
    mmoi = momentInertia
    distanceToCenterOfMass = distance
    servoDelay = delay
    
    for x in range(0, int(servoDelay / dt)):
        rocketAngle.append(angle)
        tvcAngle.append(0)
        angleVelocity.append(0)
        angleAcceleration.append(0)
        force.append(0)
        time.append(x*dt)

def plot():
    plt.figure('TVC Simulator')

    grid = plt.GridSpec(2, 2, hspace=0.3)

    plt.subplot(grid[0, 0])
    plt.plot(time, rocketAngle, color='red')
    plt.title("Rocket angle")
    plt.xlabel("time (s)")
    plt.ylabel("angle (deg)")

    plt.subplot(grid[0, 1])
    plt.plot(time, tvcAngle, color='red')
    plt.title("TVC angle")
    plt.xlabel("time (s)")
    plt.ylabel("angle (deg)")

    plt.subplot(grid[1, 0])
    plt.plot(time, angleVelocity, color='red')
    plt.title("Angle velocity")
    plt.xlabel("time (s)")
    plt.ylabel("angle velocity (deg/s)")

    plt.subplot(grid[1, 1])
    plt.plot(time, force, color='red')
    plt.title("Angle acceleration")
    plt.xlabel("time (s)")
    plt.ylabel("angle acceleration (deg/s^2)")

    plt.show()
    
if __name__ == "__main__":
    setup(args)

    for x in range(int(servo_delay / dt) - 1, int(args.length / dt)):
        loop(x)

    plot()