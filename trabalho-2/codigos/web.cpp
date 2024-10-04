#include <WiFi.h>
#include <NetworkClient.h>
#include <WebServer.h>
#include <ESPmDNS.h>

#include "ultrasonic.h"
#include "temp.h"
#include "web.h"

const char *serverIndex = R"rawliteral(
<!DOCTYPE html>
<html>
<head>
  <title>ESP32</title>
  <script>
    function fetchData() {
      fetch('/data')
        .then(response => response.json())
        .then(data => {
          document.getElementById('temp').innerText = data.temp;
          document.getElementById('height').innerText = data.height;
        })
        .catch(error => console.error('Error fetching data:', error));
    }
    function fetchWantedData() {
      fetch('/data')
          .then(response => response.json())
          .then(data => {
            document.getElementById('inputTemp').placeholder  = data.wantedTemp;
            document.getElementById('inputHeight').placeholder  = data.wantedHeight;
          })
          .catch(error => console.error('Error fetching data:', error));
    }
    setInterval(fetchData, 500); // Fetch data every 500ms
    setInterval(fetchWantedData, 1000); // Fetch data every 1s
  </script>
<style>
    *{
      margin: 0;
      padding: 0;
    }
    body{
      background-color: rgb(157, 157, 157);
    }
    header{
      background-color:rgb(35, 34, 34);
      box-shadow: 3px 3px 8px 3px rgb(38, 37, 37);
      display: flex;
      align-items: center;
      justify-content: center;
      height: 10vh;
    }
    header h1{
      color: rgb(221, 221, 221);
    }

    main{
        display: flex;
        flex-direction: column;
        align-items: center;
    }

    .actualValues{
        margin: 5vh;
        padding-left: 5vh;
        padding-right: 5vh;
        background: rgb(26, 26, 89);
        box-shadow: 3px 3px 8px 3px rgb(31, 31, 104);
    }
    .actualValues div{
        color: rgb(210, 216, 223);
        margin: 4vh;
    }
    .wantedValues{
        height: 5vh;
        padding-left: 5vh;
        padding-right: 5vh;
        padding-top: 0.6vh;
        background: rgb(19, 120, 104);
        box-shadow: 3px 3px 8px 3px rgb(18, 120, 103);

        display: flex;
        align-items: center;
        justify-content: center;
    }
    .wantedValues div{
        color: rgb(210, 216, 223);
        margin: 4vh;
    }

    .button{
        height: 4vh;
        width: 6vw;
        background: rgb(25, 197, 168);
        color: aliceblue;
        border-radius: 20%;
    }

  </style>
</head>
<body>
    <header>
        <h1>ESP32 Web Server</h1>
    </header>

    <main>
      <div class="actualValues">
          <div>
            <p>Temperature: <span id="temp">Loading...</span> C</p>
          </div>
          <div>
            <p>Height: <span id="height">Loading...</span> cm</p>
          </div>
      </div>
      <div class="wantedValues">
          <form method='POST' action='/form' enctype='multipart/form-data'>
            <input id="inputTemp" type='text' name='temp' placeholder="...">
            <input id="inputHeight" type='text' name='height' placeholder="...">
            <input type='submit' value='form' class="button">
          </form>
      </div>
    </main>
</body>
</html>
)rawliteral";

// const char *ssid = "wifi_name";
// const char *password = "wife_password";
// const char *host = "esp32";

String wantedTemp = "25.00";
String wantedHeight = "20";

WebServer server(80);

void handleRoot() {
  server.send(200, "text/html", serverIndex);
}

void handleForm() {
  // Getting values
  wantedTemp = server.arg(0);
  wantedHeight = server.arg(1);

  server.sendHeader("Location", "/", true);
  server.send(302, "text/plain", "Redirect");
}

void handleData() {
  String jsonString = String("{\"temp\":") + "\"" + String(Get_Temp()) + "\"" + ",\"wantedTemp\":" + "\"" + wantedTemp + "\"" + ",\"height\":" + "\"" + String{Get_Height()} + "\"" + ",\"wantedHeight\":" + "\"" + wantedHeight + "\"" + "}";

  Serial.println(jsonString);

  // Send JSON response
  server.send(200, "application/json", jsonString);
}

void handleNotFound() {
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += (server.method() == HTTP_GET) ? "GET" : "POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";
  for (uint8_t i = 0; i < server.args(); i++) {
    message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
  }
  server.send(404, "text/plain", message);
}

float Get_Wanted_Temp(){
  return wantedTemp.toFloat();
}

float Get_Wanted_Height(){
  return wantedHeight.toFloat();
}

void Server_Init(const char *ssid, const char *password, const char *host) {
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  // Serial.println("");
  // Serial.print("Connected to ");
  // Serial.println(ssid);
  // Serial.print("IP address: ");
  // Serial.println(WiFi.localIP());

  if (MDNS.begin(host)) {
    Serial.println("MDNS responder started");
  }

  server.on("/", handleRoot);
  server.on("/form", HTTP_POST, handleForm);
  server.on("/data", handleData);
  server.onNotFound(handleNotFound);

  server.begin();
  Serial.println("HTTP server started");

  Serial.printf("Open http://%s.local or http://", host);
  Serial.print(WiFi.localIP());
  Serial.println(" in your browser\n");
}

void handleServer() {
  server.handleClient();
}
