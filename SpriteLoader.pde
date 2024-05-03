class SpriteLoader {
  
  PImage mountain;
  PImage forest;
  
  SpriteLoader() {
    mountain = loadImage("resources/mountain.png");
    forest = loadImage("resources/forest.png");
    
    
    
    println("loaded sprites");
  }
  
}
