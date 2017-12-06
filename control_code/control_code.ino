#include <math.h>

const int thermistorInputPin = 5;
const int heaterOutputPin = 6; 
float temperature = 0;
float T_LB = 25.0;
float T_UB = 35.0;
float getTemperature(int pinNumber);
long currentTime = 0;

void setup()
{
  Serial.begin(9600); 
  
  pinMode(heaterOutputPin, OUTPUT); 
}

void loop()
{
  //Temperature code:
  temperature = getTemperature(thermistorInputPin);
  
  if(temperature <= T_LB+2)
  {
    digitalWrite(heaterOutputPin, HIGH); //turn heater on
  }
  else if(temperature >= T_UB-4)
  {
    digitalWrite(heaterOutputPin, LOW); //turn heater off
  }
  
  //read LB and UB
//  T_LB = (float)Serial.read()
//  T_UB = (float)Serial.read()
  
  //Stirring and pH code:
  //--------------------------------
  
  if(millis()-currentTime > 500) 
  {
    //the final string we print:
    Serial.println(temperature); 
    currentTime = millis();
  }  
}

//equation to calculate temperature (using the thermistor given) is taken from the following website:
//https://www.allaboutcircuits.com/projects/measuring-temperature-with-an-ntc-thermistor/
float getTemperature(int pinNumber)
{
  float temperature = 0;
  float thermistorResistence = 0;
  const float RESISTOR = 10000.0; //10,000 ohm resistor being used in series with thermistor
  const float MAX_ADC = 1023.0;
  const float BETA = 4220.0; //taken from thermistor data sheet
  const float ROOM_TEMP = 298.15; //in kelvin
  const float THERMISTOR_ROOM_TEMP = 10000.0; //resistence of the thermistor at 25 degrees Celcius
  
  float rawADC = analogRead(pinNumber); //read p.d. across resistor
  thermistorResistence = RESISTOR * ( (MAX_ADC / rawADC) - 1); //calculate resistence of thermistor from p.d. read previously 
  //calculate temperature using equation 1/t = 1/T + (1/BETA) * ln(r/R), where t is temperature, T is 25 degrees Celcius, 
  //BETA is a constant specific to the thermistor, r is resistence of the thermistor, and R is resistence of the thermistor at 25 degrees Celcius.
  temperature = (BETA * ROOM_TEMP) / (BETA + (ROOM_TEMP * logf(thermistorResistence / THERMISTOR_ROOM_TEMP)));
  return temperature - 273.15; //convert from kelvin to degrees Celcius
}

