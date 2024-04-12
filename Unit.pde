class Unit {
  int maxhp;
  int hp;
  int strength;
  int mov;
  int atkRange;
 
  String unitType;
  String infoText;
  
  boolean canMove = true;
  boolean canAttack = true;
    
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
    textSize(22);
    text(unitType, x-size/2, y + size/4 * 3);
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
    info += "HP = " + hp + "/" + "maxhp\n";
    info += "Attack Strength = " + strength + "\n";
    info += "Movement Range = " + mov + "\n";
    info += "Attack Range = " + atkRange;
    
    return info;
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
    
    infoText = makeInfoText();
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
    
    infoText = makeInfoText();
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
    
    infoText = makeInfoText();
  }
}
