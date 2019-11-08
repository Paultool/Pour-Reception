import processing.sound.*;
import oscP5.*;
import netP5.*;
import creativecoding.tact.*;
import processing.serial.*;

Tact tact;
TactSensor[] sensors;
OscP5 oscP5;
NetAddress dest;

SoundFile[] soundfiles;
SoundFile[] plings;
SoundFile water;
SoundFile vacuum;
LowPass lowPass;
Channel[] channels;

int sensorNum = 2;
float sensorLeft, sensorRight;
float dataLeft, dataRight; 
float[] arrayToWek = {}; 

long currentMillis;
long previousMillis = 0;

PFont f; 
boolean showGraph = true; 
int grid; 


////////////////////////////////////////////////////
//---------------START OF SETUP ------------------//
void setup() {
  size(800, 600);
  frameRate(50);

  f = createFont("Avenir-bold", 48); 
  textFont(f, 48);
  textAlign(CENTER);
  grid = width/10; 

  plings = new SoundFile[plingNames.length];
  soundfiles = new SoundFile[spectrum];
  channels = new Channel[spectrum];

  //Load soundfiles
  water = new SoundFile(this, "water.mp3");
  vacuum = new SoundFile(this, "vacuum.mp3");

  for (int i = 0; i < channels.length; i++) {
    channels[i] = new Channel(i);
    soundfiles[i] = new SoundFile(this, channelNames[i] + ".mp3");
    soundfiles[i].loop();
  }
  for (int i = 0; i < plings.length; i++) {
    plings[i] = new SoundFile(this, plingNames[i] + ".mp3");
    //plings[i].loop();
  }
  water.loop();
  vacuum.loop();
  vacuum.amp(0);
  lowPass = new LowPass(this);
  freq = 400;
  lowPass.process(soundfiles[index], freq);


  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448); 
  sendOscNames();

  tact = new Tact (this, 1);
  sensors = new TactSensor[sensorNum];
  for (int i=0; i < sensorNum; i++) {
    sensors[i] = tact.addSensor (i, 66, 32, 2); //base avr of 388 on right sensor full jar.
  }

  tact.startUpdates ();

  // initializing smoothing and calibration algorimthms
  initializeArrAvrage();
  initializeSingleAvr();
}
//-----------------END OF SETUP-------------------//
////////////////////////////////////////////////////




////////////////////////////////////////////////////
//---------------START OF Draw ------------------//
void draw() {
  currentMillis = millis();
  //arrays to store data to wekinator, and peak data from each sensor
  float[] rawDataToWek = {}; 
  float[] peakData = {0, 0};

  for (int i=0; i < sensorNum; i++) {
    // get sensor spectrum readings. Each sensor has 32 readings pr. spectrum
    TactSensor sensor = sensors[i];
    TactSpectrum mav = sensor.movingAverage();

    //get array of spectrum reads
    float[] values = mav.smooth();
    //get peak value for each (used in the graph)
    int peak = int (map (mav.peak(), sensor.minPeak(), sensor.maxPeak(), 255, 155));
    peakData[i] = peak; 

    //COMBINE READINGS TO 1 ARRAY FOR CONVINIENT AND FOR WIKINATOR
    rawDataToWek = concat(rawDataToWek, values);
  }


  //MOVING AVRAGE SMOOTH ON ARRAY
  arrayToWek = smoothArrayToWek(rawDataToWek);

  //SEND THE ARRAY TO DRAW GRAPH
  if (showGraph)
    drawGraph(arrayToWek, peakData);

  //SEND DATA TO WEKINATOR
  if (frameCount % 2 == 0) {
    if (!showGraph)showGesture(); 

    sendOsc(arrayToWek);

    sensorLeft = singleSensorSmooth(subset(arrayToWek, 0, 32));
    sensorRight = singleSensorSmooth(subset(arrayToWek, 32));

    //println("sensor Left: " + sensorLeft + "  |   " + "sensor right; " + sensorRight);
    //println("sensor left mapped: " + dataLeft + "  |  " + " sensor right mapped: " + dataRight);
  }
}

//-----------------END OF DRAW--------------------// 
////////////////////////////////////////////////////


void keyPressed() {
  if (key == 'm' || key == 'M') {
    if (!showGraph) showGraph = true;
    else showGraph = false;
  }
  if(key == 'n' || key == 'N'){
    if(volumeAdjust) volumeAdjust = false;
    else volumeAdjust = true;
    
    if(looseJack) looseJack = false;
    else looseJack = true; 
  }
  println("jack: " + looseJack);
  println("vol: " + volumeAdjust);
}