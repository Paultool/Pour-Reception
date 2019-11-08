
////////////////////////////////////////////////////
//---------LOOK UP CHART FOR WEKINATOR------------// 
//Output 1                //Output 2      
// #1:  EMPTY             
// #2:  FULL              
// #3:  PROXIMITY/touch 
// #4:  TOUCHED WATER
// #5:  POURING WATER     
//                                                // 
////////////////////////////////////////////////////
//Output 1                        //Output 2      
// #1:  Deselected / Inactive     Empty / Not Last Poured
// #2:  Selected / Active         FULL / Last Poured
// #3:  Browsing                  While poruing

//                                                // 
////////////////////////////////////////////////////



////////////////////////////////////////////////////
//--------START OF WEKINATOR COMMUNICATION--------// 

//SEND OSC MESSEAGE TO WEKINATOR
void sendOsc(float[] values) {
  OscMessage msg = new OscMessage("/wek/inputs");
  for (int i = 0; i < values.length; i++) {
    msg.add(values[i]);
  }
  oscP5.send(msg, dest);
}


//RECEIVE INPUTS FROM WEKINATOR 
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
    int leftJarGesture = int(theOscMessage.get(0).floatValue());
    int rightJarGesture = int(theOscMessage.get(1).floatValue());
    
    int [] wekinatorOutput = {leftJarGesture, rightJarGesture};  
    wekinatorOutput = smoothGesture(wekinatorOutput);
    getGesture(wekinatorOutput[0], wekinatorOutput[1]);
  }
}


//SEND OUTPUT NAMES BACK TO WEKINATOR
void sendOscNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setOutPutNames");
  msg.add("gesture");
  oscP5.send(msg, dest);
}