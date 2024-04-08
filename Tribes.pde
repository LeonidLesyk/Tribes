import java.util.*;

//final int screen_width = 1920;// fullHD :)
//final int screen_height = 1080;
int tileZoneLeft;
int tileZoneRight;

int screen_width;
int screen_height;

static Board gameBoard;
int tileSizePixels;
int turn;
HashMap<String,UIElement> UIElements;

boolean gameEnd=false;

Building selectedBuilding = null;
String unitToSpawn  = "";
Set<Tile> availbleTiles;

Player[] players;
String toBuildClass = "";

int researchCap; 
static Player player1;
static Player player2;

void settings(){
  //size(1500,800);
  fullScreen();
  pixelDensity(displayDensity());
}

void setup(){
  
  screen_width = width;
  screen_height = height;
  
  tileZoneLeft = (screen_width-screen_height)/2;
  tileZoneRight = tileZoneLeft + screen_height;
  
  
  //initialise game variables
  turn = 0;
  int size = 10;
  tileSizePixels = screen_height/size;
  players = new Player[2];
  
  gameEnd = false;
  
  player1 = new Player(color(255,0,0));
  player2 = new Player(color(0,0,255));
  players[0] = player1;
  players[1] = player2;

  
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
  UIElements = new HashMap<String,UIElement>();
  UIElement endTurn = new endTurnButton(0,0,tileZoneLeft,screen_height/10);
  UIElements.put("endTurn",endTurn);
  UIElement gold = new goldDisplay(tileZoneRight,0,(tileZoneLeft)/2,screen_height/10);
  UIElements.put("gold",gold);
  UIElement research = new researchDisplay(tileZoneRight + (tileZoneLeft)/2,0,(tileZoneLeft)/2,screen_height/10);
  UIElements.put("research",research);
  UIElement info = new infoBox(0,screen_height*7/10,tileZoneLeft,screen_height/5,"default text");
  UIElements.put("info",info);
  UIElement buy = new researchBuyButton(0,screen_height*9/10,tileZoneLeft,screen_height/10);
  UIElements.put("buy",buy);
  UIElement tribesmanLabel = new treeLabel(tileZoneRight,screen_height*9/10,tileZoneLeft/3,screen_height/10,"Tribesmen");
  UIElements.put("Tribesmen",tribesmanLabel);
  UIElement dwarfLabel = new treeLabel(tileZoneRight + tileZoneLeft/3,screen_height*9/10,tileZoneLeft/3,screen_height/10,"Dwarves");
  UIElements.put("Dwarves",dwarfLabel);
  UIElement sorcererLabel = new treeLabel(tileZoneRight + tileZoneLeft*2/3,screen_height*9/10,tileZoneLeft/3,screen_height/10,"Sorcery");
  UIElements.put("Sorcery",sorcererLabel);
  
  UIElement swBuy = new swordsmanBuyButton(0,screen_height/10,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("swBuy",swBuy);
  UIElement arBuy = new swordsmanBuyButton(tileZoneLeft/6,screen_height/10,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("arBuy",arBuy);
  
  researchCap = 3;
  String[] tribesmenResearchDescriptions = new String[researchCap];
  String[] dwarvesResearchDescriptions = new String[researchCap];
  String[] sorcerersResearchDescriptions = new String[researchCap];
  int[] tribesmenResearchCosts = new int[researchCap];
  int[] dwarvesResearchCosts = new int[researchCap];
  int[] sorcerersResearchCosts = new int[researchCap];
  
  tribesmenResearchDescriptions[0] = "tribesmen research one";
  tribesmenResearchDescriptions[1] = "tribesmen research two";
  tribesmenResearchDescriptions[2] = "tribesmen research three";
  dwarvesResearchDescriptions[0] = "dwarves research one";
  dwarvesResearchDescriptions[1] = "dwarves research two";
  dwarvesResearchDescriptions[2] = "dwarves research three";
  sorcerersResearchDescriptions[0] = "sorcerers research one";
  sorcerersResearchDescriptions[1] = "sorcerers research two";
  sorcerersResearchDescriptions[2] = "sorcerers research three";
  
  tribesmenResearchCosts[0] = 1;
  tribesmenResearchCosts[1] = 2;
  tribesmenResearchCosts[2] = 3;
  dwarvesResearchCosts[0] = 1;
  dwarvesResearchCosts[1] = 2;
  dwarvesResearchCosts[2] = 3;
  sorcerersResearchCosts[0] = 1;
  sorcerersResearchCosts[1] = 2;
  sorcerersResearchCosts[2] = 3;
  
  for(int i = 0; i<researchCap; i++){
    UIElement t = new researchBuyBox(tileZoneRight,screen_height*9/10 - screen_height*(i+1)/12,screen_height/12,screen_height/12,tribesmenResearchDescriptions[i],tribesmenResearchCosts[i],i+1,"t");
    UIElements.put("t"+str(i),t);
    UIElement d = new researchBuyBox(tileZoneRight + tileZoneLeft/3,screen_height*9/10 - screen_height*(i+1)/12,screen_height/12,screen_height/12,dwarvesResearchDescriptions[i],dwarvesResearchCosts[i],i+1,"d");
    UIElements.put("d"+str(i),d);
    UIElement s = new researchBuyBox(tileZoneRight+ tileZoneLeft*2/3,screen_height*9/10 - screen_height*(i+1)/12,screen_height/12,screen_height/12,sorcerersResearchDescriptions[i],sorcerersResearchCosts[i],i+1,"s");
    UIElements.put("s"+str(i),s);
    
  }
}

void draw(){
  if(!gameEnd){
    background(0);
    //println(frameRate);
    gameBoard.draw();
    //draw UI Elements
    for(UIElement e : UIElements.values()){
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
  if(gameEnd){
    setup();
  }
  
  
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
    
    //Building logic
    else if(pressedTile.building == null && pressedTile.unit == null && !toBuildClass.equals("")){
      if(toBuildClass.equals("Barrack")){
        pressedTile.building = new Barrack(pressedTile.position, players[turn%2], pressedTile.size);
        toBuildClass = "";
      }
      else if(toBuildClass.equals("Library")){
        pressedTile.building = new Library(pressedTile.position, players[turn%2] , pressedTile.size);
        toBuildClass = "";
      }
      else if(toBuildClass.equals("Gold")){
        pressedTile.building = new GoldMine(pressedTile.position, players[turn%2], pressedTile.size);
        toBuildClass = "";
      }
    }
    
    //Clicked Barrack
    else if(pressedTile.building != null && pressedTile.building instanceof Barrack){
      
      availbleTiles = gameBoard.range(pressedTile,1);

      selectedBuilding = pressedTile.building;
      println("Barrack selected");
    }
    
    //Clicked an empty tile to spawn a unit after clicking Barrack
    else if(pressedTile.building == null && pressedTile.unit == null && availbleTiles != null && availbleTiles.contains(pressedTile) && selectedBuilding != null && selectedBuilding instanceof Barrack && !unitToSpawn.equals("")){
      
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
    for(UIElement e : UIElements.values()){
      //check inside region
      if(mouseX > e.x && mouseX < e.x + e.width && mouseY > e.y && mouseY < e.y + e.height){
        e.onClickAction();
      }
    }
  }
  
}


//Test for spawning units
void keyPressed() {
    if (key == '1') {
      println("ToSpawn: Swordsman");
      unitToSpawn = "Swordsman";
    }
    else if (key == '2') {
      println("ToSpawn: Archer");
      unitToSpawn = "Archer";
    }
    else if (key == 'Q' || key == 'q') {
      toBuildClass = "Barrack";
    }
    else if (key == 'W' || key == 'w') {
      toBuildClass = "Library";
    }
    else if (key == 'E' || key == 'e') {
      toBuildClass = "Gold";
    }
    else if(key == ESC){
      println("Cancelled");
      selectedBuilding = null;
      unitToSpawn = "";
    }
}
