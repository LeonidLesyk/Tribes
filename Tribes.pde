final int screen_width = 1280;// fullHD :)
final int screen_height = 720;
int tileZoneLeft = (screen_width-screen_height)/2;
int tileZoneRight = tileZoneLeft + screen_height;
Board gameBoard;
int tileSizePixels;
int turn;
ArrayList<UIElement> UIElements;

boolean gameEnd=false;

void settings(){
  size(screen_width,screen_height);
}

void setup(){
  //initialise game variables
  turn = 0;
  int size = 10;
  tileSizePixels = screen_height/size;
  gameBoard = new Board(size);
  
   gameBoard.grid[8][1].building = new Base(gameBoard.grid[8][1].position, 1, gameBoard.grid[8][1].size);
   gameBoard.grid[2][9].building = new Base(gameBoard.grid[2][9].position, 0, gameBoard.grid[2][9].size);

   gameBoard.grid[8][0].building = new Library(gameBoard.grid[8][0].position, 1, gameBoard.grid[8][0].size);
   gameBoard.grid[1][8].building = new Library(gameBoard.grid[1][8].position, 0, gameBoard.grid[1][8].size);

   gameBoard.grid[7][0].building = new Wall(gameBoard.grid[7][0].position, 1, gameBoard.grid[7][0].size);
   gameBoard.grid[2][8].building = new Wall(gameBoard.grid[2][8].position, 0, gameBoard.grid[2][8].size);
  
   gameBoard.grid[5][0].building = new Barrack(gameBoard.grid[5][0].position, 1, gameBoard.grid[5][0].size);
   gameBoard.grid[4][8].building = new Barrack(gameBoard.grid[4][8].position, 0, gameBoard.grid[4][8].size);
  
  //add UI Elements
  UIElements = new ArrayList<UIElement>();
  UIElement endTurn = new endTurnButton(0,0,tileZoneLeft,screen_height/10);
  UIElements.add(endTurn);
  
}

void draw(){
  if(!gameEnd){
    background(0);
    //println(frameRate);
    gameBoard.draw();
    //draw UI Elements
    for(UIElement e : UIElements){
      e.draw();
    }
  }
  else{
    //Game end scene
  }
}

void mouseReleased(){
  //if in tile zone
  if(mouseX > tileZoneLeft && mouseX < tileZoneRight){
    int x = (mouseX - tileZoneLeft)/tileSizePixels;
    int y = mouseY/tileSizePixels;
    Tile pressedTile = gameBoard.grid[x][y];
    //tile interaction goes here
    for(Tile t : gameBoard.range(pressedTile,2)){
      t.colour -= 20;
    }
    
    if(pressedTile.building != null && pressedTile.building instanceof Base){
      println("Applying damage to Base");
      pressedTile.building.applyDamage(500);
    }
    else if(pressedTile.building != null && pressedTile.building instanceof Barrack){
      
    }
    
    
    
  }else{
    //else inside ui elements
  }
  
}
