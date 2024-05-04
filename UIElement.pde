class UIElement{
  int x;
  int y;
  int width;
  int height;
  
  int textSizeBig;
  int textSizeSmaller;
  
  UIElement(int x, int y, int width, int height){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    
    if(displayDensity() == 1) {
      textSizeBig = 40;
      textSizeSmaller = 32;
    }
    else {
      textSizeBig = 32;
      textSizeSmaller = 24;
    }
    
  }
  
  void onClickAction(){
    
  }
  
  void draw(){
  }
}

class endTurnButton extends UIElement{
  endTurnButton(int x, int y, int width, int height){
    super(x,y,width,height);
  }
  @Override
  void onClickAction(){
    

    //end turn actions e.g. add gold, research points calculate sight etc
    int currnetPlayer = turn%2;
    
    //loop through each cell
    for(int i=0; i<gameBoard.grid.length; i++){
      for(int j=0; j<gameBoard.grid[i].length; j++){
        if(gameBoard.grid[i][j].building != null && gameBoard.grid[i][j].building.owner == players[currnetPlayer]){
          
            if(gameBoard.grid[i][j].terrain instanceof Mountain) {
              gameBoard.grid[i][j].building.turnEndAction(gameBoard.grid[i][j].terrain.bonus);
            }
            gameBoard.grid[i][j].building.turnEndAction(0);


        }
        if(gameBoard.grid[i][j].unit != null) {
          gameBoard.grid[i][j].unit.canMove = true;
          gameBoard.grid[i][j].unit.canAttack = true;
        }
      }
    }
    //deactivate info and buy button
    infoBox i = (infoBox)UIElements.get("info");
    researchBuyButton b = (researchBuyButton)UIElements.get("buy");
    i.active = false;
    b.active = false;
    
    //clear selections
    toBuildClass = "";
    buildMode = false;
    availbleTiles = null;
    selectedTile = null;
    selectedBuilding = null;
    unitToSpawn = "";
    
    for(Tile[] row : gameBoard.grid){
      for(Tile t : row){
        t.colour = t.defaultColour;
      }
    }
    
      
    //end turn
    turn +=1;
    println("End Turn");
    
    if( turn == 2){
      turn = 0;
    }
    reCalculateFog();
    transition = true;
  }
  
  @Override
  void draw(){
    fill(players[turn].teamColour);
    stroke(128);
    rect(x,y,width,height);
    textSize(textSizeBig);
    fill(0);
    textAlign(LEFT,CENTER);
    text("End Turn: \nPlayer " + str(turn+1),x,y,x+width, y+height);
  }
}

class goldDisplay extends UIElement{
  goldDisplay(int x, int y, int width, int height){
    super(x,y,width,height);
  }
  
  @Override
  void draw(){
    fill(255);
    stroke(128);
    rect(x,y,width,height);
    textSize(textSizeBig);
    fill(0);
    textAlign(LEFT,CENTER);
    text("Gold: " + str(players[turn].gold),x,y,x+width, y+height);
  }
}

class researchDisplay extends UIElement{
  researchDisplay(int x, int y, int width, int height){
    super(x,y,width,height);
  }
  
  @Override
  void draw(){
    fill(255);
    stroke(128);
    rect(x,y,width,height);
    textSize(textSizeBig);
    fill(0);
    textAlign(LEFT,CENTER);
    text("RP: " + str(players[turn].researchPoints),x,y,x+width, y+height);
  }
}

class infoBox extends UIElement{
  boolean active;
  String infoText;
  infoBox(int x, int y, int width, int height,String t){
    super(x,y,width,height);
    this.active = false;
    this.infoText = t;
  }
  
  @Override
  void onClickAction(){
    this.active = false;
    researchBuyButton b = (researchBuyButton)UIElements.get("buy");
    b.active = false;
    
  }
  
  @Override
  void draw(){
    if(this.active){
      fill(255);
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeSmaller);
      fill(0);
      textAlign(LEFT,TOP);
      text(infoText,x,y,x+width, y+height);
    }
    
  }
}

