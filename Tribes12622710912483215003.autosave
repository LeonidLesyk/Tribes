final int screen_width = 1280;// fullHD :)
final int screen_height = 720;

Board gameBoard;

void settings(){
  size(screen_width,screen_height);
}

void setup(){
  gameBoard = new Board(10);
  //gameBoard.grid[0][0].building = new Building(gameBoard.grid[0][0].position,1,"",gameBoard.grid[0][0].size);
}

void draw(){
  background(0);
  println(frameRate);
  gameBoard.draw();
}
