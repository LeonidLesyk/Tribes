class Unit {
  int maxhp;
  int hp;
  int strength;
  int mov;
  int atkRange;
  int cost;
 
  String unitType;
  
  boolean canMove = false;
  boolean canAttack = false;
  
  PImage sprite;
    
  Player owner;
      
  Unit(Player owner) {
    //this.x = x;
    //this.y = y;
    this.owner = owner;
    
  }
  
  //x and y should be center of tile. size maybe global??
  void display(float x, float y, float size) {
    
    float centerX = x;
    float centerY = y;
    float tileSize = size;
    
    size = size/2;
    x = x + size;
    y = y + size;
    
    
    // HP Bar display
    float hpBarWidth = size;
    float hpBarHeight = size / 8;
    float hpBarX = x - size / 2;
    float hpBarY;
    
    if(sprite != null) {
      image(sprite, centerX, centerY, tileSize, tileSize);
      hpBarY = y + size / 2 + hpBarHeight * 2;
      
    }
    else {
      size = size * 3 / 4; 
      
      color c = owner.teamColour;  
      
      fill(c);
      circle(x, y, size);
      
      fill(#000000); //black
      textSize(15);
      text(unitType, x-size/2, y + size/4 * 3);
      
      hpBarY = y - size / 2 - hpBarHeight * 2;
    }
    
    if(this.owner == players[turn]){
      float actionBarY = hpBarY + hpBarHeight;
      //action Bar background
      fill(50); // Dark gray background
      rect(hpBarX, actionBarY, hpBarWidth/2, hpBarHeight);
      rect(hpBarX + hpBarWidth/2, actionBarY, hpBarWidth/2, hpBarHeight);
      
      
      if(canMove){
        fill(255); // Dark gray background
        rect(hpBarX, actionBarY, hpBarWidth/2, hpBarHeight);
        rect(hpBarX + hpBarWidth/2, actionBarY, hpBarWidth/2, hpBarHeight);
      }else if(canAttack){
        fill(255); // Dark gray background
        rect(hpBarX, actionBarY, hpBarWidth/2, hpBarHeight);
      }
    }
    
    
    
    
    //HP Bar Background
    fill(50); // Dark gray background
    rect(hpBarX, hpBarY, hpBarWidth, hpBarHeight);
    
    float hpPercentage = (float) hp / maxhp; 
    //Current HP
    fill(255, 255, 0);
    rect(hpBarX, hpBarY, hpBarWidth * hpPercentage, hpBarHeight);
    
    //Lost HP
    fill(255, 0, 0);
    rect(hpBarX + hpBarWidth * hpPercentage, hpBarY, hpBarWidth * (1 - hpPercentage), hpBarHeight);
    
  }
  
  //returns true if unit is fallen
  boolean damage(int ammount) {
    hp = hp - ammount;
    if (hp <= 0) {
      return true;
    }
    return false;
  }
  
  String makeInfoText() {
    String info = unitType + "\n";
    info += "HP = " + hp + "/" + maxhp + "\n";
    info += "Attack Strength = " + strength + "\n";
    info += "Movement Range = " + mov + "\n";
    info += "Attack Range = " + atkRange;
    
    return info;
  }
  
  PImage loadSprite() {
    try {
      return loadImage("resources/" + unitType + owner.playerNumber + ".png");
    }
    catch (Exception e) {
      return null;
    }
  }

}

class Swordsman extends Unit {
  
  // defaults for swordsman.
  // the actual values could vary depending on research perks
  private final int HP = 5; 
  private final int STRENGTH = 1;
  private final int MOV = 1;
  
  Swordsman(Player owner) {
    super(owner);
    
    unitType = "Swordsman";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV;
    atkRange = 1; //swordsmen should be melee only
    
    sprite = loadSprite();
  }
}

class Archer extends Unit {
  private final int HP = 4; 
  private final int STRENGTH = 1;
  private final int MOV = 1;
  
  Archer(Player owner) {
    super(owner);
    
    unitType = "Archer";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV;
    atkRange = 2; //archers can attack only from 2 spaces away. we can change this
    
    sprite = loadSprite();
  }
}

class Builder extends Unit {
  private final int HP = 4; 
  private final int STRENGTH = 0;
  private final int MOV = 1;
  
  Builder(Player owner) {
    super(owner);
    
    unitType = "Builder";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV;
    atkRange = 1;
    
    sprite = loadSprite();
  }
}

class Cavalier extends Unit {
  private final int HP = 4; 
  private final int STRENGTH = 2;
  private final int MOV = 2;
  
  Cavalier(Player owner) {
    super(owner);
    
    unitType = "Cavalier";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV;
    atkRange = 1;
    
    sprite = loadSprite();
  }
}

class Giant extends Unit {
  private final int HP = 10; 
  private final int STRENGTH = 3;
  private final int MOV = 1;
  
  Giant(Player owner) {
    super(owner);
    
    unitType = "Giant";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV;
    atkRange = 1;
    
    sprite = loadSprite();
  }
}

class Wizard extends Unit {
  private final int HP = 2; 
  private final int STRENGTH = 3;
  private final int MOV = 1;
  
  
  Wizard(Player owner) {
    super(owner);
    
    unitType = "Wizard";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV;
    atkRange = 2;
    
    sprite = loadSprite();
  }
}