class researchBuyButton extends UIElement{
  boolean active;
  int cost;
  String type;
  int level;
  researchBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = false;
    this.cost = -1;
    this.type = "";
    this.level = -1;
    
  }
  
  @Override
  void onClickAction(){
    
    println("testing enough");
    println(this.active);
    println(players[turn].hasEnoughRP(cost));
    infoBox i = (infoBox)UIElements.get("info");
    if(this.active && players[turn].hasEnoughRP(cost)){
      println("enough");
    switch(type){
      case "t":
        if(level == players[turn].tribesmenLevel+1){
          players[turn].spendResearch(cost);
          players[turn].tribesmenLevel = level;
          if(level == 5){
            println("speed");
            upgradeAllUnitsSpeed(players[turn]);
          }else if(level == 3){
            println("speed");
            upgradeAllUnitsDamage(players[turn]);
          }
        }
        break;
        case "d":
        if(level == players[turn].dwarvesLevel+1){
          players[turn].spendResearch(cost);
          players[turn].dwarvesLevel = level;
          if(level == 3){
            upgradeAllOwnedBuildings(players[turn]);
            
          }
        }
        break;
        case "s":
        if(level == players[turn].sorcerersLevel+1){
          players[turn].spendResearch(cost);
          players[turn].sorcerersLevel = level;
          if(level == 3){
            upgradeAllUnitsHealth(players[turn]);
            
          }
          else if(level == 5){
            upgradeAllWizards(players[turn]);
            
          }
          
        }
        break;
    }
    this.active = false;
    
    i.active = false;
    }else{
      i.infoText = "Not enough Research Points!";
    }
    
  }
  
  @Override
  void draw(){
    if(this.active){
      fill(255);
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeSmaller);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Buy: " + str(cost),x,y,width, height);
    }
    
  }
}

class treeLabel extends UIElement{
  String tribe;
  treeLabel(int x, int y, int width, int height, String tribe){
    super(x,y,width,height);
    this.tribe = tribe;
  }
  
  @Override
  void draw(){
    fill(255);
    stroke(128);
    rect(x,y,width,height);
    textSize(textSizeBig);
    fill(0);
    textAlign(CENTER,CENTER);
    text(tribe,x,y,width, height);
  }
}

class researchBuyBox extends UIElement{
  String text;
  int cost;
  int level;
  String type;
  researchBuyBox(int x, int y, int width, int height, String text, int cost, int level, String type){
    super(x,y,width,height);
    this.text = text;
    this.cost = cost;
    this.level = level;
    this.type = type;
  }
  
  @Override
  void onClickAction(){
    //throw text to infobox and buy button
    infoBox i = (infoBox)UIElements.get("info");
    researchBuyButton b = (researchBuyButton)UIElements.get("buy");
    
    i.infoText = this.text;
    i.active = true;
    b.cost = this.cost;
    b.type = this.type;
    b.active = true;
    b.level = level;
}
  
  @Override
  void draw(){
    switch(type){
      case "t":
        if(players[turn].tribesmenLevel >= level){
          fill(players[turn].teamColour);
        }else if(players[turn].hasEnoughRP(cost) && players[turn].tribesmenLevel == level-1){
          fill(255);
        }else{
          fill(128);
        }
        break;
      case "d":
        if(players[turn].dwarvesLevel >= level){
          fill(players[turn].teamColour);
        }else if(players[turn].hasEnoughRP(cost) && players[turn].dwarvesLevel == level-1){
          fill(255);
        }else{
          fill(128);
        }
        break;
       case "s":
        if(players[turn].sorcerersLevel >= level){
          fill(players[turn].teamColour);
        }else if(players[turn].hasEnoughRP(cost) && players[turn].sorcerersLevel == level-1){
          fill(255);
        }else{
          fill(128);
        }
        break;
    }
    
    stroke(128);
    rect(x,y,width,height);
    textSize(textSizeBig);
    fill(0);
    textAlign(CENTER,CENTER);
    text(str(level),x,y,width,height);
  }
}

class builderBuyButton extends UIElement{
  boolean active;
  builderBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = true;
  }
  @Override
  void onClickAction(){
    if(this.active){
      unitToSpawn = "Builder";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "The Builder will Allow you to Build Buildings\n\nCost: " + str(builderCost) + " Gold";
      i.active = true;
    }
    
  }
  @Override
  void draw(){
    if(selectedBuilding instanceof Barrack || selectedBuilding instanceof Base){
      this.active = true;
      fill(255);
      if(unitToSpawn == "Builder"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(40);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Bd",x,y,width, height);
    }else{
      this.active = false;
    }
    
  }
}

