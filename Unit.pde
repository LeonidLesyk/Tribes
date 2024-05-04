class Unit {
  int maxhp;
  int hp;
  int strength;
  int mov;
  int atkRange;
  int cost;
  int sightRange;
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
    centerX = x + size;
    centerY = y + size;
    
    float spriteSize = tileSize * 0.9;
    
    
    float hpBarWidth = size;
    float hpBarHeight = size / 8;
    float hpBarX = centerX - size / 2;
    float hpBarY = y + hpBarHeight/2;
    float actionBarY = hpBarY + hpBarHeight;

    
    if(sprite != null) {
      
      //mirror if red, don't if blue
      if(owner.playerNumber == 1) {
        
        translate(x, y + tileSize * 0.1);
        scale(-1, 1);
        image(sprite, 0 - tileSize, 0, spriteSize, spriteSize);
        scale(-1, 1);
        translate(-x, -y - tileSize * 0.1);
      }
      else {
        image(sprite, x, y + tileSize * 0.1, spriteSize, spriteSize);
      }
            
    }
    else {
      size = size * 3 / 4; 
      
      color c = owner.teamColour;  
      
      fill(c);
      circle(x, y, size);
      
      fill(#000000); //black
      textSize(15);
      text(unitType, x-size/2, y + size/4 * 3);

    }
    
    if(this.owner == players[turn]){
      //float actionBarY = hpBarY + hpBarHeight;
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
    info += "Owner: Player " + owner.playerNumber + "\n";
    info += "HP = " + hp + "/" + maxhp + "\n";
    info += "Attack Strength = " + strength + "\n";
    info += "Movement Range = " + mov + "\n";
    info += "Attack Range = " + atkRange + "\n";
    info += "Sight Range = " + sightRange;
    
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
  private final int STRENGTH = 2;
  private final int MOV = 1;
  private final int SIGHT = 2;
  
  Swordsman(Player owner) {
    super(owner);
    
    unitType = "Swordsman";
    
    maxhp = HP + (players[turn].sorcerersLevel>=3?1:0); 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV + (players[turn].tribesmenLevel>=5?1:0);
    atkRange = 1; //swordsmen should be melee only
    sightRange = SIGHT;
    
    sprite = loadSprite();
  }
}

class Archer extends Unit {
  private final int HP = 4; 
  private final int STRENGTH = 1;
  private final int MOV = 1;
  private final int SIGHT = 2;
  
  Archer(Player owner) {
    super(owner);
    
    unitType = "Archer";
    
    maxhp = HP + (players[turn].sorcerersLevel>=3?1:0); 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV + (players[turn].tribesmenLevel>=5?1:0);
    atkRange = 2; //archers can attack only from 2 spaces away. we can change this
    sightRange = SIGHT;
    sprite = loadSprite();
  }
}

class Builder extends Unit {
  private final int HP = 4; 
  private final int STRENGTH = 0;
  private final int MOV = 1;
  private final int SIGHT = 3;
  
  Builder(Player owner) {
    super(owner);
    
    unitType = "Builder";
    
    maxhp = HP + (players[turn].sorcerersLevel>=3?1:0); 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV + (players[turn].tribesmenLevel>=5?1:0);
    atkRange = 1;
    sightRange = SIGHT;
    sprite = loadSprite();
  }
}

class Cavalier extends Unit {
  private final int HP = 4; 
  private final int STRENGTH = 2;
  private final int MOV = 3;
  private final int SIGHT = 3;
  
  Cavalier(Player owner) {
    super(owner);
    
    unitType = "Cavalier";
    
    maxhp = HP + (players[turn].sorcerersLevel>=3?1:0); 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV + (players[turn].tribesmenLevel>=5?1:0);
    atkRange = 1;
    sightRange = SIGHT;
    sprite = loadSprite();
  }
}

class Giant extends Unit {
  private final int HP = 15; 
  private final int STRENGTH = 3;
  private final int MOV = 1;
  private final int SIGHT = 2;
  
  Giant(Player owner) {
    super(owner);
    
    unitType = "Giant";
    
    maxhp = HP + (players[turn].sorcerersLevel>=3?1:0); 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV; //giant will not have move bonus
    atkRange = 1;
    sightRange = SIGHT;
    sprite = loadSprite();
  }
}

class Wizard extends Unit {
  private final int HP = 2; 
  private final int STRENGTH = 3;
  private final int MOV = 1;
  private final int SIGHT = 3;
  
  
  Wizard(Player owner) {
    super(owner);
    
    unitType = "Wizard";
    
    maxhp = HP + (players[turn].sorcerersLevel>=3?1:0); 
    hp = maxhp;
    strength = STRENGTH + (players[turn].sorcerersLevel>=5?2:0);
    mov = MOV + (players[turn].tribesmenLevel>=5?1:0);
    atkRange = 2;
    sightRange = SIGHT;
    sprite = loadSprite();
  }
}

class Catapult extends Unit {
  private final int HP = 2 + (players[turn].sorcerersLevel>=3?1:0); 
  private final int STRENGTH = 1;
  private final int MOV = 1;
  private final int SIGHT = 4;
  
  
  Catapult(Player owner) {
    super(owner);
    
    unitType = "Catapult";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV + (players[turn].tribesmenLevel>=5?1:0);
    atkRange = 4;
    sightRange = SIGHT;
    sprite = loadSprite();
  }
}

class Dragon extends Unit {
  private final int HP = 12; 
  private final int STRENGTH = 2;
  private final int MOV = 2;
  private final int SIGHT = 4;
  
  
  Dragon(Player owner) {
    super(owner);
    
    unitType = "Dragon";
    
    maxhp = HP + (players[turn].sorcerersLevel>=3?1:0); 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV + (players[turn].tribesmenLevel>=5?1:0);
    atkRange = 2;
    sightRange = SIGHT;
    sprite = loadSprite();
  }
}
