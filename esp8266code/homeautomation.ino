#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
ESP8266WebServer server(80);

void handle404();

#define LED_PIN   D3   // if D3 not work just use 3





void setup() {

  //WiFi-Setup
  Serial.begin(9600);
  WiFi.begin("SSID", "PASSWORD"); //enter your ssid , password
  Serial.print("Connecting");
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
  Serial.println();

  Serial.print("Connected, IP address: ");
  Serial.println(WiFi.localIP());

  //Server-Setup
  server.on("/status", HTTP_POST, handleStatus);
  server.onNotFound(handle404);
  
  server.begin();
   // power-up safety delay
    pinMode(LED_PIN, OUTPUT);
   digitalWrite(LED_PIN, HIGH);
    
}


void loop()
{
    server.handleClient();

}



void handleStatus(){
  String bulboff ="0";
  if (!server.hasArg("bulb") || server.arg("bulb") == NULL  ){
        server.send(400, "text/plain", "400: Invalid Request");
        return;
      }

if(    server.arg("bulb")== bulboff){
  
  digitalWrite(LED_PIN, HIGH);
  
  
  
  }else{

 digitalWrite(LED_PIN, LOW);

    
  }



   Serial.println(server.arg("bulb"));
  server.send(200);
}

void handle404(){
  server.send(404, "text/plain", "404: Not found");
}