class swordsmanBuyButton extends UIElement{
  boolean active;
  swordsmanBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = false;
  }
  @Override
  void onClickAction(){
    if(this.active){
      unitToSpawn = "Swordsman";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "The swordsman is a powerful basic melee unit\n\nCost: " + str(swordCost) + " Gold";
      i.active = true;
    }
    
    
  }
  @Override
  void draw(){
    if(selectedBuilding instanceof Barrack){
      this.active = true;
      fill(255);
      if(unitToSpawn == "Swordsman"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeBig);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Sw",x,y,width, height);
    } else{
      this.active = false;
    }
  }
}

class archerBuyButton extends UIElement{
  boolean active;
  archerBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = true;
  }
  @Override
  void onClickAction(){
    if(this.active){
      unitToSpawn = "Archer";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "The Archer is a ranged unit\n\nCost: " + str(archerCost) + " Gold";
      i.active = true;
    }
    
  }
  @Override
  void draw(){
    if(selectedBuilding instanceof Barrack && players[turn].tribesmenLevel > 0){
      this.active = true;
      fill(255);
      if(unitToSpawn == "Archer"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeBig);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Ar",x,y,width, height);
    }else{
      this.active = false;
    }
    
  }
}
class cavalierBuyButton extends UIElement{
  boolean active;
  cavalierBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = true;
  }
  @Override
  void onClickAction(){
    if(this.active){
      unitToSpawn = "Cavalier";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "The Cavalier is a mobile and strong unit\n\nCost: " + str(cavalierCost) + " Gold";
      i.active = true;
    }
    
  }
  @Override
  void draw(){
    if(selectedBuilding instanceof Barrack && players[turn].tribesmenLevel > 1){
      this.active = true;
      fill(255);
      if(unitToSpawn == "Cavalier"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeBig);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Cv",x,y,width, height);
    }else{
      this.active = false;
    }
    
  }
}

class giantBuyButton extends UIElement{
  boolean active;
  giantBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = true;
  }
  @Override
  void onClickAction(){
    if(this.active){
      unitToSpawn = "Giant";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "The Giant is a high HP high ATK but slow unit\n\nCost: " + str(giantCost) + " Gold";
      i.active = true;
    }
    
  }
  @Override
  void draw(){
    if(selectedBuilding instanceof Barrack && players[turn].tribesmenLevel > 3){
      this.active = true;
      fill(255);
      if(unitToSpawn == "Giant"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeBig);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Gi",x,y,width, height);
    }else{
      this.active = false;
    }
    
  }
}

class wizardBuyButton extends UIElement{
  boolean active;
  wizardBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = true;
  }
  @Override
  void onClickAction(){
    println("clicked");
    if(this.active){
      unitToSpawn = "Wizard";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "The Wizard is a high ATK Unit with a large range but low hp\n\nCost: " + str(wizardCost) + " Gold";
      i.active = true;
    }
    
  }
  @Override
  void draw(){
    if(selectedBuilding instanceof Library && players[turn].sorcerersLevel > 1){
      this.active = true;
      fill(255);
      if(unitToSpawn == "Wizard"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeBig);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Wz",x,y,width, height);
    }else{
      this.active = false;
    }
    
  }
}

class trebuchetBuyButton extends UIElement{
  boolean active;
  trebuchetBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = true;
  }
  @Override
  void onClickAction(){
    println("clicked");
    if(this.active){
      unitToSpawn = "Trebuchet";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "The Trebuchet is a long range but low atk troop perfect for laying seige to buildings or defending an area however it is quite fragile and cannot move and attack in the same turn\n\nCost: " + str(trebuchetCost) + " Gold";
      i.active = true;
    }
    
  }
  @Override
  void draw(){
    if(selectedBuilding instanceof Barrack && players[turn].dwarvesLevel >= 5){
      this.active = true;
      fill(255);
      if(unitToSpawn == "Trebuchet"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeBig);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Tr",x,y,width, height);
    }else{
      this.active = false;
    }
    
  }
}

class dragonBuyButton extends UIElement{
  boolean active;
  dragonBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = true;
  }
  @Override
  void onClickAction(){
    println("clicked");
    if(this.active){
      unitToSpawn = "Dragon";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "The Dragon is a terrifying beast that can hit multiple units in a blast area watch out that your own units are not burnt to a crisp!\n\nCost: " + str(dragonCost) + " Gold";
      i.active = true;
    }
    
  }
  @Override
  void draw(){
    if(selectedBuilding instanceof Library && players[turn].sorcerersLevel >= 4){
      this.active = true;
      fill(255);
      if(unitToSpawn == "Dragon"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeBig);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Dr",x,y,width, height);
    }else{
      this.active = false;
    }
    
  }
}


