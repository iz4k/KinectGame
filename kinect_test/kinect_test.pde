// Daniel Shiffman
// Depth thresholding example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

// Original example by Elie Zananiri
// http://www.silentlycrashing.net

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
boolean mirror = true;

Kinect kinect;

// Depth image
PImage depthImg;

// Which pixels do we care about?
/*around 3m from the kinect-camera*/
int minDepth = 950;    
int maxDepth = 980;

// What is the kinect's angle
float angle;

//window dimensions
int init_width = 1240;
int init_height = 480;  //this will also be the height of the camera-image

Wall testWall = new Wall(init_width, init_height);
boolean playing = false;

void setup() {
  size(1240, 480);

  kinect = new Kinect(this);    //kinect's own dimensions is 640x480
  kinect.initDepth();
  kinect.enableMirror(mirror);
  angle = kinect.getTilt();
  
  // Blank image
  depthImg = new PImage(kinect.width, kinect.height);  //up-scaled dimensions for depthImage 
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
  }

  // Drawing the camera image
  int[] rawDepth = kinect.getRawDepth();  //depthData in some kind of form
  
  for (int i=0; i < rawDepth.length; i++) {
    //int xPix = i % kinect.width;
    //int yPix = i / kinect.height;
    //int horizontalMargin = 0;
    //int verticalMargin = 0;
    //if (xPix > horizontalMargin && xPix < kinect.width - horizontalMargin &&  //magins
    //    yPix > verticalMargin) {
      if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
        depthImg.pixels[i] = color(255, 100, 90);  //we care only about one color
      } else {
        depthImg.pixels[i] = color(200, 200, 200);  //empty space with grey
      }
    //}
  }
   
  // Drawing the camera image
  depthImg.updatePixels();      //update necessary
  imageMode(CENTER);
  image(depthImg, init_width/2, init_height/2); //align-center
  //image(depthImg, 0, 0, init_width, init_height);  //the image we are interested about!!!
  tint(255, 60);
  fill(0);
  
  if(testWall.checkEnd(depthImg.pixels)){
      // testWall = new Wall(width, height, uuskuva);
      
      clear();
      playing = false;
    }
    
  /*if(endState){
    imageMode(CORNER);
    PImage img = loadImage("t.png");
    image(img, 0, 0);  //the image we are interested about!!!
    tint(255, 60);
    fill(0);
  }*/
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
     println("playing");
     clear();
     playing = true;
  }
}