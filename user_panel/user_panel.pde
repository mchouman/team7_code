import controlP5.*;

ControlP5 cp5;

String num1, num2;
int x=910, time_y=190, temp_y=210, str_y=230, ph_y=250, time=0, i=0, line=0;
int[] data_time= {0, 0, 0, 0, 0};
long currentTime = 0;

void setup() {
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
  
  num1="25";
  num2="35";
}

void Change() {
  num1= cp5.get(Textfield.class, "1").getText();
  num2= cp5.get(Textfield.class, "2").getText();
}  

void Default() {
  num1="25";
  num2="35";
}

void draw() {
  background(255);
  adjustment();
  title();
  dataDisplay();
  record();
  println(num1);
  println(num2);
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
  textSize(60);
  text("~", 580, 290);
  textSize(32);
  text("°C", 530, 285);
  text("°C", 750, 285);
  textSize(15);
  text("* 25°C to 35°C", 420, 390);
  fill(220);
  line(-10, 111, 1300, 111);
}

void dataDisplay() {
  stroke(150);
  rect(50, 250, 250, 50, 10, 10, 10, 10);
  rect(50, 350, 250, 50, 10, 10, 10, 10);
  rect(50, 450, 250, 50, 10, 10, 10, 10);
  line(340, 111, 340, 700);
}

void adjustment() {
  stroke(0);
  fill(255);
  rect(420, 250, 100, 50, 10, 10, 10, 10);
  rect(640, 250, 100, 50, 10, 10, 10, 10);
  stroke(100);
  fill(220);
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
    text("-Temperature is "+"°C", x, temp_y);
    text("-Stirring Speed is "+"rpm", x, str_y);
    text("-pH Value is ", x, ph_y);
  }
  if (line>=2&&line<=5) {
    text("At "+data_time[1]+"sec:", x, time_y+100);
    text("-Temperature is "+"°C", x, temp_y+100);
    text("-Stirring Speed is "+"rpm", x, str_y+100);
    text("-pH Value is ", x, ph_y+100);
  }
  if (line>=3&&line<=5) {
    text("At "+data_time[2]+"sec:", x, time_y+200);
    text("-Temperature is "+"°C", x, temp_y+200);
    text("-Stirring Speed is "+"rpm", x, str_y+200);
    text("-pH Value is ", x, ph_y+200);
  }
  if (line>=4&&line<=5) {
    text("At "+data_time[3]+"sec:", x, time_y+300);
    text("-Temperature is "+"°C", x, temp_y+300);
    text("-Stirring Speed is "+"rpm", x, str_y+300);
    text("-pH Value is ", x, ph_y+300);
  }
  if (line==5) {
    text("At "+data_time[4]+"sec:", x, time_y+400);
    text("-Temperature is "+"°C", x, temp_y+400);
    text("-Stirring Speed is "+"rpm", x, str_y+400);
    text("-pH Value is ", x, ph_y+400);
  }
}