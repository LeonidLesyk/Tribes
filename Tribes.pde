final int screen_width = 1280;// fullHD :)
final int screen_height = 720;

Board gameBoard;

void settings(){
  size(screen_width,screen_height);
}

void setup(){
  gameBoard = new Board(10);
  gameBoard.grid[8][1].building = new Base(gameBoard.grid[8][1].position, 1, gameBoard.grid[8][1].size);
  gameBoard.grid[2][9].building = new Base(gameBoard.grid[2][9].position, 0, gameBoard.grid[2][9].size);

  gameBoard.grid[8][0].building = new Library(gameBoard.grid[8][0].position, 1, gameBoard.grid[8][0].size);
  gameBoard.grid[1][8].building = new Library(gameBoard.grid[1][8].position, 0, gameBoard.grid[1][8].size);

  gameBoard.grid[7][0].building = new Wall(gameBoard.grid[7][0].position, 1, gameBoard.grid[7][0].size);
  gameBoard.grid[2][8].building = new Wall(gameBoard.grid[2][8].position, 0, gameBoard.grid[2][8].size);
  
  gameBoard.grid[5][0].building = new Barrack(gameBoard.grid[5][0].position, 1, gameBoard.grid[5][0].size);
  gameBoard.grid[4][8].building = new Barrack(gameBoard.grid[4][8].position, 0, gameBoard.grid[4][8].size);

}

void draw(){
  background(0);
  println(frameRate);
  gameBoard.draw();
}
