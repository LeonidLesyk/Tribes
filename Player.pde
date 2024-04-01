class Player {
  color teamColour; 
  
  int gold;
  int researchPoints;
  
  boolean alive;
  
  
  //define colour when creating players
  // red: ee2a3e
  // blue: 6493E2
  
  Player(color colour) {
    teamColour = colour;
    
    gold = 0;
    researchPoints = 0;
  }
  
  //returns true if spending was successful, false if not
  boolean spendGold(int ammount) {
    if (gold >= ammount) {
      gold -= ammount;
      return true;
    }
    return false;
  }
  
  boolean spendResearch(int ammount) {
    if (researchPoints >= ammount) {
      researchPoints -= ammount;
      return true;
    }
    return false;
  }
  
  void gainGold(int ammount) {
    gold += ammount;
  }
  
  void gainResearch(int ammount) {
    researchPoints += ammount;
  }
  
}
