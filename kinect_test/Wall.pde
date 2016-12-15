class Wall{
 float init_wall_x = 1240.0/480*100.0;
 float init_wall_y = 100.0;
 float speed = 1.06;
 float x = init_wall_x;                 //kauimmaisen kuvan dimensiont
 float y = init_wall_y;                  
 int init_width, init_height;
 int level;
 PImage img;                            //wall image
 PImage masked_img;                     //masked image 
 int deviation;
 
 Wall(int orig_width, int orig_height, int game_level){
    init_width = orig_width;
    init_height = orig_height;
    level = game_level;
 }
 
 void draw_wall(){
   img = wall_images[level];  //image depends on the level
   imageMode(CENTER);
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
 
 boolean checkEnd(PImage depth_img) {
   //int[] data = depth_img.pixels;  
   //check if collision with player etc "win state"
   if(x == init_width && y == init_height){  //when the image is zoomed to its full extent. All images have the same size.

     masked_img = img.get(300, 0, 640, 480);  //cropping the wall image into the right dimension
     masked_img.updatePixels();
     //depth_img.save("depth_image.png");
     //depth_img.mask(masked_img);
     
     
     //depth_img.save("masked.png");
     masked_img.save("masked.png");
     println(depth_img.pixels.length);
     //Comparing the pixels of two pictures
     for (int i=0; i < depth_img.pixels.length; i += 1) {
       if (masked_img.pixels[i] != color(0,0,0) && depth_img.pixels[i] == silhouetteColor) {
         deviation += 1;
       }
     }
     println("deviation: " + deviation);
     
     x = init_wall_x;
     y = init_wall_y;
     //jos halutaan kuva jälkikäteen
     //saveFrame("t.png");
     return true;
   }
   return false;
 }
}