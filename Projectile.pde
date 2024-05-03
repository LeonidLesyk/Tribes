class Projectile{
  PVector pos;
  PVector dest;
  PVector speed;
  int frameCounter;
  int totalFrames;
  Projectile(PVector start, PVector end){
    int frames = 60;
    this.pos = start;
    this.dest = end; 
    this.speed.x = end.x - start.x;
    this.speed.y = end.y - start.y;
    this.speed.div(frames);
    this.totalFrames = frames;
    this.frameCounter = 0;
  }
  
  void draw(){
    pos.add(speed);
    frameCounter+=1;
    if(frameCounter>=totalFrames){
      //destroy projectile
    }
    fill(0);
    circle(pos.x,pos.y,40);
  }
}
