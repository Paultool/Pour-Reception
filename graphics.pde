
String leftGesture, rightGesture = "";
String[] gestures = {"EMPTY JAR", "FULL JAR", "PROXIMITY/TOUCH", "TOUCHING WATER","POURING WATER",};

////////////////////////////////////////////////////////////////////
//---------------------------DRAW GRAPHH--------------------------// 

void drawGraph(float[] values_, float[] peak) {
  float barWidth_ = width / float (sensors.length); 

  // dividing the combined sensor array into each individal sensor
  float[] sensors1 = subset(values_, 0, 32);
  float[] sensors2 = subset(values_, 32);

  // draw each sensor data as a graph
  for (int i = 0; i < sensors.length; i++) {
    if (i == 0)drawSensor(sensors1, barWidth_, peak[i], i);
    if (i == 1)drawSensor(sensors2, barWidth_, peak[i], i);
  }
}

//the drawing function  
void drawSensor(float[] sensor, float barWidth, float red, int i) {    
  noStroke ();
  fill (red, 0, 0);
  rect (barWidth * i, 0, barWidth, height);

  stroke (255);
  noFill ();
  strokeWeight (5);

  beginShape ();

  for (int v=0; v < sensor.length; v++) {
    vertex(barWidth * i + (barWidth / sensor.length) * v, (height / 1024f) * sensor[v]);
  }
  endShape ();
}

//------------------------------END-------------------------------//   
////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////
//---------------------------DRAW GESTURES------------------------// 

void showGesture() {
  background(255);
  fill(0);
  stroke(0);
  strokeWeight(5);
  line(width/2, 0, width/2, height);

  rectMode(CENTER);
  textSize(48);
  
  text(leftGesture, grid * 2.5, 4.5*grid, 4*grid, 4*grid ); 
  text(rightGesture, grid * 7.5, 4.5*grid, 4*grid, 4*grid );

  textSize(28);
  fill(103, 224, 158);
  text("left jar", grid * 2.5, 1*grid);  

  fill(238, 92, 91);
  text("right jar", grid * 7.5, 1*grid);
}