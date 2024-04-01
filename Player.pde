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
  boolean spendGold(int amount) {
    if (gold >= amount) {
      gold -= amount;
      return true;
    }
    return false;
  }
  
  boolean spendResearch(int amount) {
    if (researchPoints >= amount) {
      researchPoints -= amount;
      return true;
    }
    return false;
  }
  
  void gainGold(int amount) {
    gold += amount;
  }
  
  void gainResearch(int amount) {
    researchPoints += amount;
  }
  
}
