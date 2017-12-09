#include <math.h>
#define OFFSET 0.00
int SensorPin= 6;    //Input pH sensor pin number     //pH meter Analog output to Arduino Analog Input 0
float avgValue;  //Store the average value of the sensor feedback
float mv, mvValue, ph;
int buf[10];
double const R=8.314510;
double const F=9.6485309*pow(10,4);
float temp=25;
void setup()
{
  pinMode(12,OUTPUT);  
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
        temp=buf[i];
        buf[i]=buf[j];
        buf[j]=temp;
      }
    }
  }
  avgValue=0;
  for(int i=2;i<8;i++) {                      //take the average value of 6 center sample
    avgValue+=buf[i];
    avgValue = ((float)avgValue/6)+OFFSET;
    mvValue=((float)avgValue*3.5)/1023; //convert the analog into millivolt
    temp=(float) temp+274.15;      //converting degree to kelvin
    ph=7+(float)(0-mvValue*F)/(R*temp*logf(10)); //convert the millivolt into pH value  
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
