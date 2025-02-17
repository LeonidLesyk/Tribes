class Player {
  color teamColour; 
  
  int gold;
  int researchPoints;
  
  int tribesmenLevel;
  int dwarvesLevel;
  int sorcerersLevel;
  
  boolean alive;
  
  int playerNumber;
  
  
  //define colour when creating players
  // red: ee2a3e
  // blue: 6493E2
  
  Player(int num, color colour) {
    teamColour = colour;
    
    gold = 30;
    researchPoints = 5;
    tribesmenLevel = 0;
    dwarvesLevel = 0;
    sorcerersLevel = 0;
    
    playerNumber = num;
  }
  
  //returns true if spending was successful, false if not
  boolean spendGold(int amount) {
    if (gold >= amount) {
      gold -= amount;
      return true;
    }
    return false;
  }
  
  boolean hasEnoughGold(int amount) {
    return gold >= amount;
  }
  
  boolean spendResearch(int amount) {
    if (researchPoints >= amount) {
      researchPoints -= amount;
      return true;
    }
    return false;
  }
  
  boolean hasEnoughRP(int amount) {
    return researchPoints >= amount;
  }
  
  void gainGold(int amount) {
    gold += amount;
  }
  
  void gainResearch(int amount) {
    researchPoints += amount;
  }
  
}
