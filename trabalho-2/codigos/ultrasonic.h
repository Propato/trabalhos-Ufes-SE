#ifndef ULTRASONIC_H
#define ULTRASONIC_H

#define TRIG_PIN 19 // Ultrasonic Sensor's TRIG pin
#define ECHO_PIN 17 // Ultrasonic Sensor's ECHO pin

void Sensor_Ultrasonic_Init();

float Get_Height();

#endif // ULTRASONIC_H