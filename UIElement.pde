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
    //end turn
    turn +=1;
    
    if( turn == 2){
      turn = 0;
    }

    //end turn actions e.g. add gold, research points calculate sight etc
    int currnetPlayer = turn%2;
    
    //loop through each cell
    for(int i=0; i<gameBoard.grid.length; i++){
      for(int j=0; j<gameBoard.grid[i].length; j++){
        if(gameBoard.grid[i][j].building != null && gameBoard.grid[i][j].building instanceof Library && gameBoard.grid[i][j].building.owner == Tribes.playerList.get(currnetPlayer)){
          Tribes.playerList.get(currnetPlayer).researchPoints += gameBoard.grid[i][j].building.turnEndAction();
          println("Player " + turn + "RP: "+ Tribes.playerList.get(currnetPlayer).researchPoints);
        }
        if(gameBoard.grid[i][j].building != null && gameBoard.grid[i][j].building instanceof GoldMine && gameBoard.grid[i][j].building.owner == Tribes.playerList.get(currnetPlayer)){
          Tribes.playerList.get(currnetPlayer).gold += gameBoard.grid[i][j].building.turnEndAction();
          println("Player " + turn + "Gold: "+ Tribes.playerList.get(currnetPlayer).gold);
        }
      }
    }
    
    
  }
  
  @Override
  void draw(){
    fill(255);
    stroke(128);
    rect(x,y,width,height);
    textSize(40);
    fill(0);
    textAlign(LEFT,CENTER);
    text("End Turn: " + str(turn),x,y,x+width, y+height);
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
    this.active = true;
    this.infoText = t;
  }
  
  @Override
  void onClickAction(){
    this.active = false;
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

class buyButton extends UIElement{
  boolean active;
  int cost;
  buyButton(int x, int y, int width, int height){
    super(x,y,width,height);
    this.active = true;
    this.cost = 0;
  }
  
  @Override
  void onClickAction(){
    this.active = false;
  }
  
  @Override
  void draw(){
    if(this.active){
      fill(255);
      stroke(128);
      rect(x,y,width,height);
      textSize(32);
      fill(0);
      textAlign(CENTER,TOP);
      text("buy: " + str(cost),x,y+40,x+width, y+height);
    }
    
  }
}

class researchBuyBox extends UIElement{
  String text;
  int cost;
  
  researchBuyBox(int x, int y, int width, int height, String text, int cost){
    super(x,y,width,height);
    this.text = text;
    this.cost = cost;
  }
  
  @Override
  void onClickAction(){
    //throw text to infobox 
  }
  
  @Override
  void draw(){
    fill(255);
    stroke(128);
    rect(x,y,width,height);
    textSize(40);
    fill(0);
    text("RP: " + str(players[turn].researchPoints),x,y+40);
  }
}
