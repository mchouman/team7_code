#include <math.h>

//heating
const int thermistorInputPin = 7;
const int heaterOutputPin = 6; 
float temperature = 0;
float T_LB = 25.0;
float T_UB = 35.0;
float getTemperature(int pinNumber);
long currentTime = 0;
int av_T = 0;

//stirring
const int motorPin = 14;
const int sensorPin = 5;
int rpmLow = 500;
int rpmHigh = 1500;
int rpmMid;
int rpmCurrent;
long lastMillis;
float power; 

//pH
#define OFFSET 1.18
int SensorPin= 2;    //Analog Input pH sensor pin number
float avgValue;  //Store the average value of the sensor feedback
float mvValue, ph, consts, tempo;
int buf[10];
double const R=8.314510;
double const F=9.6485309*pow(10,4);
float temp=25.0;
float kel=273.15;

void setup()
{
  Serial.begin(9600); 
  
  // Heating
  pinMode(heaterOutputPin, OUTPUT); 

  // Stirring
  pinMode(motorPin, OUTPUT); // motor for stirring
  pinMode(sensorPin, INPUT_PULLUP); //sensor for measuring RPM
  attachInterrupt(sensorPin, updateRpm, RISING);
  power = 0.0; //set initial motor speed to 0
  rpmCurrent = 0; //set initial RPM to 0
  rpmMid = (rpmHigh + rpmLow) / 2;
  
  //pH
  pinMode(12,OUTPUT); 
  pinMode(13,OUTPUT);
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
  
  //read data from processing for set-point adjustment
  while (Serial.available() > 0)
 { 
    int rawInput = Serial.parseInt();
    char cc = Serial.read();
    
    if (cc == 'b')
    {
      av_T = rawInput;
    }
    else if(cc == 'a')
    {
      rpmMid = rawInput;
    }
    
    T_LB = av_T - 5;
    T_UB = av_T + 5;    
 } 
 
  //Stirring code:
  if (rpmCurrent < rpmMid - 100 && power < 255) //if too slow
  {
    power += 0.025; //increase speed in small steps
    analogWrite(motorPin, power);
  }
  else if (rpmCurrent > rpmMid + 100 && power > 0) //if too fast
  {
    power -= 0.025; //decrease speed in small steps
    analogWrite(motorPin, power);
  }
  else
  {
    analogWrite(motorPin, power); // maintain current motor speed
  }
  
  //pH code:
  for (int i=0;i<10;i++)       //Get 10 sample value from the sensor for smooth the value
  { 
    buf[i]=analogRead(SensorPin);
  }
  for (int i=0;i<9;i++)        //sort the analog from small to large
  {
    for (int j=i+1;j<10;j++)
    {
      if(buf[i]>buf[j])
      {
        tempo=buf[i];
        buf[i]=buf[j];
        buf[j]=tempo;
      }
    }
  }
  consts=58.167;
  avgValue=0;
  for(int i=2;i<8;i++) {                      //take the average value of 6 center sample
    avgValue+=buf[i];
    avgValue = (avgValue/6);
    if (avgValue>512)               //keep 0 to 512 as positive mV respectively
     avgValue=0-(avgValue-512);    //converts 512 to 1024 TO GIVE 0 TO -512mV respectively
    temp=(float) temp+274.15;      //converting degree to kelvin
    ph=(float)(0-avgValue)/(OFFSET*consts*(temp/kel))+7;  //convert the mV to pH  
  }
  
  if (ph<4) {   
    digitalWrite(13, HIGH); 
    digitalWrite(12, LOW);
  }
  else if (ph>6) {
    digitalWrite(12, HIGH);
    digitalWrite(13, LOW);
  }
  else {
    digitalWrite(12,LOW);
    digitalWrite(13,LOW);
  }
  
  //The final string we print that goes to the UI:
  Serial.print(temperature);
  Serial.print(",");
  Serial.print(rpmCurrent);
  Serial.print(",");
  Serial.println(ph);
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

