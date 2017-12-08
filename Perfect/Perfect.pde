import controlP5.*;
import processing.serial.*;

ControlP5 cp5;
Serial myPort;

String num1="25", num2="35";
int x=910, time_y=190, temp_y=210, str_y=230, ph_y=250, time=0, time2=0, i=0, ii=0, line=0, key0=1, key1=0, key2=0, key3=0, key4=0, stirs=0, average=30;
Float temps=0.00, phs=0.0;
int[] data_time= {0, 0, 0, 0, 0}, stir_list={0,0,0,0,0};
long currentTime = 0, storeTime=0, monitorTime=0;
Float[] temp_list={0.00,0.00,0.00,0.00,0.00}, pH_list={0.0,0.0,0.0,0.0,0.0}, input_list={0.00, 0.00, 0.00};
Table table;
int val2=0;
float val1=0.00, val3=0.0;
String num3="500",num4="1500";//ADD
int average1=1000;//ADD

void setup() {
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 9600);
  size(1280, 680);
  cp5 = new ControlP5(this);
  cp5.addTextfield("1").setPosition(450, 255).setSize(68, 40).setFont(createFont("arial", 26)).setColor(0)
    .setAutoClear(false).setColorBackground(0XFFFFFFFF).setColorForeground(0XFFFFFFFF).setColorActive(0XFFFFFFFF);

  cp5.addTextfield("2").setPosition(670, 255).setSize(68, 40).setFont(createFont("arial", 26)).setColor(0)
    .setAutoClear(false).setColorBackground(0XFFFFFFFF).setColorForeground(0XFFFFFFFF).setColorActive(0XFFFFFFFF);

  cp5.addButton("Change").setPosition(540, 330).setSize(100, 35).setFont(createFont("arial", 17)).setColorLabel(0)
    .setColorBackground(0XFFABB2B9).setColorForeground(0XFF5499C7);

  cp5.addButton("Default").setPosition(420, 330).setSize(100, 35).setFont(createFont("arial", 17)).setColorLabel(0)
    .setColorBackground(0XFFABB2B9).setColorForeground(0XFF5499C7);
    
  cp5.addTextfield("3").setPosition(440, 505).setSize(68, 40).setFont(createFont("arial", 26)).setColor(0)
    .setAutoClear(false).setColorBackground(0XFFFFFFFF).setColorForeground(0XFFFFFFFF).setColorActive(0XFFFFFFFF);//ADD

  cp5.addTextfield("4").setPosition(660, 505).setSize(68, 40).setFont(createFont("arial", 26)).setColor(0)
    .setAutoClear(false).setColorBackground(0XFFFFFFFF).setColorForeground(0XFFFFFFFF).setColorActive(0XFFFFFFFF);//ADD
    
  cp5.addButton("CHANGE").setPosition(540, 580).setSize(100, 35).setFont(createFont("arial", 17)).setColorLabel(0)
    .setColorBackground(0XFFABB2B9).setColorForeground(0XFF5499C7);//ADD

  cp5.addButton("DEFAULT").setPosition(420, 580).setSize(100, 35).setFont(createFont("arial", 17)).setColorLabel(0)
    .setColorBackground(0XFFABB2B9).setColorForeground(0XFF5499C7);//ADD
  
  table=new Table();
  table.addColumn("Time(s)");
  table.addColumn("Temperature(°C)");
  table.addColumn("Stirring Speed(rpm)");
  table.addColumn("pH Value");
}

void Change() {
  num1= cp5.get(Textfield.class, "1").getText();
  num2= cp5.get(Textfield.class, "2").getText();
  average=(int(num1)+int(num2))/2;
}  

void Default() {
  num1="25";
  num2="35";
  average=(int(num1)+int(num2))/2;
}

void CHANGE(){
  num3= cp5.get(Textfield.class, "3").getText();
  num4= cp5.get(Textfield.class, "4").getText();
  average1=(int(num3)+int(num4))/2;
}
//ADD

void DEFAULT(){
  num3="500";
  num4="1500";
  average1=(int(num3)+int(num4))/2;
}
//ADD

