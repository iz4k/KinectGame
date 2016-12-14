class Wall{
 float init_wall_x = 1240.0/480*100.0;
 float init_wall_y = 100.0;
 float speed = 1.02;
 float x = init_wall_x;                 //kauimmaisen kuvan dimensiont
 float y = init_wall_y;                  
 int init_width, init_height;
 PImage img;
    
    
 Wall(int orig_width, int orig_height){
    init_width = orig_width;
    init_height = orig_height;
 }
 
 void draw(){
    
   img = loadImage("reikaseinassa.png");
   imageMode(CENTER);
    println(width, height);
    image(img, width/2, height/2, x, y);  //(kuva, keskipisteet, dimensiot)kuvan koko kasvaa kun x ja y muuttuvat,
    //perspective lines
    line(width/2 - x/2, height/2 - y/2, 0, 0);
    line(width/2 + x/2, height/2 - y/2, init_width, 0);
    line(width/2 + x/2, height/2 + y/2, init_width, init_height);
    line(width/2 - x/2, height/2 + y/2, 0, init_height);
 }
  
 void growSize(){
   x = x * speed;
   y = y * speed;
   //if(x > init_width){
   // x = init_width;
   //}
   if(y >= init_height){
    y = init_height;
    x = init_width;
   }
 }
 
 boolean checkEnd(int[] silhouette){
   //check if collision with player etc "win state"
   if(x == init_width && y == init_height){
     img.loadPixels();
     //println(silhouette.length);
     //println(img.pixels.length);
     /*for(int i = 0; i < silhouette.length-1; i += 5){
       if(silhouette[i] == color(255, 100, 90) && img.pixels[i] == color(0, 0, 0)){
         println("siluetti osuu mustaan");
       }
       else if(silhouette[i] == color(255, 100, 90)){
         println("siluetti ei mustalla");
       }
       else if(img.pixels[i] == color(0, 0, 0)){
         println("mustaa on");
       }
     }*/
     
     
     x = init_wall_x;
     y = init_wall_y;
     //jos halutaan kuva jälkikäteen
     //saveFrame("t.png");
     return true;
   }
   return false;
 }
}