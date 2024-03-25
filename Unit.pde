class Unit {
  int maxhp;
  int hp;
  int strength;
  int mov;
  int atkRange;
 
  String unitType;
    
  String team;
      
  Unit(String team) {
    //this.x = x;
    //this.y = y;
    this.team = team;
  }
  
  //x and y should be center of tile. size maybe global??
  void display(float x, float y, float size) {
    
    size = size * 3 / 4; // 3/4 tile size
    
    color c = #ee2a3e; // a shade of red. ideally we should have colour values for each team saved somewhere, and grab that
    
    fill(c);
    circle(x, y, size);
    
    fill(#000000); //black
    textSize(32);
    text(unitType, x, y + size/4 * 3);
  }
  
  void damage(int ammount) {
    hp = hp - ammount;
    if (hp <= 0) {
      //make unit be fallen
    }
  }
  

}

class Swordsman extends Unit {
  
  // defaults for swordsman.
  // the actual values could vary depending on research perks
  private final int HP = 5; 
  private final int STRENGTH = 1;
  private final int MOV = 2;
  
  Swordsman(String team) {
    super(team);
    
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
  
  Archer(String team) {
    super(team);
    
    unitType = "Archer";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV;
    atkRange = 2; //archers can attack only from 2 spaces away. we can change this
  }
}
