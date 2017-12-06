#include <math.h>

//heating
const int thermistorInputPin = 5;
const int heaterOutputPin = 6; 
float temperature = 0;
float T_LB = 25.0;
float T_UB = 35.0;
float getTemperature(int pinNumber);
long currentTime = 0;

//stirring
const int motorPin = 14;
const int sensorPin = 5;
int rpmLow = 500;
int rpmHigh = 1500;
int rpmMid;
int rpmCurrent;
long lastMillis;
float power; 

void setup()
{
  Serial.begin(9600); 

  // Heating
  pinMode(heaterOutputPin, OUTPUT); 

  // Stirring
  pinMode(motorPin, OUTPUT); // motor for 
  pinMode(sensorPin, INPUT_PULLUP);
  Serial.begin(9600); // baud rate 9600
  attachInterrupt(sensorPin, updateRpm, RISING);
  power = 0.0; //set initial motor speed to 0
  rpmCurrent = 0; //set initial RPM to 0
  rpmMid = (rpmHigh + rpmLow) / 2;
  
}

// Interrupt Function to calculate actual RPM of stirrer
void updateRpm() {
  long oneRevolution = 2 * (millis() - lastMillis); //time taken for one revolution (in milliseconds)
  lastMillis = millis(); 
  rpmCurrent = 60000 / oneRevolution; //converting into RPM
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
  
  //Stirring code:
  if (rpmCurrent < rpmMid - 100 && power < 255) //if too slow
  {
    power += 0.05; //increase speed
    analogWrite(motorPin, power);
  }
  else if (rpmCurrent > rpmMid + 100 && power > 0) //if too fast
  {
    power -= 0.05; //decrease speed
    analogWrite(motorPin, power);
  }
  else
  {
    analogWrite(motorPin, power); // maintain current motor speed
  }

  //Serial.println(rpmCurrent);

  //pH code
  
  
  //the final string we print:
//  Serial.println(temperature); 
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

