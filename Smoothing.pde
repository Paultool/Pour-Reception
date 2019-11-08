
////////////////////////////////////////////////////
//------------SMOOTHING ALGORITHMS ---------------//

//All smoothing related variables and functions
//are isolated in this tab, for cleaner code. 
//First functions for smoothing the array of 
//data to wekinator is created. 
//Next a avr data ouput for each sensor is smoothed
//and last a stabilization function is added to
//keep a more consisten wekinator output.

//----------------------------------------------- // 
////////////////////////////////////////////////////





int numReadings = 8; // general variable for avrage smoothing - can be changed

///////////////////////////////////////////////////
//----------SMOOTH ARRAY TO WEKINIANTOR-----------// 
int readingIndex = 0; 
float[][] movingAarrayAvr = new float[64][numReadings];
float[] arrayAvrTotal = new float[64];

void initializeArrAvrage() {
  for (int i = 0; i < movingAarrayAvr.length; i++) {
    arrayAvrTotal[i] = 0; 
    for (int j = 0; j < numReadings; j++) {
      movingAarrayAvr[i][j] = 0;
    }
  }
}

float[] smoothArrayToWek(float[] arrayToWek_) {  
  float[] avrage = new float [64];

  for (int i = 0; i < movingAarrayAvr.length; i++) {
    arrayAvrTotal[i] -= movingAarrayAvr[i][readingIndex];
    movingAarrayAvr[i][readingIndex] = arrayToWek_[i];  
    arrayAvrTotal[i] += movingAarrayAvr[i][readingIndex];

    avrage[i] = arrayAvrTotal[i] / numReadings;
  }
  readingIndex++; 
  if (readingIndex >= numReadings) { 
    readingIndex = 0;
  }  
  return avrage;
}
//---------------------END------------------------//   
////////////////////////////////////////////////////

////////////////////////////////////////////////////
//----------SINGLE SENSOR AVRAGE SMOOTH-----------// 

int readingIndex_single = 0; 
float[] movingSensorAvr = new float[numReadings];
float sensorTotal = 0; 

void initializeSingleAvr() {
  for (int i = 0; i < movingSensorAvr.length; i++) {
    movingSensorAvr[i] = 0;
  }
}

float singleSensorSmooth(float[] values) {

  float avr = smoothing(values);
  sensorTotal -= movingSensorAvr[readingIndex_single];
  movingSensorAvr[readingIndex_single] = avr; 
  sensorTotal += movingSensorAvr[readingIndex_single];

  readingIndex_single++;

  if (readingIndex_single >= numReadings) { 
    readingIndex_single = 0;
  }  

  float avrage = sensorTotal / numReadings; 
  return avrage;
}



float smoothing(float[] values) {
  float avr = 0; 
  for (int i = 0; i < values.length; i++) {
    avr += values[i];
  }
  avr = floor(avr / values.length);
  return avr;
}

//---------------------END------------------------//   
////////////////////////////////////////////////////



////////////////////////////////////////////////////
//-----------SMOOTH CLASSIFIER OUTPUT-------------// 

int[][] gestureSample = {{0, 0, 0, 0}, 
                        {0, 0, 0, 0}};
int gestIndex = 0; 
int[] oldGest = {0, 0};

int[] smoothGesture(int[] gest) {
  int[] matchCount = {0, 0};
  int[] outputGest = {0, 0};

  for (int i = 0; i < gestureSample.length; i++) {
    gestureSample[i][gestIndex] = gest[i]; 

    for (int j = 0; j < gestureSample[i].length; j++) {
      if (gest[i] == gestureSample[i][j]) matchCount[i]++;
    }

    if (matchCount[i] == 4) {
      outputGest[i] = gest[i]; 
      oldGest[i] = outputGest[i];
    } else { 
      outputGest[i] = oldGest[i];
    }
  }

  gestIndex++;
  if (gestIndex >= 4) gestIndex = 0; 
  return outputGest;
}

//---------------------END------------------------//   
////////////////////////////////////////////////////