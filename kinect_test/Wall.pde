class Wall{
 
 float speed = 1.005;
 float x = 133.0;
 float y = 100.0;
 int init_width, init_height;
 
 Wall(int orig_width, int orig_height){
    init_width = orig_width;
    init_height = orig_height;
 }
 
 void draw(){
    imageMode(CENTER);
    PImage img = loadImage("wall.jpg");
    image(img, width/2, height/2, x, y);
    line(width/2 - x/2, height/2 - y/2, 0, 0);
    line(width/2 + x/2, height/2 - y/2, init_width, 0);
    line(width/2 + x/2, height/2 + y/2, init_width, init_height);
    line(width/2 - x/2, height/2 + y/2, 0, init_height);
 }

 void growSize(){
   x = x * speed;
   y = y * speed;
   if(x > init_width){
    x = init_width;
   }
   if(y > init_height){
    y = init_height;
   }
 }
 
 boolean checkEnd(){
   //check if collision with player etc "win state"
   if(x == init_width && y == init_height){
     x = 133.0;
     y = 100.0;
     return true;
   }
   return false;
 }
}