void draw() {
  background(255);
  adjustment();
  title();
  dataDisplay();
  store();
  record();
  myPort.write("a" + str(average));
  myPort.write("b" + str(average1));//ADD
  println("a" + str(average));
  println("b" + str(average1));
}  

void title() {
  stroke(160);
  rect(-10, 0, 1300, 110, 0, 0, 18, 18);
  fill(30);
  textSize(64);
  text("Bioreactor UI", 430, 80);
  textSize(35);
  text("Status:", 20, 200);
  textSize(35);
  text("Temperature Adjustment:", 360, 200);
  text("Stirring Speed Adjustment:",360,445);//ADD
  textSize(60);
  text("~", 580, 290);
  text("~",590,545);//ADD
  textSize(32);
  text("°C", 530, 285);
  text("°C", 750, 285);
  text("rpm",525,540);//ADD
  text("rpm",750,540);//ADD
  textSize(15);
  text("* 25°C to 35°C", 420, 390);
  text("* 500rpm to 1500rpm",420,640);//ADD
  fill(220);
  line(-10, 111, 1300, 111);
}

void dataDisplay() {
  getValues();
  stroke(150);
  rect(30, 250, 275, 50, 10, 10, 10, 10);
  rect(30, 350, 275, 50, 10, 10, 10, 10);
  rect(30, 450, 275, 50, 10, 10, 10, 10);
  line(340, 111, 340, 700);
  fill(30);
  textSize(20);
  text("Temperature :",40, 285);
  text("°C",250, 285);
  text("Stirring :", 40, 385);
  text("rpm", 250, 385);
  text("pH Value :",40, 485);
  text(String.format("%.2f",val1), 185, 285);
  text(val2, 185, 385);
  text(String.format("%.1f",val3), 185, 485);
}

void adjustment() {
  stroke(0);
  fill(255);
  rect(420, 250, 100, 50, 10, 10, 10, 10);
  rect(640, 250, 100, 50, 10, 10, 10, 10);
  rect(420, 500, 100, 50, 10, 10, 10, 10);//ADD
  rect(640, 500, 100, 50, 10, 10, 10, 10);//ADD
  stroke(100);
  fill(220);
}

