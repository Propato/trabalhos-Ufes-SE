#include "tick_sys.h"
#include "tt_tasks.h"
#include "temp.h"
#include "ultrasonic.h"
#include "web.h"

#include <PID_v1.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
 
// PINS
#define BOMBA_PIN 32
#define RELE_PIN 4

#define FAIXA_TEMP 2

// Values for timing
#define TIMER_DIVIDER         80           // Hardware timer clock divider (80MHz / 80 = 1MHz)
#define TIMER_SCALE           (APB_CLK_FREQ / TIMER_DIVIDER)  // Convert counter value to seconds
#define TIMER_INTERVAL_SEC    (1.0 / 1000.0) // Timer interval, 1ms (1kHz)

// Values for web server
// Uma forma de lidar com clientes reais seria, caso a conexao com wifi nao funcionasse, o esp32 abrira sua própria rede para o usuario se conectar e passar os dados do wifi.
#define SSID                  "Propato"   // Wifi name to connect
#define PASSWORD              "12345678"  //WIfi password to connect
#define HOST                  "esp32"   // http://{host}.local

double wanted_temp = 25.0;
double wanted_height = 20.0;
double height, Output;
double Kp=5, Ki=3, Kd=0.5;

void Set_Wants(){
  wanted_temp = Get_Wanted_Temp();
  wanted_height = Get_Wanted_Height();
}

LiquidCrystal_I2C lcd(0x3F, 16, 2);

/*
PID e saídas.
*/
PID myPID(&height, &Output, &wanted_height, Kp, Ki, Kd, DIRECT);

void Set_PID(){
  height = Get_Height();
  myPID.Compute();
  analogWrite(BOMBA_PIN, Output);

  //  Faixa de temperatura = wanted_temp += 2
  if(wanted_temp < (Get_Temp())){
    digitalWrite(RELE_PIN, 0);
    // Serial.println("DESLIGADO");
  }

  if(wanted_temp > (Get_Temp())){
    digitalWrite(RELE_PIN, 1);
    // Serial.println("LIGADO");
  }

  Serial.println(Get_Height());
  Serial.println(Output);
}

void Set_LCD(){
  lcd.clear();
  
  lcd.setCursor(0, 0);
  lcd.print("Altura: ");
  lcd.print(Get_Height());
  lcd.print(" cm");
  lcd.setCursor(0, 1);
  lcd.print("Temp: ");
  lcd.print(Get_Temp());
  lcd.print(" C");
}

void setup() {
  Serial.begin(115200);
  pinMode(RELE_PIN, OUTPUT);
  
  Sensor_Temp_Init(); // Temp Sensor Pin defined in temp.h
  Sensor_Ultrasonic_Init(); // Ultrasonic Sensor Pins defined in ultrasonic.h
  Server_Init(SSID, PASSWORD, HOST);

  //turn the PID on
  height = Get_Height();
  myPID.SetMode(AUTOMATIC);

  //Init LCD
  lcd.init();
  lcd.backlight();

  /* Initialize Task Kernel */
  Task_Init();
  Task_Add(handleServer, 1, 0); // 1ms to handle users interactions
  Task_Add(Set_Wants, 3000, 0); // 2s to update the wanted values
  Task_Add(Set_PID, 500, 0); // 500ms to update the wanted values
  Task_Add(Set_LCD, 3000, 0); // 3s to update the wanted values
  
  /* Init timer */
  Config_TIMER_Int(TIMER_DIVIDER, TIMER_SCALE, TIMER_INTERVAL_SEC);
}

void loop() {
  Task_Dispatch();
}