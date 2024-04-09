class Unit {
  int maxhp;
  int hp;
  int strength;
  int mov;
  int atkRange;
 
  String unitType;
    
  Player owner;
      
  Unit(Player owner) {
    //this.x = x;
    //this.y = y;
    this.owner = owner;
  }
  
  //x and y should be center of tile. size maybe global??
  void display(float x, float y, float size) {
    
    size = size * 3 / 4; // 3/4 tile size
    
    color c = owner.teamColour;  
    
    fill(c);
    circle(x, y, size);
    
    fill(#000000); //black
    textSize(15);
    text(unitType, x-size/2, y + size/4 * 3);
    
    // HP Bar display
    float hpBarWidth = size;
    float hpBarHeight = size / 8;
    float hpBarX = x - size / 2;
    float hpBarY = y - size / 2 - hpBarHeight * 2;
    
    //HP Bar Background
    fill(50); // Dark gray background
    rect(hpBarX, hpBarY, hpBarWidth, hpBarHeight);
    
    float hpPercentage = (float) hp / maxhp; 
    //Current HP
    fill(0, 255, 0);
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
  

}

class Swordsman extends Unit {
  
  // defaults for swordsman.
  // the actual values could vary depending on research perks
  private final int HP = 5; 
  private final int STRENGTH = 1;
  private final int MOV = 2;
  
  Swordsman(Player owner) {
    super(owner);
    
    unitType = "Swordsman";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV;
    atkRange = 1; //swordsmen should be melee only
  }
}

class Archer extends Unit {
  private final int HP = 4; 
  private final int STRENGTH = 1;
  private final int MOV = 2;
  
  Archer(Player owner) {
    super(owner);
    
    unitType = "Archer";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV;
    atkRange = 2; //archers can attack only from 2 spaces away. we can change this
  }
}

class Builder extends Unit {
  private final int HP = 4; 
  private final int STRENGTH = 1;
  private final int MOV = 2;
  
  Builder(Player owner) {
    super(owner);
    
    unitType = "Builder";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV;
    atkRange = 1;
  }
}
