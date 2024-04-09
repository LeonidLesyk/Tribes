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

Tile pressedTile;

Building selectedBuilding = null;
String unitToSpawn  = "";
Set<Tile> availbleTiles;

Tile selectedTile;

Player[] players;
String toBuildClass = "";
boolean buildMode=false;

int researchCap; 
static Player player1;
static Player player2;

void settings(){
  //size(1500,800);
  size(1920,1080);
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
  
  //unit buy UIElements
  UIElement bdBuy = new builderBuyButton(0,screen_height/10,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("bdBuy",bdBuy);
  UIElement swBuy = new swordsmanBuyButton(tileZoneLeft/6,screen_height/10,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("swBuy",swBuy);
  UIElement arBuy = new archerBuyButton(tileZoneLeft*2/6,screen_height/10,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("arBuy",arBuy);
  
  //bulding buy UIElements
  UIElement mineBuy = new mineBuyButton(0,screen_height/10 + tileZoneLeft*2/6,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("mineBuy",mineBuy);
  UIElement barracksBuy = new barracksBuyButton(tileZoneLeft/6,screen_height/10 + tileZoneLeft*2/6,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("barracksBuy",barracksBuy);
  UIElement libraryBuy = new libraryBuyButton(tileZoneLeft*2/6,screen_height/10 + tileZoneLeft*2/6,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("libraryBuy",libraryBuy);
  
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
    pressedTile = gameBoard.grid[x][y];
    
    //clear highlight on previous tile
    if(selectedTile != null) {
      for(Tile t : gameBoard.range(selectedTile,2)){
        t.colour = t.defaultColour;
      }
      selectedTile.colour = selectedTile.defaultColour;
    }
    
    
    /*
    //tile interaction goes here
    for(Tile t : gameBoard.range(pressedTile,2)){
      t.colour = t.highlight;
    }
    */
    
    pressedTile.colour = pressedTile.highlight;
    
    //Clicked Base
    if(pressedTile.building != null && pressedTile.building instanceof Base){
      println("Applying damage to Base");
   
      if(pressedTile.building.applyDamage(250)){
        print(pressedTile.building.owner + " lose");
        gameEnd = true; //Make a method for ending scene?
      }
      println("Base HP: " + pressedTile.building.health);
      
    }
    

    
    //If clicked on builder
    else if(pressedTile.building == null && pressedTile.unit != null && pressedTile.unit instanceof Builder){
      availbleTiles = gameBoard.range(pressedTile, pressedTile.unit.atkRange);
      buildMode = true;
    }
    
    //Building logic
    else if(pressedTile.building == null && pressedTile.unit == null && !toBuildClass.equals("") && buildMode==true && availbleTiles.contains(pressedTile)){
      if(toBuildClass.equals("Barrack")){
        pressedTile.building = new Barrack(pressedTile.position, players[turn%2], pressedTile.size);
        toBuildClass = "";
        buildMode = false;
        availbleTiles = null;
        infoBox i = (infoBox)UIElements.get("info");
        i.active = false;
      }
      else if(toBuildClass.equals("Library")){
        pressedTile.building = new Library(pressedTile.position, players[turn%2] , pressedTile.size);
        toBuildClass = "";
        buildMode = false;
        availbleTiles = null;
        infoBox i = (infoBox)UIElements.get("info");
        i.active = false;

      }
      else if(toBuildClass.equals("Gold")){
        pressedTile.building = new GoldMine(pressedTile.position, players[turn%2], pressedTile.size);
        toBuildClass = "";
        buildMode = false;
        availbleTiles = null;
        infoBox i = (infoBox)UIElements.get("info");
        i.active = false;
      }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //Clicked Barrack
    else if(pressedTile.building != null && pressedTile.building instanceof Barrack &&  pressedTile.building.owner == players[turn%2]){
      
      for(Tile t : gameBoard.range(pressedTile,1)){
        t.colour = t.highlight;
      }
      
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
        infoBox i = (infoBox)UIElements.get("info");
        i.active = false;
      }
      else if(unitToSpawn.equals("Archer")){
        pressedTile.unit = new Archer(selectedBuilding.owner);
        selectedBuilding = null; //Reset selection
        unitToSpawn = "";
        availbleTiles = null;
        infoBox i = (infoBox)UIElements.get("info");
        i.active = false;
      }
      else if(unitToSpawn.equals("Builder")){
        pressedTile.unit = new Builder(selectedBuilding.owner);
        selectedBuilding = null; //Reset selection
        unitToSpawn = "";
        availbleTiles = null;
        infoBox i = (infoBox)UIElements.get("info");
        i.active = false;
      }
    }
    
    else if(pressedTile.unit != null && pressedTile.unit.owner == players[turn%2]){
      println("Clicked Unit");
      Unit unit = pressedTile.unit;
      
      for(Tile t : gameBoard.range(pressedTile, unit.mov)){
        t.colour = t.highlight;
      }

    }
    
    //Check clicked swordsman
    else if(pressedTile.unit != null  && pressedTile.unit instanceof Swordsman){
      println("Clicked Swordsman");

    }
    
    else{
      println("Clicked other");
    }
    
    
    //if previously selected tile has unit belonging to current player
    if(selectedTile != null && selectedTile.unit != null && selectedTile.unit.owner == players[turn%2]) {
      
      //if new tile has no buildings/units and is within that unit's mov range
      if(pressedTile.unit == null && pressedTile.building == null && gameBoard.range(selectedTile, selectedTile.unit.mov).contains(pressedTile)) {
        pressedTile.unit = selectedTile.unit;
        selectedTile.unit = null;
        
        // below line: maybe we should have tiles have attributes for where they are in the array? just to make it easier for things like this
        //println("Moved " + pressedTile.unit.unitType + " from (" + selectedTile.x + ", " + selectedTile.y + ") to (" + pressedTile.x + ", " + pressedTile.y + ")");
        println("Moved " + pressedTile.unit.unitType);
      }
      else {
        println("Out of range");
      }
      
      //if new tile has a unit belonging to other player, and is within unit's attack range
      if(pressedTile.unit != null && pressedTile.unit.owner != players[turn%2] && gameBoard.range(selectedTile, selectedTile.unit.atkRange).contains(pressedTile)) {
        Unit attacker = selectedTile.unit;
        Unit target = pressedTile.unit;
        
        //damage target unit. if fallen, remove from board
        if(target.damage(attacker.strength)) {
          pressedTile.unit = null;
          println(attacker.unitType + " attacked " + target.unitType + ". " + target.unitType + " has fallen.");
        }
        else {
          println(attacker.unitType + " attacked " + target.unitType + ". " + target.unitType + " has " + target.hp + " hp.");
        }
      }
    }
    
    
    selectedTile = pressedTile;
    
  }else{
    //else inside ui elements
    for(UIElement e : UIElements.values()){
      //check inside region
      if(mouseX > e.x && mouseX < e.x + e.width && mouseY > e.y && mouseY < e.y + e.height){
        e.onClickAction();
        break;
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
    else if (key == '3') {
      println("ToSpawn: Builder");
      unitToSpawn = "Builder";
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
