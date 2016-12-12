// Daniel Shiffman
// Depth thresholding example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

// Original example by Elie Zananiri
// http://www.silentlycrashing.net

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
boolean mirror = false;

Kinect kinect;

// Depth image
PImage depthImg;

// Which pixels do we care about?
/*around 3m from the kinect-camera*/
int minDepth = 900;    
int maxDepth = 950;
// What is the kinect's angle
float angle;

int init_width = 640;
int init_height = 480;

Wall testWall = new Wall(init_width, init_height);
boolean playing = false;

void setup() {
  size(640, 480);

  kinect = new Kinect(this);
  kinect.initDepth();
  angle = kinect.getTilt();

  // Blank image
  depthImg = new PImage(kinect.width, kinect.height);
  
}

void draw() {
  frameRate(30);
  background(200, 200, 200);
  //MAIN MENU THINGS
  if(!playing){
    textAlign(CENTER, CENTER);
    textSize(32);
    fill(0, 0, 0);
    text("Hole in the wall", width/2, 50);
    rectMode(CENTER);
    fill(255, 255, 255);
    strokeWeight(2);
    rect(width/2, height/2, 150, 80, 7);
    fill(0, 0, 0);
    text("PLAY", width/2, height/2);
  }
  //IF PLAY BUTTON PRESSED DRAW WALL
  if(playing){
    testWall.draw();
    testWall.growSize();
    if(testWall.checkEnd()){
      clear();
      playing = false;
    }
  }
  
  //minDepth = mouseY;
  //maxDepth = mouseX;
  // Draw the raw image
  //image(kinect.getDepthImage(), 0, 0);

  // Threshold the depth image
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i++) {
    int xPix = i % kinect.width;
    int yPix = i / kinect.height;
    int horizontalMargin = 50;
    int verticalMargin = 50;
    if (xPix > horizontalMargin && xPix < kinect.width - horizontalMargin &&  //magins
        yPix > verticalMargin) {
      if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
        depthImg.pixels[i] = color(255, 100, 90);  //we care only about one color
      } else {
        depthImg.pixels[i] = color(0);
      }
    }
  }

  // Draw the thresholded image
  depthImg.updatePixels();
  imageMode(CORNER);
  image(depthImg, 0, 0);  //the image we are interested about!!!
  tint(255, 60);

  fill(0);
  //text("TILT: " + angle, 10, 20);
  //text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
  
}

// Adjust the angle and the depth threshold min and max
void keyPressed() {
  
  if (key == CODED) {
    if (keyCode == UP) {
      angle++;
    } else if (keyCode == DOWN) {
      angle--;
    }
    angle = constrain(angle, 0, 30);
    kinect.setTilt(angle);
  } else if (key == 'm') {
    mirror = !mirror;
    kinect.enableMirror(mirror);
  } else if (key == 'a') {
    minDepth = constrain(minDepth+10, 0, maxDepth);
  } else if (key == 's') {
    minDepth = constrain(minDepth-10, 0, maxDepth);
  } else if (key == 'z') {
    maxDepth = constrain(maxDepth+10, minDepth, 2047);
  } else if (key =='x') {
    maxDepth = constrain(maxDepth-10, minDepth, 2047);
  }
}

void mouseClicked() {
  //check if click inside PLAY button,
  //its x size is 150 and y 80
  if(mouseX > (width/2 - 75) && mouseX < (width/2 + 75)
    && mouseY > (height/2 - 40) && mouseY < (height/2 + 40)
    && !playing){
     clear();
     playing = true;
  }
}