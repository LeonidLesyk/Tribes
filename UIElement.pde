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

    //end turn actions e.g. add gold, research points calculate sight etc
    int currnetPlayer = turn%2;
    
    //loop through each cell
    for(int i=0; i<gameBoard.grid.length; i++){
      for(int j=0; j<gameBoard.grid[i].length; j++){
        if(gameBoard.grid[i][j].building != null && gameBoard.grid[i][j].building instanceof Library && gameBoard.grid[i][j].building.owner == Tribes.playerList.get(currnetPlayer)){
          Tribes.playerList.get(currnetPlayer).researchPoints += gameBoard.grid[i][j].building.turnEndAction();
          println(Tribes.playerList.get(currnetPlayer).researchPoints);
        }
        if(gameBoard.grid[i][j].building != null && gameBoard.grid[i][j].building instanceof GoldMine && gameBoard.grid[i][j].building.owner == Tribes.playerList.get(currnetPlayer)){
          Tribes.playerList.get(currnetPlayer).gold += gameBoard.grid[i][j].building.turnEndAction();
          println(Tribes.playerList.get(currnetPlayer).researchPoints);
        }
      }
    }
  
    
    
  }
  
  @Override
  void draw(){
    fill(255);
    rect(x,y,width,height);
    textSize(40);
    fill(0);
    text("End Turn: " + str(turn),x,y+40);
  }
}
