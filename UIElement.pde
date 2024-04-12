class UIElement{
  int x;
  int y;
  int width;
  int height;
  UIElement(int x, int y, int width, int height){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    
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
          
          if(gameBoard.grid[i][j].building instanceof Library){
            players[currnetPlayer].researchPoints += gameBoard.grid[i][j].building.turnEndAction();
            println("Player " + turn + "RP: "+ players[currnetPlayer].researchPoints);          
          }
          else if(gameBoard.grid[i][j].building instanceof GoldMine){
            players[currnetPlayer].gold += gameBoard.grid[i][j].building.turnEndAction();
            println("Player " + turn + "Gold: "+ players[currnetPlayer].gold);          
          }
          else{
            gameBoard.grid[i][j].building.turnEndAction();
          }

        }
      }
    }
    //deactivate info and buy button
    infoBox i = (infoBox)UIElements.get("info");
    researchBuyButton b = (researchBuyButton)UIElements.get("buy");
    i.active = false;
    b.active = false;
    
    //end turn
    turn +=1;
    
    if( turn == 2){
      turn = 0;
    }
    
  }
  
  @Override
  void draw(){
    fill(players[turn].teamColour);
    stroke(128);
    rect(x,y,width,height);
    textSize(40);
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
    textSize(40);
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
    textSize(40);
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
      textSize(32);
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
        }
        break;
        case "d":
        if(level == players[turn].dwarvesLevel+1){
          players[turn].spendResearch(cost);
          players[turn].dwarvesLevel = level;
        }
        break;
        case "s":
        if(level == players[turn].sorcerersLevel+1){
          players[turn].spendResearch(cost);
          players[turn].sorcerersLevel = level;
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
      textSize(32);
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
    textSize(40);
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
          fill(0,0,255);
        }else if(players[turn].hasEnoughRP(cost)){
          fill(255);
        }else{
          fill(128);
        }
        break;
      case "d":
        if(players[turn].dwarvesLevel >= level){
          fill(0,0,255);
        }else if(players[turn].hasEnoughRP(cost)){
          fill(255);
        }else{
          fill(128);
        }
        break;
       case "s":
        if(players[turn].sorcerersLevel >= level){
          fill(0,0,255);
        }else if(players[turn].hasEnoughRP(cost)){
          fill(255);
        }else{
          fill(128);
        }
        break;
    }
    
    stroke(128);
    rect(x,y,width,height);
    textSize(40);
    fill(0);
    textAlign(CENTER,CENTER);
    text(str(level),x,y,width,height);
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
      
      i.infoText = "The swordsman is a powerful basic melee unit...";
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
      textSize(40);
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
      
      i.infoText = "The Archer is a ranged unit...";
      i.active = true;
    }
    
  }
  @Override
  void draw(){
    if(selectedBuilding instanceof Barrack){
      this.active = true;
      fill(255);
      if(unitToSpawn == "Archer"){
        fill(players[turn].teamColour);
      }
      stroke(128);
      rect(x,y,width,height);
      textSize(40);
      fill(0);
      textAlign(CENTER,CENTER);
      text("Ar",x,y,width, height);
    }else{
      this.active = false;
    }
    
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
      
      i.infoText = "The Builder will allow you to build buildings...";
      i.active = true;
    }
    
  }
  @Override
  void draw(){
    if(selectedBuilding instanceof Barrack){
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

class mineBuyButton extends UIElement{
  mineBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
  }
  @Override
  void onClickAction(){
    toBuildClass = "Gold";
    infoBox i = (infoBox)UIElements.get("info");
    
    i.infoText = "The mine will give you x gold per turn";
    i.active = true;
  }
  @Override
  void draw(){
    
    fill(255);
    if(toBuildClass == "Gold"){
      fill(0,0,255);
    }
    stroke(128);
    rect(x,y,width,height);
    textSize(40);
    fill(0);
    textAlign(CENTER,CENTER);
    text("GM",x,y,width, height);
  }
}

class barracksBuyButton extends UIElement{
  barracksBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
  }
  @Override
  void onClickAction(){
    toBuildClass = "Barrack";
    infoBox i = (infoBox)UIElements.get("info");
    
    i.infoText = "Barracks allow you to train units";
    i.active = true;
  }
  @Override
  void draw(){
    
    fill(255);
    if(toBuildClass == "Barrack"){
      fill(0,0,255);
    }
    stroke(128);
    rect(x,y,width,height);
    textSize(40);
    fill(0);
    textAlign(CENTER,CENTER);
    text("Br",x,y,width, height);
  }
}

class libraryBuyButton extends UIElement{
  libraryBuyButton(int x, int y, int width, int height){
    super(x,y,width,height);
  }
  @Override
  void onClickAction(){
    toBuildClass = "Library";
    infoBox i = (infoBox)UIElements.get("info");
    
    i.infoText = "The Library gives you one Research point per turn";
    i.active = true;
  }
  @Override
  void draw(){
    
    fill(255);
    if(toBuildClass == "Library"){
      fill(0,0,255);
    }
    stroke(128);
    rect(x,y,width,height);
    textSize(40);
    fill(0);
    textAlign(CENTER,CENTER);
    text("Li",x,y,width, height);
  }
}
