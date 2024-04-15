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
HashMap<String, UIElement> UIElements;

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

final int barrackCost  = 10;
final int libraryCost  = 10;
final int wallCost     = 10;
final int goldMineCost = 10;

final int swordCost = 10;
final int archerCost = 15;
final int builderCost = 5;
final int wizardCost = 15;
final int giantCost = 30;
final int cavalierCost = 20;



void settings(){
  pixelDensity(displayDensity());
  if(displayDensity() == 1) {
    size(1920,1080);
  }
  else {
    size(1500,800);
  }
  fullScreen();
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
  players = new Player[2];

  gameEnd = false;

  player1 = new Player(1, color(255, 0, 0));
  player2 = new Player(2, color(0, 0, 255));
  players[0] = player1;
  players[1] = player2;


  gameBoard = new Board(size);

  gameBoard.grid[8][1].building = new Base(gameBoard.grid[8][1].position, player1, gameBoard.grid[8][1].size);
  gameBoard.grid[1][8].building = new Base(gameBoard.grid[1][8].position, player2, gameBoard.grid[1][8].size);
  

  
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
  UIElement cvBuy = new cavalierBuyButton(tileZoneLeft*3/6,screen_height/10,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("cvBuy",cvBuy);
  UIElement  giBuy = new giantBuyButton(tileZoneLeft*4/6,screen_height/10,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("giBuy",giBuy);
  UIElement  wzBuy = new wizardBuyButton(tileZoneLeft*5/6,screen_height/10,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("wzBuy",wzBuy);
  
  //bulding buy UIElements
  UIElement mineBuy = new mineBuyButton(0,screen_height/10 + tileZoneLeft*2/6,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("mineBuy",mineBuy);
  UIElement barracksBuy = new barracksBuyButton(tileZoneLeft/6,screen_height/10 + tileZoneLeft*2/6,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("barracksBuy",barracksBuy);
  UIElement libraryBuy = new libraryBuyButton(tileZoneLeft*2/6,screen_height/10 + tileZoneLeft*2/6,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("libraryBuy",libraryBuy);
  UIElement wallBuy = new wallBuyButton(tileZoneLeft*3/6,screen_height/10 + tileZoneLeft*2/6,tileZoneLeft/6,tileZoneLeft/6);
  UIElements.put("wallBuy",wallBuy);
  
  researchCap = 4;
  String[] tribesmenResearchDescriptions = new String[researchCap];
  String[] dwarvesResearchDescriptions = new String[researchCap];
  String[] sorcerersResearchDescriptions = new String[researchCap];
  int[] tribesmenResearchCosts = new int[researchCap];
  int[] dwarvesResearchCosts = new int[researchCap];
  int[] sorcerersResearchCosts = new int[researchCap];
  
  tribesmenResearchDescriptions[0] = "You can now train Archers from barracks(implemented)";
  tribesmenResearchDescriptions[1] = "You can now train Cavaliers from barracks(implemented)";
  tribesmenResearchDescriptions[2] = "All of your units now have +1 bonus ATK(implemented)";
  tribesmenResearchDescriptions[3] = "You can now train Giants from barracks(implemented)";
  
  dwarvesResearchDescriptions[0] = "Your builders can now build Walls to stop the enemy(implemented)";
  dwarvesResearchDescriptions[1] = "Your buildings now build one turn faster(unimplemented)";
  dwarvesResearchDescriptions[2] = "Your buildings now have additional hp(unimplemented)";
  dwarvesResearchDescriptions[3] = "You now gain +1 extra gold from mines(unimplemented)";
  
  sorcerersResearchDescriptions[0] = "Your builders can now build libraries(implemented)";
  sorcerersResearchDescriptions[1] = "You can now train Wizards from your libraries(implemented)";
  sorcerersResearchDescriptions[2] = "All your units now have bonus HP(unimplemented)";
  sorcerersResearchDescriptions[3] = "You can now train Healers from your libraries(unimplemented)";
  
  tribesmenResearchCosts[0] = 5;
  tribesmenResearchCosts[1] = 7;
  tribesmenResearchCosts[2] = 9;
  tribesmenResearchCosts[3] = 11;
  dwarvesResearchCosts[0] = 5;
  dwarvesResearchCosts[1] = 7;
  dwarvesResearchCosts[2] = 9;
  dwarvesResearchCosts[3] = 11;
  sorcerersResearchCosts[0] = 5;
  sorcerersResearchCosts[1] = 7;
  sorcerersResearchCosts[2] = 9;
  sorcerersResearchCosts[3] = 11;
  
  for(int i = 0; i<researchCap; i++){
    UIElement t = new researchBuyBox(tileZoneRight,screen_height*9/10 - screen_height*(i+1)/12,screen_height/12,screen_height/12,tribesmenResearchDescriptions[i],tribesmenResearchCosts[i],i+1,"t");
    UIElements.put("t"+str(i),t);
    UIElement d = new researchBuyBox(tileZoneRight + tileZoneLeft/3,screen_height*9/10 - screen_height*(i+1)/12,screen_height/12,screen_height/12,dwarvesResearchDescriptions[i],dwarvesResearchCosts[i],i+1,"d");
    UIElements.put("d"+str(i),d);
    UIElement s = new researchBuyBox(tileZoneRight+ tileZoneLeft*2/3,screen_height*9/10 - screen_height*(i+1)/12,screen_height/12,screen_height/12,sorcerersResearchDescriptions[i],sorcerersResearchCosts[i],i+1,"s");
    UIElements.put("s"+str(i),s);
    
  }
}

void draw() {
  if (!gameEnd) {
    background(0);
    //println(frameRate);
    gameBoard.draw();
    //draw UI Elements
    for (UIElement e : UIElements.values()) {
      e.draw();
    }
  } else {
    //Game end scene
    background(0); // Dark background for the game over screen
    fill(255, 0, 0); // Set text color to red
    textSize(64); // Increase text size for impact
    textAlign(CENTER, CENTER); // Center the text horizontally and vertically
    text("GAME OVER", screen_width / 2, screen_height / 2); // Display "GAME OVER" at the center of the screen
  }
}

void mouseReleased() {
  if (gameEnd) {
    setup();
  }
  
  
  if (mouseButton == LEFT){
    //if in tile zone
    if (mouseX > tileZoneLeft && mouseX < tileZoneRight) {
      int x = (mouseX - tileZoneLeft)/tileSizePixels;
      int y = mouseY/tileSizePixels;
      pressedTile = gameBoard.grid[x][y];
      
      //clear highlight on previous tile
      if (selectedTile != null) {
        for (Tile t : gameBoard.range(selectedTile, 2)) {
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
      
      //Clicked Base make builders
      if(pressedTile.building != null && pressedTile.building instanceof Base &&  pressedTile.building.owner == players[turn]){
     
        buildMode = false;
  
        
        for(Tile t : gameBoard.range(pressedTile,1)){
          t.colour = t.highlight;
        }
        
        availbleTiles = gameBoard.range(pressedTile,1);
  
        selectedBuilding = pressedTile.building;
        println("Base selected");
        
      }
  
  
  
      //If clicked on builder
      else if(pressedTile.building == null && pressedTile.unit != null && pressedTile.unit instanceof Builder && pressedTile.unit.owner == players[turn]){
        availbleTiles = gameBoard.range(pressedTile, pressedTile.unit.atkRange);
        buildMode = true;
      }
  
      //Building logic
      else if(pressedTile.building == null && pressedTile.unit == null && !toBuildClass.equals("") && buildMode==true && availbleTiles.contains(pressedTile)){
        if(toBuildClass.equals("Barrack")){
          if(players[turn].hasEnoughGold(barrackCost)){
            players[turn].spendGold(barrackCost);
            pressedTile.building = new Barrack(pressedTile.position, players[turn], pressedTile.size);
            toBuildClass = "";
            buildMode = false;
            availbleTiles = null;
            infoBox i = (infoBox)UIElements.get("info");
            i.active = false;
          }
        }
        else if(toBuildClass.equals("Library")){
          if(players[turn].hasEnoughGold(libraryCost)){
            players[turn].spendGold(libraryCost);
            pressedTile.building = new Library(pressedTile.position, players[turn] , pressedTile.size);
            toBuildClass = "";
            buildMode = false;
            availbleTiles = null;
            infoBox i = (infoBox)UIElements.get("info");
            i.active = false;
          }
        }
        else if(toBuildClass.equals("Gold")){
          if(players[turn].hasEnoughGold(goldMineCost)){
            players[turn].spendGold(goldMineCost);
            pressedTile.building = new GoldMine(pressedTile.position, players[turn], pressedTile.size);
            toBuildClass = "";
            buildMode = false;
            availbleTiles = null;
            infoBox i = (infoBox)UIElements.get("info");
            i.active = false;
          }
        }
        
        else if(toBuildClass.equals("Wall")){
          if(players[turn].hasEnoughGold(wallCost)){
            players[turn].spendGold(wallCost);
            pressedTile.building = new Wall(pressedTile.position, players[turn], pressedTile.size);
            toBuildClass = "";
            buildMode = false;
            availbleTiles = null;
            infoBox i = (infoBox)UIElements.get("info");
            i.active = false;
          }        
        }
      }
  
      
      
      
      
      //Clicked Barrack
      else if(pressedTile.building != null && pressedTile.building instanceof Barrack &&  pressedTile.building.owner == players[turn] && pressedTile.building.built){
        
        buildMode = false;
  
        for(Tile t : gameBoard.range(pressedTile,1)){
          t.colour = t.highlight;
        }
  
        availbleTiles = gameBoard.range(pressedTile, 1);
  
        selectedBuilding = pressedTile.building;
        println("Barrack selected");
      }
      
      //Clicked library for wizard spawning
      else if(pressedTile.building != null && pressedTile.building instanceof Library &&  pressedTile.building.owner == players[turn]){
  
        buildMode = false;
  
        for(Tile t : gameBoard.range(pressedTile,1)){
          t.colour = t.highlight;
        }
        
        availbleTiles = gameBoard.range(pressedTile,1);
  
        selectedBuilding = pressedTile.building;
        println("Library selected");
      }
      
      //Clicked an empty tile to spawn a unit after clicking Barrack
      else if (pressedTile.building == null && pressedTile.unit == null && availbleTiles != null && availbleTiles.contains(pressedTile) && selectedBuilding != null && selectedBuilding instanceof Barrack && !unitToSpawn.equals("")) {
  
        println("Spawn " + unitToSpawn);
        if(unitToSpawn.equals("Swordsman")){
          if(players[turn].hasEnoughGold(swordCost)){
            players[turn].spendGold(swordCost);
            pressedTile.unit = new Swordsman(selectedBuilding.owner);
            selectedBuilding = null; //Reset selection
            unitToSpawn = "";
            availbleTiles = null;
          }
          infoBox i = (infoBox)UIElements.get("info");
          i.active = false;
        }
        else if(unitToSpawn.equals("Archer")){
          if(players[turn].hasEnoughGold(archerCost)){
            players[turn].spendGold(archerCost);
            pressedTile.unit = new Archer(selectedBuilding.owner);
            selectedBuilding = null; //Reset selection
            unitToSpawn = "";
            availbleTiles = null;
            infoBox i = (infoBox)UIElements.get("info");
            i.active = false;
          }
        }
        else if(unitToSpawn.equals("Builder")){
          if(players[turn].hasEnoughGold(builderCost)){
            players[turn].spendGold(builderCost);
            pressedTile.unit = new Builder(selectedBuilding.owner);
            selectedBuilding = null; //Reset selection
            unitToSpawn = "";
            availbleTiles = null;
            infoBox i = (infoBox)UIElements.get("info");
            i.active = false;
          }
        }
        else if(unitToSpawn.equals("Cavalier")){
          if(players[turn].hasEnoughGold(cavalierCost)){
            players[turn].spendGold(cavalierCost);
            pressedTile.unit = new Cavalier(selectedBuilding.owner);
            selectedBuilding = null; //Reset selection
            unitToSpawn = "";
            availbleTiles = null;
            infoBox i = (infoBox)UIElements.get("info");
            i.active = false;
          }
        }
        else if(unitToSpawn.equals("Giant")){
          if(players[turn].hasEnoughGold(giantCost)){
            players[turn].spendGold(giantCost);
            pressedTile.unit = new Giant(selectedBuilding.owner);
            selectedBuilding = null; //Reset selection
            unitToSpawn = "";
            availbleTiles = null;
            infoBox i = (infoBox)UIElements.get("info");
            i.active = false;
          }
        }
      }
      
      else if(pressedTile.unit != null && pressedTile.unit.owner == players[turn]){
        println("Clicked Unit");
        Unit unit = pressedTile.unit;
        
        for(Tile t : gameBoard.range(pressedTile, unit.mov)){
          t.colour = t.highlight;
        }
  
      }
      //spawn wizard from library
      else if(pressedTile.building == null && pressedTile.unit == null && availbleTiles != null && availbleTiles.contains(pressedTile) && selectedBuilding != null && selectedBuilding instanceof Library && !unitToSpawn.equals("")){
        println("Spawn " + unitToSpawn);
        if(unitToSpawn.equals("Wizard")){
          if(players[turn].hasEnoughGold(wizardCost)){
            players[turn].spendGold(wizardCost);
            pressedTile.unit = new Wizard(selectedBuilding.owner);
            selectedBuilding = null; //Reset selection
            unitToSpawn = "";
            availbleTiles = null;
            infoBox i = (infoBox)UIElements.get("info");
            i.active = false;
          }
        }
      }
      
      else if(pressedTile.building == null && pressedTile.unit == null && availbleTiles != null && availbleTiles.contains(pressedTile) && selectedBuilding != null && selectedBuilding instanceof Base && !unitToSpawn.equals("")){
        println("Spawn " + unitToSpawn);
        if(unitToSpawn.equals("Builder")){
          if(players[turn].hasEnoughGold(builderCost)){
            players[turn].spendGold(builderCost);
            pressedTile.unit = new Builder(selectedBuilding.owner);
            selectedBuilding = null; //Reset selection
            unitToSpawn = "";
            availbleTiles = null;
            infoBox i = (infoBox)UIElements.get("info");
            i.active = false;
          }
        }
      }
  
      
      if (pressedTile.unit != null) {
        infoBox i = (infoBox)UIElements.get("info");
        i.infoText = pressedTile.unit.makeInfoText();
        i.active = true;
      }
  
  
      //if previously selected tile has unit belonging to current player
      if (selectedTile != null && selectedTile.unit != null && selectedTile.unit.owner == players[turn]) {
  
        //if new tile has no buildings/units and is within that unit's mov range
        if (pressedTile.unit == null && selectedTile.unit.canMove && pressedTile.building == null && gameBoard.range(selectedTile, selectedTile.unit.mov).contains(pressedTile)) {
          pressedTile.unit = selectedTile.unit;
          selectedTile.unit = null;
  
          // below line: maybe we should have tiles have attributes for where they are in the array? just to make it easier for things like this
          //println("Moved " + pressedTile.unit.unitType + " from (" + selectedTile.x + ", " + selectedTile.y + ") to (" + pressedTile.x + ", " + pressedTile.y + ")");
          println("Moved " + pressedTile.unit.unitType);
          pressedTile.unit.canMove = false;
        } 
  
        //if new tile has a unit belonging to other player, and is within unit's attack range
        else if (pressedTile.unit != null && selectedTile.unit.canAttack && pressedTile.unit.owner != players[turn] && gameBoard.range(selectedTile, selectedTile.unit.atkRange).contains(pressedTile)) {
          Unit attacker = selectedTile.unit;
          Unit target = pressedTile.unit;
  
          //damage target unit. if fallen, remove from board
          if(target.damage(attacker.strength + (players[turn].tribesmenLevel > 2? 1:0))) {
            pressedTile.unit = null;
            println(attacker.unitType + " attacked " + target.unitType + ". " + target.unitType + " has fallen.");
          } else {
            println(attacker.unitType + " attacked " + target.unitType + ". " + target.unitType + " has " + target.hp + " hp.");
          }
          attacker.canMove = false;
          attacker.canAttack = false;
        }
        
              //if new tile has a unit belonging to other player, and is within unit's attack range
        else if(pressedTile.unit == null && selectedTile.unit.canAttack && pressedTile.building != null && pressedTile.building.owner != players[turn] && gameBoard.range(selectedTile, selectedTile.unit.atkRange).contains(pressedTile)) {
          Unit attacker = selectedTile.unit;
          Building target = pressedTile.building;
          
          //damage target unit. if fallen, remove from board
          if(target.applyDamage(attacker.strength)) {
            pressedTile.building = null;
            attacker.canAttack = false;
            attacker.canMove = false;
            println(attacker.unitType + " attacked " + target.getClass().getName() + " has fallen.");
          }
          else {
            println(attacker.unitType + " attacked " + target.getClass().getName() + " has " + target.health + " hp.");
          }
          attacker.canMove = false;
          attacker.canAttack = false;
        }
        
        
      }
  
  
      selectedTile = pressedTile;
    } else {
      //else inside ui elements
      for (UIElement e : UIElements.values()) {
        //check inside region
        if (mouseX > e.x && mouseX < e.x + e.width && mouseY > e.y && mouseY < e.y + e.height) {
          e.onClickAction();
          break;
        }
      }
    }
  }
  else if (mouseButton == RIGHT) {
    pressedTile = null;
    availbleTiles = null;
    for (int i=0; i<gameBoard.grid.length; i++) {
      for (int j=0; j<gameBoard.grid[i].length; j++) {
        gameBoard.grid[i][j].colour = gameBoard.grid[i][j].defaultColour; 
      }
    }
    selectedTile = null;
    selectedBuilding = null;
    toBuildClass = "";
    unitToSpawn = "";
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
    else if (key == '4') {
      println("ToSpawn: Cavalier");
      unitToSpawn = "Cavalier";
    }
    else if (key == '5') {
      println("ToSpawn: Giant");
      unitToSpawn = "Giant";
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
    else if (key == 'R' || key == 'r') {
      println("TO build wall");
      toBuildClass = "Wall";
    }
    //CHEATS!!!!!!
    else if (key == 'I' || key == 'i') {
      players[turn].tribesmenLevel +=1;
    }
    else if (key == 'O' || key == 'o') {
      players[turn].dwarvesLevel +=1;
    }
    else if (key == 'P' || key == 'p') {
      players[turn].sorcerersLevel +=1;
    }
    else if(key == ESC){
      println("Cancelled");
      selectedBuilding = null;
      unitToSpawn = "";
    }
}
