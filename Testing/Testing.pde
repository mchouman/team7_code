import controlP5.*;
import processing.serial.*;

ControlP5 cp5;

Serial myPort;
FloatList temp;
FloatList ph;
IntList stirSpeed;
int time = 0;

void setup(){
  cp5 = new ControlP5(this);
  cp5.addButton("TEMPERATURE").setValue(0).setPosition(500,393).setSize(80,40); 
  cp5.addButton("PH").setValue(0).setPosition(625,393).setSize(80,40); 
  cp5.addButton("STIRRING_SPEED").setValue(0).setPosition(750,393).setSize(80,40); 
  temp = new FloatList();
  ph = new FloatList();
  stirSpeed = new IntList();
  size(1280,680);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw(){
  background(255);
  adjustment();
  title();
  dataDisplay();
  drawGraph();
  log();
}  

void title(){
  stroke(160);
  rect(-10,0,1300,110,0,0,18,18);
  fill(30);
  textSize(20);
  text("Temperature (°C):",50,240);
  text("pH Value:",50,390);
  text("Stirring Speed (rpm):", 50,540);
  textSize(64);
  text("Bioreactor UI",430,80);
  textSize(35);
  text("Status:",20,200);
  textSize(35);
  text("Temperature Adjustment:",360,200);
  textSize(60);
  text("~",550,290);
  textSize(18);
  text("Default",440,351);
  text("Change",558,351);
  textSize(35);
  text("Graph :",360,420);
  fill(220);
  line(-10,111,1300,111);
  
}

void dataDisplay(){
  getValues();
  stroke(150);
  fill(153);
  rect(50,250,250,50,10,10,10,10);
  rect(50,400,250,50,10,10,10,10);
  rect(50,550,250,50,10,10,10,10);
  fill(30);
  textSize(30);
  text(String.format("%.1f",temp.get(temp.size()-1)), 135, 290);
  //text(String.format("%.1f",ph.get(ph.size()-1)), 135, 440);
  //text(stirSpeed.get(stirSpeed.size()-1), 135, 590);
  line(340,111,340,700);
  delay(1000);
}

void adjustment(){
  stroke(0);
  fill(255);
  rect(420,250,100,50,10,10,10,10);
  rect(620,250,100,50,10,10,10,10);
  stroke(100);
  fill(200);
  rect(420,330,100,30,10,10,10,10);
  rect(540,330,100,30,10,10,10,10);
}

void log(){
  fill(0);
  rect(900,130,360,529);
}

void getValues()
{
  String val = "";
  if (myPort.available() > 0)
  {
    val = myPort.readStringUntil('\n');
  
    float value = float(trim(val));
    
    temp.append(value);
    //ph.append(val2[1]);
    //stirSpeed.append(int(val2[2]));
    
    println(temp);
  }
  //println(ph);
  //println(stirSpeed);
}

void drawGraph(){
  fill(0);
  line(400,450,400,660);
  line(400,660,800,660);
  int x = 400, y = 600;
  //text(".", x+time, y-temp.get(temp.size()-1));
  if (time == 0){
    line(x, y, x+time, y-temp.get(temp.size()-1));
  }
  else{
    line(x+time-1, y-temp.get(temp.size()-2), x+time, y-temp.get(temp.size()-1));
  }
  
  time++;
}