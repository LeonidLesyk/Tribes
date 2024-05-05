class SpriteLoader {
  
  PImage mountain;
  PImage forest;
  PImage goldMountain;
  PImage fireball1;
  PImage fireball2;
  PImage arrow;
  PImage rock;
  
  SpriteLoader() {
    mountain = loadImage("resources/mountain.png");
    forest = loadImage("resources/forest.png");
    goldMountain = loadImage("resources/gold mountain.png");
    
    fireball1 = loadImage("resources/fireball1.png");
    fireball2 = loadImage("resources/fireball2.png");
    arrow = loadImage("resources/arrow.png");
    rock = loadImage("resources/rock.png");

    
    println("loaded sprites");
  }
  
}