void store(){
  if ((millis()-storeTime)>9999){
    ii=1;
    if(key0==1&&ii==1){
      temp_list[0]=temps;
      pH_list[0]=phs;
      stir_list[0]=stirs;
      time2+=10;  
      TableRow newRow = table.addRow();
      newRow.setInt("Time(s)", time2);
      newRow.setFloat("Temperature(°C)",temp_list[0]);
      newRow.setInt("Stirring Speed(rpm)",stir_list[0]);
      newRow.setFloat("pH Value",pH_list[0]);
      saveTable(table,"Perfect/Perfect.csv");
      key0=0;
      key1=1;
      ii=0;
    }
    if(key1==1&&ii==1){
      temp_list[1]=temps;
      pH_list[1]=phs;
      stir_list[1]=stirs;
      time2+=10;  
      TableRow newRow = table.addRow();
      newRow.setInt("Time(s)", time2);
      newRow.setFloat("Temperature(°C)",temp_list[1]);
      newRow.setInt("Stirring Speed(rpm)",stir_list[1]);
      newRow.setFloat("pH Value",pH_list[1]);
      saveTable(table,"Perfect/Perfect.csv");
      key1=0;
      key2=1;
      ii=0;
    }
    if(key2==1&&ii==1){
      temp_list[2]=temps;
      pH_list[2]=phs;
      stir_list[2]=stirs;
      time2+=10;  
      TableRow newRow = table.addRow();
      newRow.setInt("Time(s)", time2);
      newRow.setFloat("Temperature(°C)",temp_list[2]);
      newRow.setInt("Stirring Speed(rpm)",stir_list[2]);
      newRow.setFloat("pH Value",pH_list[2]);
      saveTable(table,"Perfect/Perfect.csv");
      key2=0;
      key3=1;
      ii=0;
    }
    if(key3==1&&ii==1){
      temp_list[3]=temps;
      pH_list[3]=phs;
      stir_list[3]=stirs;
      time2+=10;  
      TableRow newRow = table.addRow();
      newRow.setInt("Time(s)", time2);
      newRow.setFloat("Temperature(°C)",temp_list[3]);
      newRow.setInt("Stirring Speed(rpm)",stir_list[3]);
      newRow.setFloat("pH Value",pH_list[3]);
      saveTable(table,"Perfect/Perfect.csv");
      key3=0;
      key4=1;
      ii=0;
    }
    if(key4==1&&ii==1){
      temp_list[4]=temps;
      pH_list[4]=phs;
      stir_list[4]=stirs;
      time2+=10;  
      TableRow newRow = table.addRow();
      newRow.setInt("Time(s)", time2);
      newRow.setFloat("Temperature(°C)",temp_list[4]);
      newRow.setInt("Stirring Speed(rpm)",stir_list[4]);
      newRow.setFloat("pH Value",pH_list[4]);
      saveTable(table,"Perfect/Perfect.csv");
      key4=0;
      key0=1;
      ii=0;
    }
    storeTime=millis();
  }
}
void record() {
  fill(0);
  rect(900, 130, 360, 529);
  fill(255);
  textSize(16);
  text("Log:", x, 150);
  if (millis()-currentTime>1000){
  i+=1;
  if (((i-10)%50)==0) {
    line=0;
  }
  if ((i%10)==0) {
    line+=1;
    time+=10;
  }
  currentTime=millis();
  }
  if(line==1){
    data_time[0]=time;
  }
  if(line==2){
    data_time[1]=time;
  }
  if(line==3){
    data_time[2]=time;
  }
  if(line==4){
    data_time[3]=time;
  }
  if(line==5){
    data_time[4]=time;
  }
  if (line>=1&&line<=5) {
    text("At "+data_time[0]+"sec:", x, time_y);
    text("-Temperature is "+temp_list[0]+"°C", x, temp_y);
    text("-Stirring Speed is "+stir_list[0]+"rpm", x, str_y);
    text("-pH Value is "+pH_list[0], x, ph_y);
  }
  if (line>=2&&line<=5) {
    text("At "+data_time[1]+"sec:", x, time_y+100);
    text("-Temperature is "+temp_list[1]+"°C", x, temp_y+100);
    text("-Stirring Speed is "+stir_list[1]+"rpm", x, str_y+100);
    text("-pH Value is "+pH_list[1], x, ph_y+100);
  }
  if (line>=3&&line<=5) {
    text("At "+data_time[2]+"sec:", x, time_y+200);
    text("-Temperature is "+temp_list[2]+"°C", x, temp_y+200);
    text("-Stirring Speed is "+stir_list[2]+"rpm", x, str_y+200);
    text("-pH Value is "+pH_list[2], x, ph_y+200);
  }
  if (line>=4&&line<=5) {
    text("At "+data_time[3]+"sec:", x, time_y+300);
    text("-Temperature is "+temp_list[3]+"°C", x, temp_y+300);
    text("-Stirring Speed is "+stir_list[3]+"rpm", x, str_y+300);
    text("-pH Value is "+pH_list[3], x, ph_y+300);
  }
  if (line==5) {
    text("At "+data_time[4]+"sec:", x, time_y+400);
    text("-Temperature is "+temp_list[4]+"°C", x, temp_y+400);
    text("-Stirring Speed is "+stir_list[4]+"rpm", x, str_y+400);
    text("-pH Value is "+pH_list[4], x, ph_y+400);
  }
}

void getValues(){
  String val = "";
  if ( myPort.available() > 0) {
    val = myPort.readStringUntil('\n');
    if (val != null){
      float[] inputs = float(trim(split(val, ',')));
      if(inputs.length == 3){
        temps = inputs[0];
        stirs = int(inputs[1]);
        phs = inputs[2];
        if (millis()- monitorTime > 500){
          val1= temps;
          val2 = stirs;
          val3= phs;
          monitorTime = millis();
        }
      }
    }
  }
}