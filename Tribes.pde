final int screen_width = 1280;// fullHD :)
final int screen_height = 720;
int tileZoneLeft = (screen_width-screen_height)/2;
int tileZoneRight = tileZoneLeft + screen_height;
Board gameBoard;
int tileSizePixels;
int turn;
ArrayList<UIElement> UIElements;

void settings(){
  size(screen_width,screen_height);
}

void setup(){
  //initialise game variables
  turn = 0;
  int size = 10;
  tileSizePixels = screen_height/size;
  gameBoard = new Board(size);
  
  //gameBoard.grid[0][0].building = new Building(gameBoard.grid[0][0].position,1,"",gameBoard.grid[0][0].size);
  
  //add UI Elements
  UIElements = new ArrayList<UIElement>();
  UIElement endTurn = new endTurnButton(0,0,tileZoneLeft,screen_height/10);
  UIElements.add(endTurn);
  
}

void draw(){
  background(0);
  //println(frameRate);
  gameBoard.draw();
  //draw UI Elements
  for(UIElement e : UIElements){
    e.draw();
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
  }else{
    //else inside ui elements
  }
  
}
