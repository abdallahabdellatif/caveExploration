# Cave Exploration
A cave exploration system that helps explorers go down the cave, written in VHDL and implemented on Altera DE10-Lite FPGA.

## Introduction
The main goal of the project is to implement a cave exploration system that helps explorers go down the cave with no risk of not being able to go back up using an ultrasonic sensor to be able to keep track the distance travelled downward by a dc motor in the cave, while also implementing an embedded lighting system deep down inside the cave which is mainly done to help the explorers by emitting lights upon need only to save energy using a photoresistor light sensor. 


## Sensors
### 1)	Photoresistor light sensor
<img src="./img/Photoresistor%20light%20sensor.png" alt="Photoresistor Light Sensor" width="200"/>

A photoresistor is a variable resistor that is affected by the light. When the light intensity increases, the resisance of the resistor decreases and vice versa; this functionality is used to be able to know if there isn’t enough light in the cave and depending on the input to the fpga we will illuminate the cave.



### 2)	 Ultrasonic sensor (HC-SR04)
<img src="./img/Ultrasonic sensor (HC-SR04).png" alt="Ultrasonic Sensor" width="200"/>

The ultrasonic sensor uses sonar to determine the distance to an object. The transmitter (trig pin) sends a signal which will be reflected by the object and received by the other transmitter(echo pin); the distance is calculated by multiplying the already known sound’s velocity by the time between sending and receiving the emitted signal.



## Outputs
### 1)	Seven segment display
<img src="./img/7-segment display.png" alt="7-Seg Display" width="200"/>

The seven segment display is an electronic device that is able to display numbers depending on the its inputs (7 inputs). It will be used to inform us how much did the explorer go down the cave.

 
### 2) DC Motor
<img src="./img/DC Motor.png" alt="DC Motor" width="200"/>

The DC motor is used to make the explorer be able to go down in the cave or to lift him up. We can’t directly control the motor depending on the inputs coming from the ultrasonic sensor to we had to use a motor driver. 
 
 
## Implementing the system
First of all, the enable switch has to be on so that the explorer is able to go down the cave by the motor. The motor will start rotating until the enable is switched off or the ultrasonic sensor states that the distance is greater than 45. If the enable is switched off then he will stop, and if the distance is greater than 45 then the motor will start pulling the explorer up until the distance is equal to 10 then it will stop. The light sensor is used to detect if the light is low then a led will be illuminated.
