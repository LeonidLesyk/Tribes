import java.util.*;

final int screen_width = 1280;// fullHD :)
final int screen_height = 720;
int tileZoneLeft = (screen_width-screen_height)/2;
int tileZoneRight = tileZoneLeft + screen_height;
static Board gameBoard;
int tileSizePixels;
int turn;
ArrayList<UIElement> UIElements;

boolean gameEnd=false;

Building selectedBuilding = null;
String unitToSpawn = "";
Set<Tile> availbleTiles;

static Player player1;
static Player player2;
static ArrayList<Player> playerList;

void settings(){
  size(screen_width,screen_height);
}

void setup(){
  //initialise game variables
  turn = 1;
  int size = 10;
  tileSizePixels = screen_height/size;
  
  
  player1 = new Player(color(255,0,0));
  player2 = new Player(color(0,0,255));
  playerList = new ArrayList<Player>(Arrays.asList(player1, player2));

  
  gameBoard = new Board(size);
  
  gameBoard.grid[8][1].building = new Base(gameBoard.grid[8][1].position, player1, gameBoard.grid[8][1].size);
  gameBoard.grid[2][9].building = new Base(gameBoard.grid[2][9].position, player2, gameBoard.grid[2][9].size);
  
  gameBoard.grid[8][0].building = new Library(gameBoard.grid[8][0].position, player1, gameBoard.grid[8][0].size);
  gameBoard.grid[1][8].building = new Library(gameBoard.grid[1][8].position, player2, gameBoard.grid[1][8].size);
  
  gameBoard.grid[7][0].building = new Wall(gameBoard.grid[7][0].position, player1, gameBoard.grid[7][0].size);
  gameBoard.grid[2][8].building = new Wall(gameBoard.grid[2][8].position, player2, gameBoard.grid[2][8].size);
  
  gameBoard.grid[5][0].building = new Barrack(gameBoard.grid[5][0].position, player1, gameBoard.grid[5][0].size);
  gameBoard.grid[4][8].building = new Barrack(gameBoard.grid[4][8].position, player2, gameBoard.grid[4][8].size);
  
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
    background(0); // Dark background for the game over screen
    fill(255, 0, 0); // Set text color to red
    textSize(64); // Increase text size for impact
    textAlign(CENTER, CENTER); // Center the text horizontally and vertically
    text("GAME OVER", screen_width / 2, screen_height / 2); // Display "GAME OVER" at the center of the screen

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
    
    //Clicked Base
    if(pressedTile.building != null && pressedTile.building instanceof Base){
      println("Applying damage to Base");
   
      if(pressedTile.building.applyDamage(250)){
        print(pressedTile.building.owner + " lose");
        gameEnd = true; //Make a method for ending scene?
      }
      println("Base HP: " + pressedTile.building.health);
      
    }
    
    //Clicked Barrack
    else if(pressedTile.building != null && pressedTile.building instanceof Barrack){
      
      availbleTiles = gameBoard.range(pressedTile,1);

      selectedBuilding = pressedTile.building;
      println("Barrack selected");
    }
    
    //Clicked an empty tile to spawn a unit after clicking Barrack
    else if(pressedTile.building == null && pressedTile.unit == null && availbleTiles != null && availbleTiles.contains(pressedTile) && selectedBuilding != null && selectedBuilding instanceof Barrack){
      
      println("Spawn " + unitToSpawn);
      if(unitToSpawn.equals("Swordsman")){
        pressedTile.unit = new Swordsman(selectedBuilding.owner);
        selectedBuilding = null; //Reset selection
        unitToSpawn = "";
        availbleTiles = null;
      }
      else if(unitToSpawn.equals("Archer")){
        pressedTile.unit = new Archer(selectedBuilding.owner);
        selectedBuilding = null; //Reset selection
        unitToSpawn = "";
        availbleTiles = null;
      }
    }
    //Check clicked swordsman
    else if(pressedTile.unit != null  && pressedTile.unit instanceof Swordsman){
      println("Clicked Swordsman");

    }
    
    else{
      println("Clicked other");
    }
    
    
  }else{
    //else inside ui elements
  }
  
}


//Test for spawning units
void keyPressed() {
    if (key == '1') {
      unitToSpawn = "Swordsman";
    }
    else if (key == '2') {
      unitToSpawn = "Archer";
    }
    else if(key == ESC){
      println("Cancelled");
      selectedBuilding = null;
      unitToSpawn = "";
    }
}
