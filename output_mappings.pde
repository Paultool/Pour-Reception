////////////////////////////////////////////////////
//-----------MAPPING WEKINATOR OUTPUTS------------// 



int channelIndex = 0; 

int lastRight = 0;
int lastLeft = 0;
int lockCount = 0; 
int finetune = 2;
int finetuneVal = 1;
float vol = 0; 
int volCount = 0; 

boolean volumeAdjust = true;
boolean looseJack = false; 
boolean speakerOn = false; 

void getGesture(int left, int right) {
  //Control of gesture errors   
  //--------------------------------------------------
  // Lock If Jars are full / empty

  if (right == 5 && lastRight == 4 ) right = 4;  
  if (left == 5 && lastLeft == 4 ) left = 4;  

  if (right == 5 && left != 1) right = 3; 
  if (left == 5 && right != 1) left = 3; 

  if (lastRight == 5 && right == 4 ) right = 5; 
  if (lastLeft == 5 && left == 4 ) left = 5; 

  if (right == 3 && ( left != 1 || left != 2 ) ) left = lastLeft;
  if (left == 3 && ( right != 1 || right != 2 ) ) right = lastRight;

  // if (right == 1 && lastRight == 5 ) right = 5; 
  // if (left == 1 && lastLeft == 5 ) left = 5; 



  switch(right) {
    //------------------------------------------------------------
  case 1: // Empty
    if (looseJack) {
      rightGesture = gestures[0];
      if (left == 1) {
        channels[index].amp -= fade*10;
        vacuum.amp(0.7);
      //  waterAmp -= fade*10;
      //  water.amp(waterAmp);
      } else vacuum.amp(0);
    }
    break;

    //------------------------------------------------------------
  case 2: // Full
    rightGesture = gestures[1];
    break;

    //------------------------------------------------------------
  case 3: // Touch glass / proximty
    rightGesture = gestures[2];
    if (counter > channelWindow - 10) {
      finetune = -finetuneVal;
    } else if (counter < 10) {
      finetune = finetuneVal;
    }

    if (frameCount%3 == 0) {
      counter += finetune;
    }


    /*if (dist < 1000) {
     freq+=5;
     } else {
     freq+=20;
     }*/

    break;

    //------------------------------------------------------------
  case 4: // Touch water
    rightGesture = gestures[3];
    if (volumeAdjust) {
      if ( channels[index].amp < 0) channels[index].amp += fade*4;
      else if (channels[index].amp > fade-10) channels[index].amp -= fade*8;
    }



    break;

    //------------------------------------------------------------
  case 5: // Pour water
    rightGesture = gestures[4];
     if (!speakerOn)  waterAmp += 0.003;
    else if (speakerOn) counter+=5;

    break;
  }


  switch(left) {
    //------------------------------------------------------------
  case 1: // Empty
    if (looseJack) {
      leftGesture = gestures[0];
      if (right == 1) {
        channels[index].amp -= fade*10;
        vacuum.amp(0.7);
      } else vacuum.amp(0);
    }
    break;

    //------------------------------------------------------------
  case 2: // Full
    leftGesture = gestures[1];
    break;

    //------------------------------------------------------------
  case 3: // Touch glass / proximty
    leftGesture = gestures[2];  
    if (counter > channelWindow - 10) {
      finetune = -finetuneVal;
    } else if (counter < 10) {
      finetune = finetuneVal;
    }
    if (frameCount%3 == 0) {
      counter += finetune;
    }
    break;

    //------------------------------------------------------------
  case 4: // Touch water
    leftGesture = gestures[3];
    if (volumeAdjust) {
      if ( channels[index].amp < 0) channels[index].amp += fade*4;
      else if (channels[index].amp > fade-10) channels[index].amp -= fade*8;
    }


    break;

    //------------------------------------------------------------
  case 5: // Pour water
    leftGesture = gestures[4];
     if (!speakerOn)  waterAmp += 0.003;
    else if (speakerOn) counter+=5;
    break;
  }

  for (int i = 0; i < channels.length; i++) {
    channels[i].run();
  }
  changeChannel();
  waterNoise();
  resetDistortion();


  lastRight = right;
  lastLeft = left;
}
//-----------------------END----------------------// 
////////////////////////////////////////////////////




////////////////////////////////////////////////////
//-------MAPPING SENSOR DATA FROM GESTURE---------// 

float minVal_left = 999;
float minVal_right = 999;
float maxVal_left = -999; 
float maxVal_right = -999; 
// sensorRight and sensorLeft is gobal variables, updating in main draw loop

float mapSensorValue(boolean left, float sensorData) {

  float data = sensorData; 
  if (left) {
    // println("data left: " + data + " minVal: " + minVal_left + " maxval: " + maxVal_left);
    if (data < minVal_left) minVal_left = data; 
    if (data > maxVal_left) maxVal_left = data;
    data = map(data, minVal_left, maxVal_left, 12, 0);
  }
  if (!left) {
    if (data < minVal_right) minVal_right = data; 
    if (data > maxVal_right) maxVal_right = data;
    data = map(data, minVal_right, maxVal_right, 12, 0);
  }

  data = constrain(data, 0, 12);
  return data;
}
//-----------------------END----------------------// 
////////////////////////////////////////////////////