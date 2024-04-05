//final int screen_width = 1920;// fullHD :)
//final int screen_height = 1080;

int screen_width;
int screen_height;

int tileZoneLeft;
int tileZoneRight;
Board gameBoard;
int tileSizePixels;
int turn;
ArrayList<UIElement> UIElements;

void settings() {
  //fullScreen();
  size(1512, 982);
  pixelDensity(displayDensity());
}

void setup() {
  screen_width = width;
  screen_height = height;

  tileZoneLeft = (screen_width-screen_height)/2;
  tileZoneRight = tileZoneLeft + screen_height;
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
  UIElement endTurn = new endTurnButton(0, 0, tileZoneLeft, screen_height/10);
  UIElements.add(endTurn);
}

void draw() {
  background(0);
  //println(frameRate);
  gameBoard.draw();
  //draw UI Elements
  for (UIElement e : UIElements) {
    e.draw();
  }
}

void mouseReleased() {
  //if in tile zone
  if (mouseX > tileZoneLeft && mouseX < tileZoneRight) {
    int x = (mouseX - tileZoneLeft)/tileSizePixels;
    int y = mouseY/tileSizePixels;
    Tile pressedTile = gameBoard.grid[x][y];
    //tile interaction goes here
    for (Tile t : gameBoard.range(pressedTile, 2)) {
      t.colour -= 20;
    }
  } else {
    //else inside ui elements
    for (UIElement e : UIElements) {
      if (mouseX > e.x && mouseX < e.x + e.width && mouseY > e.y && mouseY < e.y + e.height) {
        e.onClickAction();
      }
    }
  }
}
