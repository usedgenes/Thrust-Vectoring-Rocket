# Thrust Vectoring Rocket
 
This is a project for building a thrust vector controlled rocket. The system is designed to fit a rocket booster of diameter 74mm (from Apogee Rockets), and is controlled by an ESP 32 along with a BMI088 IMU and BMP390 for sensor data. The motor used is an F15-0 from Estes, with the low average thrust helping to deal with the relatively weak structural strength of the 3D printed parts. A bluetooth app is used to get data from the flight computer, and can also be used to change the PID coefficients. So far, I've only tested the mechanism on the ground, though I plan to launch it in a rocket soon. 

Link to static test fire:
https://github.com/usedgenes/Thrust-Vectoring-Rocket/blob/main/Testing/gimbal%20test.MOV

There is also an iOS app to control and get data from the flight computer, and is located in the "Rocket" folder. You can open it in XCode and then run it on your own device to test. 

Link to CAD files: https://cad.onshape.com/documents/2ca9fc9211faac09d786cfb3/w/8b61a603854f19ea49b1fde7/e/632ef75d5f14d64c56a16a13?renderMode=0&uiState=66dbf6684d180e111ac254e3

![](https://github.com/usedgenes/Thrust-Vectoring-Rocket/blob/main/Testing/IMG_3164.jpg)
