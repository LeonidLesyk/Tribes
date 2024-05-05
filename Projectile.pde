class Projectile{
  PVector pos;
  PVector dest;
  PVector speed;
  int frameCounter;
  int totalFrames;
  PImage sprite;
  Projectile(PVector start, PVector end,String file){
    int frames = 15;
    this.pos = start;
    this.dest = end; 
    this.speed = new PVector();
    this.speed.x = end.x - start.x;
    this.speed.y = end.y - start.y;
    this.speed.div(frames);
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
    //sprite rotate
    
    image(sprite,pos.x,pos.y);
    
    imageMode(CORNER);
    return frameCounter > totalFrames ;
  }
  
  
}
