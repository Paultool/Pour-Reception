//One volume variable per soundfile

String[] plingNames = {"p1", "p2", "p3", "p4", };
String[] channelNames = {"bible", "flags", "internet", "rock_short", "rap_short", "jazz_short", "funk_short", "disco_short", "altrock_short", "80pop_short", "60rock_short", "noise", "noise", "noise"};
//String[] channelNames = {"bible", "noise", "flags", "noise", "internet", "noise", "jazz", "noise", "pop", "noise", "rock", "noise", "underground", "noise", "young", "noise"};
int spectrum = channelNames.length;

float fade = 0.008;
float waterAmp;
float vacuumAmp;
int waterThreshold = 1000;

int index = 3;
//int index = round(random(0,channelNames.length-1));
int lastChannel;
int counter, dist;
float rate = 1;
int freq;
int channelWindow = 100, channelCenter = channelWindow/2;
boolean channelChange = false, randomize = true;


void changeChannel() {
  if (counter > channelWindow) {
    lastChannel = index;
    if (!randomize) {
      index++;
    } else {
      index = round(random(0, channelNames.length-1));
      if (index == lastChannel) {
        index = round(random(0, channelNames.length-1));
      }
    }
    if (index < 0) {
      index = spectrum-1;
    }
    if (index > spectrum-1) {
      index = 0;
    }
    channelChange = true;
    counter = 0;
  }
}

void waterNoise() {
  
  
 // println(counter, dist, freq);
  dist = abs(channelCenter-counter);
  rate = map(dist, 0, channelCenter, 1.1, 0.4);
  
if(!speakerOn && waterAmp > 0.28) speakerOn = true;
  else if(!speakerOn) waterAmp = constrain(waterAmp,-0.1,0.3);
  else{
  waterAmp = constrain(waterAmp,0,0.3);
  waterAmp = map(dist,0,channelCenter,-0.1,0.3);
  waterAmp = constrain(waterAmp,0,0.3);
   }
  water.amp(waterAmp);

  if(speakerOn){
  freq = int(map(dist,0,channelCenter,12000,100));
  lowPass.set(freq);
  freq = constrain(freq, 20, 12000);
  }
  



 
}

void resetDistortion() {
  if (channelChange) {
    println("--- CHANNEL CHANGE ---");
    println("Channel at index: " + index);

    if (index <= 7) {
      int lottery = round(random(0, 3));
      plings[lottery].cue(0);
      plings[lottery].amp(0.5);
      plings[lottery].play();
    }


    freq = int(random(100, 950));
    if(speakerOn) lowPass.process(soundfiles[index], freq);
    channelChange = false;
  } 
}