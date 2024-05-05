class Projectile {
  PVector pos;
  PVector dest;
  PVector speed;
  int frameCounter;
  int totalFrames;
  PImage sprite;
  int size;
  float angle;

  Projectile(PVector start, PVector end,  PImage sprite, int frame) {
    int frames = frame;
    this.pos = start.copy(); // Create a copy of the start vector to prevent changes to the original
    this.dest = end.copy(); 
    this.speed = PVector.sub(end, start).div(frames); // Calculate the velocity vector based on the start and end points
    
    if( sprite != loader.rock) {
      this.angle = atan2(speed.y, speed.x); // Calculate the angle of the projectile's direction
    }
    else {
      this.angle = 0;
    }
    
    this.totalFrames = frames;
    this.frameCounter = 0;
    this.size = tileSizePixels / 2; // Adjust the size as necessary
    this.sprite = sprite;
    
    
    sprite.resize(size, size); // Resize the image to an appropriate size
  }

  // Method to draw the projectile and advance its position
  boolean draw() {
    // Update the position of the projectile
    pos.add(speed);
    frameCounter++;

    // Check if the projectile has reached the maximum number of frames
    if (frameCounter >= totalFrames) {
      return true; // Mark this projectile for removal
    }

    // Draw the projectile with the appropriate transformations
    imageMode(CENTER);
    pushMatrix(); //Save the current transformation matrix
    translate(pos.x, pos.y); //Move origin to projectile's position
    rotate(angle);
    image(sprite, 0, 0, size, size); //Draw projectile center on new origin
    popMatrix(); //Restore original transformation matrix
    imageMode(CORNER); //Reset the image mode to the default corner mode

    return frameCounter >= totalFrames; //Return true if the projectile's journey is over
  }
}