class mineBuyButton extends UIElement{
  boolean active;
  mineBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = false;
  }
  @Override
  void onClickAction(){
    if(this.active){
      toBuildClass = "Gold";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "The mine will give you 1 gold per turn\n\nCost: " + str(goldMineCost) + " Gold";
      i.infoText += "\nBuildTime: " + str(mineBuildTime) + " Turns";
      i.active = true;
    }
    
  }
  @Override
  void draw(){
    if(buildMode){
      this.active = true;
      fill(255);
      if(toBuildClass == "Gold"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeBig);
      fill(0);
      textAlign(CENTER,CENTER);
      text("GM",x,y,width, height);
    }else{
      this.active = false;
    }
   }
    
   
}

class wallBuyButton extends UIElement{
  boolean active;
  wallBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = false;
  }
  @Override
  void onClickAction(){
    if(this.active){
      println("TO build wall");

      toBuildClass = "Wall";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "Walls ought to stop enemy units in their tracks!\n\nCost: " + str(wallCost) + " Gold";
      i.infoText += "\nBuildTime: " + str(wallBuildTime) + " Turns";
      i.active = true;
    }
    
  }
  @Override
  void draw(){
    if(buildMode && players[turn].dwarvesLevel > 1){
      this.active = true;
      fill(255);
      if(toBuildClass == "Wall"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeBig);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Wa",x,y,width, height);
    }else{
      this.active = false;
    }
   }
    
   
}

class barracksBuyButton extends UIElement{
  boolean active;
  barracksBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
  }
  @Override
  void onClickAction(){
    if(this.active){
      toBuildClass = "Barrack";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "Barracks allow you to train units\n\nCost: " + str(barrackCost) + " Gold";
      i.infoText += "\nBuildTime: " + str(barracksBuildTime) + " Turns";
      i.active = true;
    }
  }
  @Override
  void draw(){
    if(buildMode){
      this.active = true;
      fill(255);
      if(toBuildClass == "Barrack"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeBig);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Br",x,y,width, height);
    }else{
      this.active = false;
    }
  }
}

class libraryBuyButton extends UIElement{
  boolean active;
  libraryBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
  }
  @Override
  void onClickAction(){
    if(this.active){
      toBuildClass = "Library";
      infoBox i = (infoBox)UIElements.get("info");
      
      i.infoText = "The Library gives you one Research point per turn\n\nCost: " + str(libraryCost) + " Gold";
      i.infoText += "\nBuildTime: " + str(libraryBuildTime) + " Turns";
      i.active = true;
    }
  }
  @Override
  void draw(){
    if(buildMode && players[turn].sorcerersLevel > 0){
      this.active = true;
      fill(255);
      if(toBuildClass == "Library"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(textSizeBig);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Li",x,y,width, height);
    }else{
      this.active = false;
    }
   }
}
void upgradeAllOwnedBuildings(Player p){
  for(Tile[] ts : gameBoard.grid){
    for(Tile t: ts){
      if(t.building!=null && t.building.owner.equals(p)){
        t.building.maxHealth+=dwarvesBonusHP;
        t.building.health +=dwarvesBonusHP;
      }
    }
    
  }
}

void upgradeAllUnitsSpeed(Player p){
  for(Tile[] ts : gameBoard.grid){
    for(Tile t: ts){
      if(t.unit!=null && t.unit.owner.equals(p)){
        t.unit.mov+=1;
        
      }
    }
    
  }
}

void upgradeAllUnitsHealth(Player p){
  for(Tile[] ts : gameBoard.grid){
    for(Tile t: ts){
      if(t.unit!=null && t.unit.owner.equals(p)){
        t.unit.maxhp+=sorcererBonusHP;
        t.unit.hp+=sorcererBonusHP;
      }
    }
    
  }
}

void upgradeAllUnitsDamage(Player p){
  for(Tile[] ts : gameBoard.grid){
    for(Tile t: ts){
      if(t.unit!=null && t.unit.owner.equals(p)){
        t.unit.strength+=1;
      }
    }
    
  }
}

void upgradeAllWizards(Player p){
  for(Tile[] ts : gameBoard.grid){
    for(Tile t: ts){
      if(t.unit instanceof Wizard && t.unit.owner.equals(p)){
        t.unit.strength+=sorcererBonusArcane;
        
      }
    }
    
  }
}
