// Include the libraries we need
#include <OneWire.h>
#include <DallasTemperature.h>

#include "temp.h"

OneWire oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);

void Sensor_Temp_Init() {
  pinMode(ONE_WIRE_BUS, INPUT); // change it to registers
  sensors.begin();
}

float Get_Temp(){
  sensors.requestTemperatures(); // Send the command to get temperatures
  return sensors.getTempCByIndex(0);
}