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
    if(turn == 2){
      turn = 0;
    }
    //end turn actions e.g. add gold, research points calculate sight etc
  }
  
  @Override
  void draw(){
    fill(255);
    stroke(128);
    rect(x,y,width,height);
    textSize(40);
    fill(0);
    text("End Turn: " + str(turn),x,y+40);
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
    text("Gold: " + str(players[turn].gold),x,y+40);
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
    text("Research: " + str(players[turn].researchPoints),x,y+40);
  }
}
