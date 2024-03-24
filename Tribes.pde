final int screen_width = 1280;// fullHD :)
final int screen_height = 720;
int tileZoneLeft = (screen_width-screen_height)/2;
int tileZoneRight = tileZoneLeft + screen_height;
Board gameBoard;
int tileSizePixels;
void settings(){
  size(screen_width,screen_height);
}

void setup(){
  int size = 10;
  gameBoard = new Board(size);
  tileSizePixels = screen_height/size;
  //gameBoard.grid[0][0].building = new Building(gameBoard.grid[0][0].position,1,"",gameBoard.grid[0][0].size);
}

void draw(){
  background(0);
  //println(frameRate);
  gameBoard.draw();
}

void mouseReleased(){
  //if in tile zone
  if(mouseX > tileZoneLeft && mouseX < tileZoneRight){
    println("in");
    int x = (mouseX - tileZoneLeft)/tileSizePixels;
    int y = mouseY/tileSizePixels;
    Tile pressedTile = gameBoard.grid[x][y];
    //tile interaction goes here
    for(Tile t : gameBoard.range(pressedTile,2)){
      t.colour -= 20;
    }  
  }else{
    //else in side ui elements
  }
  
}
