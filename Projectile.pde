class Projectile{
  PVector pos;
  PVector dest;
  PVector speed;
  int frameCounter;
  int totalFrames;
  PImage sprite;
  int size;
  float angle;




  Projectile(PVector start, PVector end,String file){
    int frames = 15;
    this.pos = start;
    this.dest = end; 
    this.speed = new PVector();
    this.speed.x = end.x - start.x;
    this.speed.y = end.y - start.y;
    this.speed.div(frames);
    this.angle = atan2(speed.y, speed.x);
    this.totalFrames = frames;
    this.frameCounter = 0;
    sprite = loadImage("resources/" + file);
    sprite.resize(tileSizePixels/2,tileSizePixels/2);
    
    
  }
  
  boolean draw(){
    pos.add(speed);
    frameCounter+=1;
    if(frameCounter>=totalFrames){
      //destroy projectile
    }
    fill(128);
    imageMode(CENTER);
    pushMatrix(); //Save the current transformation matrix
    translate(pos.x, pos.y); //Move origin to the projectile's position
    rotate(angle); //Rotate the coordinate around new origin
    if (sprite != null) {
        image(sprite, -size/4, -size/4, size/2, size/2);
    }
    popMatrix(); //Restore the original transformation matrix
    imageMode(CORNER);
    return frameCounter > totalFrames ;
  }
  
  
}
