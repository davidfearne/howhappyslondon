# howhappyslondon

## Abstract
How Happys London (2HL) was devised as a way for easily demonstrating the power of large-scale analytics. By looking at multiple freely available data sources and applying simplistic weighting algorithms it is possible to get a point in time consensus as to the happiness of London. This demonstration is designed to give the observer an idea of how to take the methods and theories employed in 2HL and apply them inside their own business. 
2HL is a demonstration of both net result and visual analytics. It leverages both structured and semi structured data sources to process 2.6 billion data points a day to answer 1 single point in time question accurately “Is London happy?”

## Overview
Whenever faced with an analytics problem it is important to define first what the required outcome will be. From this point you can work backwards from the business need rather than up to an outcome that may not match what the business required. This is critical of all major technology projects undertaken today but few have such large business impact as analytics. Its entire goal is to aid and inform better business decision making. It’s also important to define the final purpose of the analytics process. Will the result drive automated changes, display greater details or provide point in time or predictive single decision assistance. 
The goal set for 2HL was to design a system that could show the power of analytics in such a way that its message could be understood by the board room executives, operational executives and middle management. 
This required an approach that could engage a user helping them to understand how to gain a point in time snapshot of their business or organization but also from this delve deeper into the data to identify opportunities to gain a business advantage over the competition. 
The demonstration needed to show how this is achieved using large sets of data that were unrelated in themselves but once used to enrich the initial data streams became valuable insights that were simply unachievable via conventional methods such as Excel.
2HL uses data sources found in London to create a point in time predictive analysis of weather London is generally happy, indifferent or unhappy. This is then used to control a video representation of a face that, Smiles frowns or look sad. Around the outside of the face we then display the various data breakout points were we have processed certain data to create our indexes.
Note. 2HL is not a best practice implementation. It is designed to be a demonstration of different methodologies and techniques that could be implemented to help businesses gain commercial or intellectual advantage. The goal of the system and this paper is to be used as a reference architecture to be extended and consolidated to provide a more focused solution.


 /**
* IBM IoT Foundation using HTTP
* 
* Author: Ant Elder
* License: Apache License v2
*/
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

//-------- Customise these values -----------
const char* ssid = "SKY10D3A";
const char* password = "FWDXFXUT";

#define ORG "ltmayn" // your organization or "quickstart"
#define DEVICE_TYPE "ESP8266" // use this default for quickstart or customize to your registered device type
#define DEVICE_ID "Test1" // use this default for quickstart or customize to your registered device id
#define TOKEN "&?OIRTW8rKo8UhVo4T" // not used with "quickstart"
#define EVENT "myEvent" // use this default or customize to your event type
//-------- Customise the above values --------

String url = "http://" ORG ".internetofthings.ibmcloud.com/api/v0002/device/types/" DEVICE_TYPE "/devices/" DEVICE_ID "/events/" EVENT;

void setup() {

   Serial.begin(115200); Serial.println(); 

   if (ORG != "quickstart") { // for POST URL doc see: https://docs.internetofthings.ibmcloud.com/messaging/HTTPSDevice.html
      url.replace("http://", String("https://use-token-auth:") + TOKEN + "@");
   }
   Serial.print("IoT Foundation URL: "); Serial.println(url);

   Serial.print("Connecting to: "); Serial.print(ssid);
   WiFi.begin(ssid, password); 
   while (WiFi.status() != WL_CONNECTED) {
     delay(500);
     Serial.print(".");
   }

   Serial.print("nWiFi connected, IP address: "); Serial.println(WiFi.localIP());
}

void loop() {
   HTTPClient http;
   http.begin(url);
   http.addHeader("Content-Type", "application/json");
   // a simple payload, for doc on payload format see: https://docs.internetofthings.ibmcloud.com/messaging/payload.html
   String payload = String("hello world"); 
   Serial.print("POST payload: "); Serial.println(payload);
   int httpCode = http.POST(payload);
   Serial.print("HTTP POST Response: "); Serial.println(httpCode); // HTTP code 200 means ok 
   http.end();
 
   delay(10000);
}

 
