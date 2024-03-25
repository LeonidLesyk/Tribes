class Unit {
  int maxhp;
  int hp;
  int strength;
  int mov;
  int atkRange;
 
  String unitType;
  
  int x,y; // position: x and y values of tile
  
  String team;
  
  int defaultHP;
    
  Unit(int x, int y, String team) {
    this.x = x;
    this.y = y;
    this.team = team;
  }
  
  //right now it's just a red circle with the name of the unit type below it
  void display() {
    Tile tile =  gameBoard.grid[x][y];
    
    float displayX = tile.position.x;
    float displayY = tile.position.y;
    
    float size = tile.size * 3 / 4; 
    
    color c = #ee2a3e; // a shade of red. ideally we should have colour values for each team saved somewhere, and grab that
    
    fill(c);
    circle(displayX, displayY,size);
    
    fill(#000000); //black
    textSize(32);
    text(unitType, displayX, displayY + size/4 * 3);
  }
  
  void damage(int ammount) {
    hp = hp - ammount;
    if (hp <= 0) {
      //make unit be fallen
    }
  }
  
  //how do we want to do attacking and counterattacks?
  //maybe having a separate method for initiating combat, which then has attacks and counterattacks? hmm
  void attack(Unit opponent)  {
    
    //change how the range check works if we make units have more than one possible range
    if (distanceFrom(opponent.x, opponent.y) < atkRange) {
      opponent.damage(strength);
    }
    
  }
  
  
  int distanceFrom(int otherX, int otherY) {
    int distance = abs(otherX - x) + abs(otherY - y);
    return distance;
  }
}

class Swordsman extends Unit {
  
  // defaults for swordsman.
  // the actual values could vary depending on research perks
  private final int HP = 5; 
  private final int STRENGTH = 1;
  private final int MOV = 2;
  
  Swordsman(int x, int y, String team) {
    super(x, y, team);
    
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
  
  Archer(int x, int y, String team) {
    super(x, y, team);
    
    unitType = "Archer";
    
    maxhp = HP; 
    hp = maxhp;
    strength = STRENGTH;
    mov = MOV;
    atkRange = 2; //archers can attack only from 2 spaces away. we can change this
  }
}
