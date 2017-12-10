#include <math.h>
#define OFFSET 1.18
int SensorPin= 6;    //Analog Input pH sensor pin number
float avgValue;  //Store the average value of the sensor feedback
float mvValue, ph, consts, tempo;
int buf[10];
double const R=8.314510;
double const F=9.6485309*pow(10,4);
float temp=25.0;
float kel=273.15;
void setup()
{
  pinMode(12,OUTPUT); 
  pinMode(13,OUTPUT);
  Serial.begin(9600);  
  Serial.println("Ready");    //Test the serial monitor
}
void loop()
{
  for (int i=0;i<10;i++)       //Get 10 sample value from the sensor for smooth the value
  { 
    buf[i]=analogRead(SensorPin);
    delay(10);
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
  
  Serial.println("PH: ");
  Serial.print(ph,4);
  Serial.println(" ");
  delay(1000);
  
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
}
