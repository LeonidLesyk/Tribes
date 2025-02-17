import java.util.*;

int tileZoneLeft;
int tileZoneRight;

int screen_width;
int screen_height;

static Board gameBoard;
int tileSizePixels;
int turn;
HashMap<String, UIElement> UIElements;
ArrayList<Projectile> Projectiles;

boolean gameEnd=false;
boolean transition = false;
boolean startMenu = true; 

int gameSize;
boolean fowSetting;
PImage startBackground;

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
final int libraryCost  = 15;
final int wallCost     = 10;
final int goldMineCost = 20;

final int swordCost = 7;
final int archerCost = 8;
final int builderCost = 5;
final int wizardCost = 15;
final int giantCost = 25;
final int cavalierCost = 20;
final int trebuchetCost = 20;
final int dragonCost = 25;


int barracksBuildTime = 3;
int mineBuildTime = 3;
int libraryBuildTime = 3;
int wallBuildTime = 2;


final int dwarvesBonusHP = 5;
final int sorcererBonusHP = 1;
final int sorcererBonusArcane = 2;

final int buildingSightRange = 2;

SpriteLoader loader;
PGraphics pg;

void settings() {
  pixelDensity(displayDensity());
  /*
  if (displayDensity() == 1) {
    size(1920, 1080);
  } else {
    size(1500, 800);
  }
  */
  fullScreen();
}

void setup(){
  screen_width = width;
  screen_height = height;
  startMenu = true; 
  //default game settings
  gameSize = 10;
  fowSetting = true;
  

  
  startBackground= loadImage("resources/title.png");
  startBackground.resize(screen_width,screen_height);
  
  pg = createGraphics(screen_width, screen_height);
  
  pg.beginDraw();
  pg.image(startBackground, 0, 0);
  pg.endDraw();
  
  //println("screen: " + width + ", " + height);
  //println("image: " + startBackground.width + ", " + startBackground.height);
  
  //add UI Elements
  UIElements  = new HashMap<String, UIElement>();
  UIElement sizeSelect = new sizeSelector(screen_width*2/5, screen_height*45/100, screen_width/5, screen_height/10); 
  UIElements.put("sizeSelect",sizeSelect);
  UIElement fowSelect = new fowSelector(screen_width*2/5, screen_height*57/100, screen_width/5, screen_height/10); 
  UIElements.put("fowSelect",fowSelect);
  UIElement start = new gameStart(screen_width*2/5, screen_height*69/100, screen_width/5, screen_height/10); 
  UIElements.put("start",start);
  
  tileSizePixels = 160;
  Projectiles = new ArrayList<Projectile>();
  
  loader = new SpriteLoader();


}

void GameSetup() {
  startMenu = false;
  screen_width = width;
  screen_height = height;

  tileZoneLeft = (screen_width-screen_height)/2;
  tileZoneRight = tileZoneLeft + screen_height;


  //initialise game variables
  turn = 0;
  
  tileSizePixels = screen_height/gameSize;
  players = new Player[2];

  gameEnd = false;

  player1 = new Player(1, color(255, 0, 0));
  player2 = new Player(2, color(0, 0, 255));
  players[0] = player1;
  players[1] = player2;


  gameBoard = new Board(gameSize);

  gameBoard.grid[gameSize-2][1].building = new Base(gameBoard.grid[gameSize-2][1].position, player1, gameBoard.grid[gameSize-2][1].size);
  gameBoard.grid[1][gameSize-2].building = new Base(gameBoard.grid[1][gameSize-2].position, player2, gameBoard.grid[1][gameSize-2].size);

  

  //add UI Elements
  UIElements = new HashMap<String, UIElement>();
  UIElement endTurn = new endTurnButton(0, 0, tileZoneLeft, screen_height/10);
  UIElements.put("endTurn", endTurn);
  UIElement gold = new goldDisplay(tileZoneRight, 0, (tileZoneLeft)/2, screen_height/10);
  UIElements.put("gold", gold);
  UIElement research = new researchDisplay(tileZoneRight + (tileZoneLeft)/2, 0, (tileZoneLeft)/2, screen_height/10);
  UIElements.put("research", research);
  UIElement info = new infoBox(0, screen_height*7/10, tileZoneLeft, screen_height/5, "default text");
  UIElements.put("info", info);
  UIElement buy = new researchBuyButton(0, screen_height*9/10, tileZoneLeft, screen_height/10);
  UIElements.put("buy", buy);
  UIElement tribesmanLabel = new treeLabel(tileZoneRight, screen_height*9/10, tileZoneLeft/3, screen_height/10, "Chivalry");
  UIElements.put("Tribesmen", tribesmanLabel);
  UIElement dwarfLabel = new treeLabel(tileZoneRight + tileZoneLeft/3, screen_height*9/10, tileZoneLeft/3, screen_height/10, "Dwarves");
  UIElements.put("Dwarves", dwarfLabel);
  UIElement sorcererLabel = new treeLabel(tileZoneRight + tileZoneLeft*2/3, screen_height*9/10, tileZoneLeft/3, screen_height/10, "Sorcery");
  UIElements.put("Sorcery", sorcererLabel);

  //unit buy UIElements
  UIElement bdBuy = new builderBuyButton(0, screen_height/10, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("bdBuy", bdBuy);
  UIElement swBuy = new swordsmanBuyButton(tileZoneLeft/6, screen_height/10, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("swBuy", swBuy);
  UIElement arBuy = new archerBuyButton(tileZoneLeft*2/6, screen_height/10, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("arBuy", arBuy);
  UIElement cvBuy = new cavalierBuyButton(tileZoneLeft*3/6, screen_height/10, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("cvBuy", cvBuy);
  UIElement  giBuy = new giantBuyButton(tileZoneLeft*4/6, screen_height/10, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("giBuy", giBuy);
  UIElement  wzBuy = new wizardBuyButton(tileZoneLeft*5/6, screen_height/10, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("wzBuy", wzBuy);
  UIElement  trBuy = new trebuchetBuyButton(0, screen_height/10 + tileZoneLeft/6, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("trBuy", trBuy);
  UIElement  drBuy = new dragonBuyButton(tileZoneLeft/6, screen_height/10 + tileZoneLeft/6, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("drBuy", drBuy);

  //bulding buy UIElements
  UIElement mineBuy = new mineBuyButton(0, screen_height/10 + tileZoneLeft*2/6, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("mineBuy", mineBuy);
  UIElement barracksBuy = new barracksBuyButton(tileZoneLeft/6, screen_height/10 + tileZoneLeft*2/6, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("barracksBuy", barracksBuy);
  UIElement libraryBuy = new libraryBuyButton(tileZoneLeft*2/6, screen_height/10 + tileZoneLeft*2/6, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("libraryBuy", libraryBuy);
  UIElement wallBuy = new wallBuyButton(tileZoneLeft*3/6, screen_height/10 + tileZoneLeft*2/6, tileZoneLeft/6, tileZoneLeft/6);
  UIElements.put("wallBuy", wallBuy);

  Projectiles = new ArrayList<Projectile>();

  researchCap = 5;
  String[] tribesmenResearchDescriptions = new String[researchCap];
  String[] dwarvesResearchDescriptions = new String[researchCap];
  String[] sorcerersResearchDescriptions = new String[researchCap];
  int[] tribesmenResearchCosts = new int[researchCap];
  int[] dwarvesResearchCosts = new int[researchCap];
  int[] sorcerersResearchCosts = new int[researchCap];

  tribesmenResearchDescriptions[0] = "Archers from Neighbouring Towns have Come to your Aid!\nYou can now train Archers from barracks";
  tribesmenResearchDescriptions[1] = "The Finest Knights have Joined your Barracks!\nYou can now Train Cavaliers from Barracks";
  tribesmenResearchDescriptions[2] = "Improved Instruction Yields Results!\nAll of your Units now Have +1 Bonus ATK";
  tribesmenResearchDescriptions[3] = "Scouting nearby Caves has Led Us to some tameable Ogres\nYou can now Train Giants from Barracks";
  tribesmenResearchDescriptions[4] = "Soldiers March better on Increased Rations!\nAll of your Units now Have +1 Movement";

  dwarvesResearchDescriptions[0] = "Us Dwarves were Born with a Hammer in Our Hands\nYour Buildings now Build one Turn faster";
  dwarvesResearchDescriptions[1] = "Only the strongest Dwarvish Stone!\nYour Builders can now Build Walls to Stop the Enemy";
  dwarvesResearchDescriptions[2] = "Ancient Dwarvish Metals discovered in the mines!\n Your buildings now have " + dwarvesBonusHP + " additional hp";
  dwarvesResearchDescriptions[3] = "Use of Drills increases Mining Efficiency by 100%!\nYou now Gain +1 extra Gold from Mines";
  dwarvesResearchDescriptions[4] = "Advances in Mathematics and Engineering have Led to this Marvel...\n You can now train catapults from barracks";

  sorcerersResearchDescriptions[0] = "It's best to Study up Before Heading out to War\nYour Builders Can now Build libraries";
  sorcerersResearchDescriptions[1] = "Interesting Incantations...\nYou Can now Train Wizards from your Libraries";
  sorcerersResearchDescriptions[2] = "Enchanted Embroidery and Imbued Armour...\nAll Your Units now have " + sorcererBonusHP + " Bonus HP";
  sorcerersResearchDescriptions[3] = "Reticent Rituals lead to Pacts with Antediluvian Beasts...\nYou can now Train Dragons from your Libraries";
  sorcerersResearchDescriptions[4] = "Mastery of the Arcane! \nWizards now Have +2 ATK";

  tribesmenResearchCosts[0] = 5;
  tribesmenResearchCosts[1] = 7;
  tribesmenResearchCosts[2] = 9;
  tribesmenResearchCosts[3] = 11;
  tribesmenResearchCosts[4] = 13;

  dwarvesResearchCosts[0] = 5;
  dwarvesResearchCosts[1] = 7;
  dwarvesResearchCosts[2] = 9;
  dwarvesResearchCosts[3] = 11;
  dwarvesResearchCosts[4] = 13;

  sorcerersResearchCosts[0] = 5;
  sorcerersResearchCosts[1] = 7;
  sorcerersResearchCosts[2] = 9;
  sorcerersResearchCosts[3] = 11;
  sorcerersResearchCosts[4] = 13;

  for (int i = 0; i<researchCap; i++) {
    UIElement t = new researchBuyBox(tileZoneRight, screen_height*9/10 - screen_height*(i+1)/12, screen_height/12, screen_height/12, tribesmenResearchDescriptions[i], tribesmenResearchCosts[i], i+1, "t");
    UIElements.put("t"+str(i), t);
    UIElement d = new researchBuyBox(tileZoneRight + tileZoneLeft/3, screen_height*9/10 - screen_height*(i+1)/12, screen_height/12, screen_height/12, dwarvesResearchDescriptions[i], dwarvesResearchCosts[i], i+1, "d");
    UIElements.put("d"+str(i), d);
    UIElement s = new researchBuyBox(tileZoneRight+ tileZoneLeft*2/3, screen_height*9/10 - screen_height*(i+1)/12, screen_height/12, screen_height/12, sorcerersResearchDescriptions[i], sorcerersResearchCosts[i], i+1, "s");
    UIElements.put("s"+str(i), s);
  }
  reCalculateFog();
}

void draw() {
  if(startMenu){
    /*
    println("screen: " + screen_width + ", " + screen_height);
    println("image: " + startBackground.width + ", " + startBackground.height);
    background(startBackground);
    */
    imageMode(CORNER);
    image(pg,0,0);
    //draw UI Elements
    println(frameRate);
    for (UIElement e : UIElements.values()) {
      //println("some");
      e.draw();
    }
    renderProjectiles();
  }
  else if (gameEnd) {//Game end scene
    background(0); // Dark background for the game over screen
    fill(255, 0, 0); // Set text color to red
    textSize(64); // Increase text size for impact
    textAlign(CENTER, CENTER); // Center the text horizontally and vertically
    text("GAME OVER", screen_width / 2, screen_height / 2); // Display "GAME OVER" at the center of the screen
  } else if (transition) {
    //transition scene
    background(0); // Dark background for the game over screen
    fill(players[turn].teamColour); // Set text color to red
    textSize(64); // Increase text size for impact
    textAlign(CENTER, CENTER); // Center the text horizontally and vertically
    text("Player" + (turn+1), screen_width / 2, screen_height / 2); // Display "GAME OVER" at the center of the screen
  } else {
    background(0);
    //println(frameRate);
    gameBoard.draw();
    //draw UI Elements
    for (UIElement e : UIElements.values()) {
      e.draw();
    }
    renderProjectiles();
  }
}

void mouseReleased() {
  if (gameEnd) {
    setup();
    gameEnd = false;
  } else if (transition) {
    transition = false;
  }else if(startMenu){
    for (UIElement e : UIElements.values()) {
        //check inside region
        if (mouseX > e.x && mouseX < e.x + e.width && mouseY > e.y && mouseY < e.y + e.height) {
          e.onClickAction();
          break;
        }
      }
  }


  else if (mouseButton == LEFT) {
    println("normal");
    //if in tile zone
    if (mouseX > tileZoneLeft && mouseX < tileZoneRight) {
      int x = (mouseX - tileZoneLeft)/tileSizePixels;
      int y = mouseY/tileSizePixels;
      if(x>gameSize-1){
        x = gameSize-1;
      }
      if(y>gameSize-1){
        y = gameSize-1;
      }
      pressedTile = gameBoard.grid[x][y];

      //clear highlight on previous tile
      if (selectedTile != null) {
        for (Tile t : gameBoard.range(selectedTile, 4)) {
          t.colour = t.defaultColour;
        }
        selectedTile.colour = selectedTile.defaultColour;
        println("setting 4 range tiles to default");
      }


      /*
      //tile interaction goes here
       for(Tile t : gameBoard.range(pressedTile,2)){
       t.colour = t.highlight;
       }
       */

      pressedTile.colour = pressedTile.highlight;

      //Clicked Base make builders
      if (pressedTile.building != null && pressedTile.building instanceof Base &&  pressedTile.building.owner == players[turn]) {

        buildMode = false;


        for (Tile t : gameBoard.range(pressedTile, 1)) {
          t.colour = t.highlight;
        }

        availbleTiles = gameBoard.range(pressedTile, 1);

        selectedBuilding = pressedTile.building;
        println("Base selected");
      }

      //If clicked on builder
      else if (pressedTile.building == null && pressedTile.unit != null && pressedTile.unit instanceof Builder && pressedTile.unit.owner == players[turn] && pressedTile.unit.canAttack) {
        unitToSpawn = "";
        selectedBuilding = null;
        availbleTiles = gameBoard.range(pressedTile, pressedTile.unit.atkRange);
        buildMode = true;
        selectedBuilding = null; //Reset any unit selection
        unitToSpawn = "";

        for (Tile t : gameBoard.range(pressedTile, 1)) {
          t.colour = t.highlight;
        }
      }

      //Building logic
      else if (pressedTile.building == null && pressedTile.unit == null && !toBuildClass.equals("") && buildMode==true && availbleTiles.contains(pressedTile) && selectedTile.unit!=null) {
        if (toBuildClass.equals("Barrack")) {
          if (players[turn].hasEnoughGold(barrackCost)) {
            players[turn].spendGold(barrackCost);
            pressedTile.building = new Barrack(pressedTile.position, players[turn], pressedTile.size);
            resetBuildSelection();
            selectedTile.unit.canAttack = false;
            selectedTile.unit.canMove = false;
            
          }
        } else if (toBuildClass.equals("Library")) {
          if (players[turn].hasEnoughGold(libraryCost)) {
            players[turn].spendGold(libraryCost);
            pressedTile.building = new Library(pressedTile.position, players[turn], pressedTile.size);
            resetBuildSelection();
            selectedTile.unit.canAttack = false;
            selectedTile.unit.canMove = false;
          }
        } else if (toBuildClass.equals("Gold")) {
          if (players[turn].hasEnoughGold(goldMineCost)) {
            players[turn].spendGold(goldMineCost);
            pressedTile.building = new GoldMine(pressedTile.position, players[turn], pressedTile.size);
            resetBuildSelection();
            selectedTile.unit.canAttack = false;
            selectedTile.unit.canMove = false;
          }
        } else if (toBuildClass.equals("Wall")) {
          if (players[turn].hasEnoughGold(wallCost)) {
            players[turn].spendGold(wallCost);
            pressedTile.building = new Wall(pressedTile.position, players[turn], pressedTile.size);
            resetBuildSelection();
            selectedTile.unit.canAttack = false;
            selectedTile.unit.canMove = false;
          }
        }
      }

      //Clicked Barrack
      else if (pressedTile.building != null && pressedTile.building instanceof Barrack &&  pressedTile.building.owner == players[turn] && pressedTile.building.built) {

        buildMode = false;

        for (Tile t : gameBoard.range(pressedTile, 1)) {
          t.colour = t.highlight;
        }

        availbleTiles = gameBoard.range(pressedTile, 1);

        selectedBuilding = pressedTile.building;
        println("Barrack selected");
      }

      //Clicked library for wizard spawning
      else if (pressedTile.building != null && pressedTile.building instanceof Library &&  pressedTile.building.owner == players[turn]) {

        buildMode = false;

        for (Tile t : gameBoard.range(pressedTile, 1)) {
          t.colour = t.highlight;
        }

        availbleTiles = gameBoard.range(pressedTile, 1);

        selectedBuilding = pressedTile.building;
        println("Library selected");
      }

      //Clicked an empty tile to spawn a unit after clicking Barrack
      else if (pressedTile.building == null && pressedTile.unit == null && availbleTiles != null && availbleTiles.contains(pressedTile) && selectedBuilding != null && selectedBuilding instanceof Barrack && !unitToSpawn.equals("")) {

        println("Spawn " + unitToSpawn);
        if (unitToSpawn.equals("Swordsman")) {
          if (players[turn].hasEnoughGold(swordCost)) {
            players[turn].spendGold(swordCost);
            pressedTile.unit = new Swordsman(selectedBuilding.owner);
            resetSelection();
            reCalculateFog();
          }
        } else if (unitToSpawn.equals("Archer")) {
          if (players[turn].hasEnoughGold(archerCost)) {
            players[turn].spendGold(archerCost);
            pressedTile.unit = new Archer(selectedBuilding.owner);
            resetSelection();
            reCalculateFog();
          }
        } else if (unitToSpawn.equals("Builder")) {
          if (players[turn].hasEnoughGold(builderCost)) {
            players[turn].spendGold(builderCost);
            pressedTile.unit = new Builder(selectedBuilding.owner);
            resetSelection();
            reCalculateFog();
          }
        } else if (unitToSpawn.equals("Cavalier")) {
          if (players[turn].hasEnoughGold(cavalierCost)) {
            players[turn].spendGold(cavalierCost);
            pressedTile.unit = new Cavalier(selectedBuilding.owner);
            resetSelection();
            reCalculateFog();
          }
        } else if (unitToSpawn.equals("Giant")) {
          if (players[turn].hasEnoughGold(giantCost)) {
            players[turn].spendGold(giantCost);
            pressedTile.unit = new Giant(selectedBuilding.owner);
            resetSelection();
            reCalculateFog();
          }
        } else if (unitToSpawn.equals("Catapult")) {
          if (players[turn].hasEnoughGold(trebuchetCost)) {
            players[turn].spendGold(trebuchetCost);
            pressedTile.unit = new Trebuchet(selectedBuilding.owner);
            resetSelection();
            reCalculateFog();
          }
        }
      } else if (pressedTile.unit != null && pressedTile.unit.owner == players[turn]) {
        println("Clicked Unit");
        Unit unit = pressedTile.unit;
        if (unit.canAttack) {
          for (Tile t : gameBoard.range(pressedTile, unit.atkRange)) {
            t.colour = t.atkHighlight;
          }
          if (unit.canMove) {
            int tempRange = unit.mov;
            if (pressedTile.terrain instanceof Forest) {
              tempRange = Math.max(1, tempRange-1);
              println("tempRange: " + tempRange);
            }

            for (Tile t : gameBoard.range(pressedTile, tempRange)) {
              if (t.unit!=null && t.unit.owner!=players[turn]) {
              } else {
                t.colour = t.highlight;
              }
            }
          }
        }
      }
      //spawn wizard from library
      else if (pressedTile.building == null && pressedTile.unit == null && availbleTiles != null && availbleTiles.contains(pressedTile) && selectedBuilding != null && selectedBuilding instanceof Library && !unitToSpawn.equals("")) {
        println("Spawn " + unitToSpawn);
        if (unitToSpawn.equals("Wizard")) {
          if (players[turn].hasEnoughGold(wizardCost)) {
            players[turn].spendGold(wizardCost);
            pressedTile.unit = new Wizard(selectedBuilding.owner);
            resetSelection();
            reCalculateFog();
          }
        }
        if (unitToSpawn.equals("Dragon")) {
          if (players[turn].hasEnoughGold(dragonCost)) {
            println("enough gold spawning dragon");
            players[turn].spendGold(dragonCost);
            pressedTile.unit = new Dragon(selectedBuilding.owner);
            resetSelection();
            reCalculateFog();
          }
        }
      } else if (pressedTile.building == null && pressedTile.unit == null && availbleTiles != null && availbleTiles.contains(pressedTile) && selectedBuilding != null && selectedBuilding instanceof Base && !unitToSpawn.equals("")) {
        println("Spawn " + unitToSpawn);
        if (unitToSpawn.equals("Builder")) {
          if (players[turn].hasEnoughGold(builderCost)) {
            players[turn].spendGold(builderCost);
            pressedTile.unit = new Builder(selectedBuilding.owner);
            resetSelection();
            reCalculateFog();
          }
        }
      }


      if (pressedTile.unit != null) {
        infoBox i = (infoBox)UIElements.get("info");
        i.infoText = pressedTile.unit.makeInfoText();
        i.active = true;
      }

      if (pressedTile.building != null) {
        infoBox i = (infoBox)UIElements.get("info");
        i.infoText = pressedTile.building.makeInfoText();
        i.active = true;
      }


      //if previously selected tile has unit belonging to current player
      if (selectedTile != null && selectedTile.unit != null && selectedTile.unit.owner == players[turn]) {

        int tempRange = selectedTile.unit.mov;
        if (selectedTile.terrain instanceof Forest) {
          tempRange = Math.max(1, tempRange-1);
          ;
          println("tempRange: " + tempRange);
        }


        //if new tile has no buildings/units and is within that unit's mov range
        if (pressedTile.unit == null && selectedTile.unit.canMove && pressedTile.building == null && gameBoard.range(selectedTile, tempRange).contains(pressedTile)) {
          pressedTile.unit = selectedTile.unit;
          selectedTile.unit = null;

          // below line: maybe we should have tiles have attributes for where they are in the array? just to make it easier for things like this
          //println("Moved " + pressedTile.unit.unitType + " from (" + selectedTile.x + ", " + selectedTile.y + ") to (" + pressedTile.x + ", " + pressedTile.y + ")");
          println("Moved " + pressedTile.unit.unitType);
          pressedTile.unit.canMove = false;
          //disable move attack on Giant and Trebuchet
          if (pressedTile.unit instanceof Trebuchet||pressedTile.unit instanceof Giant) {
            pressedTile.unit.canAttack = false;
          }
          reCalculateFog();
        }

        //if new tile has a unit belonging to other player, and is within unit's attack range
        else if (pressedTile.unit != null && selectedTile.unit.canAttack && pressedTile.unit.owner != players[turn] && gameBoard.range(selectedTile, selectedTile.unit.atkRange).contains(pressedTile)) {
          Unit attacker = selectedTile.unit;
          Unit target = pressedTile.unit;

          int damageToApply = attacker.strength;
          println("Damage1: " + damageToApply);

          //reduced damage if target unt is in torest
          if(pressedTile.terrain instanceof Forest){
            damageToApply = Math.max(1, damageToApply-1);
          }
          
          if (selectedTile.terrain instanceof Mountain){
            damageToApply += 1;
          }

          println("Damage to apply: " + damageToApply);

          

          //damage target unit. if fallen, remove from board
          if (target.damage(damageToApply)) {
            pressedTile.unit = null;
            reCalculateFog();
            println(attacker.unitType + " attacked " + target.unitType + ". " + target.unitType + " has fallen.");
          } else {
            println(attacker.unitType + " attacked " + target.unitType + ". " + target.unitType + " has " + target.hp + " hp.");
          }

          //show projectile
          PVector origin = new PVector(selectedTile.position.x + selectedTile.size/2,selectedTile.position.y + selectedTile.size/2);
          PVector destination = new PVector(pressedTile.position.x + pressedTile.size/2,pressedTile.position.y + pressedTile.size/2);
          Projectile p;
          switch(selectedTile.unit.unitType){
            case "Archer":
              p = new Projectile(origin,destination,loader.arrow,15);
              Projectiles.add(p);
              break;
            case "Wizard":
              p = new Projectile(origin,destination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2,15);
              Projectiles.add(p);
              break;
            case "Dragon":
              p = new Projectile(origin,destination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2,20);
              Projectiles.add(p);
              break;
            case "Catapult":
              p = new Projectile(origin,destination,loader.rock,50);
              Projectiles.add(p);
              break;
          }
          
          
          
          //dragon splash implementation
          if (attacker instanceof Dragon) {
            if(pressedTile.up!=null){
              PVector uporigin = new PVector(pressedTile.position.x + pressedTile.size/2,pressedTile.position.y + pressedTile.size/2);
              PVector updestination = new PVector(pressedTile.up.position.x + pressedTile.up.size/2,pressedTile.up.position.y + pressedTile.up.size/2);
              Projectile pup = new Projectile(uporigin,updestination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2, 15);
              Projectiles.add(pup);
              
              pressedTile.up.hit(attacker.strength);
            }
            if(pressedTile.down!=null){
              PVector downorigin = new PVector(pressedTile.position.x + pressedTile.size/2,pressedTile.position.y + pressedTile.size/2);
              PVector downdestination = new PVector(pressedTile.down.position.x + pressedTile.down.size/2,pressedTile.down.position.y + pressedTile.down.size/2);
              Projectile pdown = new Projectile(downorigin,downdestination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2,15);
              Projectiles.add(pdown);
              
              pressedTile.down.hit(attacker.strength);
            }
            if(pressedTile.left!=null){
              PVector leftorigin = new PVector(pressedTile.position.x + pressedTile.size/2,pressedTile.position.y + pressedTile.size/2);
              PVector leftdestination = new PVector(pressedTile.left.position.x + pressedTile.left.size/2,pressedTile.left.position.y + pressedTile.left.size/2);
              Projectile pleft = new Projectile(leftorigin,leftdestination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2,15);
              Projectiles.add(pleft);
              
              pressedTile.left.hit(attacker.strength);
            }
            if(pressedTile.right!=null){
              PVector rightorigin = new PVector(pressedTile.position.x + pressedTile.size/2,pressedTile.position.y + pressedTile.size/2);
              PVector rightdestination = new PVector(pressedTile.right.position.x + pressedTile.right.size/2,pressedTile.right.position.y + pressedTile.right.size/2);
              Projectile pright = new Projectile(rightorigin,rightdestination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2,15);
              Projectiles.add(pright);
              
              pressedTile.right.hit(attacker.strength);
            }
            

          }
          attacker.canMove = false;
          attacker.canAttack = false;
          infoBox i = (infoBox)UIElements.get("info");
          i.infoText = target.makeInfoText();
          i.active = true;
        }

        //if new tile has a building belonging to other player, and is within unit's attack range
        else if (pressedTile.unit == null && selectedTile.unit.canAttack && pressedTile.building != null && pressedTile.building.owner != players[turn] && gameBoard.range(selectedTile, selectedTile.unit.atkRange).contains(pressedTile)) {
          Unit attacker = selectedTile.unit;
          Building target = pressedTile.building;

          int damageToApply = attacker.strength;
          println("Damage to apply: " + damageToApply);
           
          if (selectedTile.terrain instanceof Mountain){
            damageToApply += 1;
          }
          
          //damage target unit. if fallen, remove from board
          if (target.applyDamage(attacker.strength)) {
            pressedTile.building = null;
            println(attacker.unitType + " attacked " + target.getClass().getName() + " has fallen.");
          } else {
            println(attacker.unitType + " attacked " + target.getClass().getName() + " has " + target.health + " hp.");
          }
          attacker.canAttack = false;
          attacker.canMove = false;
          
          //show projectile
          PVector origin = new PVector(selectedTile.position.x + selectedTile.size/2,selectedTile.position.y + selectedTile.size/2);
          PVector destination = new PVector(pressedTile.position.x + pressedTile.size/2,pressedTile.position.y + pressedTile.size/2);
          Projectile p;
          switch(selectedTile.unit.unitType){
            case "Archer":
              p = new Projectile(origin,destination,loader.arrow, 15);
              Projectiles.add(p);
              break;
            case "Wizard":
              p = new Projectile(origin,destination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2, 20);
              Projectiles.add(p);
              break;
            case "Dragon":
              p = new Projectile(origin,destination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2, 20);
              Projectiles.add(p);
              break;
            case "Catapult":
              p = new Projectile(origin,destination,loader.rock, 50);
              Projectiles.add(p);
              break;
          }
          
          //dragon splash implementation
          if (attacker instanceof Dragon) {
            if(pressedTile.up!=null){
              PVector uporigin = new PVector(pressedTile.position.x + pressedTile.size/2,pressedTile.position.y + pressedTile.size/2);
              PVector updestination = new PVector(pressedTile.up.position.x + pressedTile.up.size/2,pressedTile.up.position.y + pressedTile.up.size/2);
              Projectile pup = new Projectile(uporigin,updestination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2, 15);
              Projectiles.add(pup);
              
              pressedTile.up.hit(attacker.strength);
            }
            if(pressedTile.down!=null){
              PVector downorigin = new PVector(pressedTile.position.x + pressedTile.size/2,pressedTile.position.y + pressedTile.size/2);
              PVector downdestination = new PVector(pressedTile.down.position.x + pressedTile.down.size/2,pressedTile.down.position.y + pressedTile.down.size/2);
              Projectile pdown = new Projectile(downorigin,downdestination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2, 15);
              Projectiles.add(pdown);
              
              pressedTile.down.hit(attacker.strength);
            }
            if(pressedTile.left!=null){
              PVector leftorigin = new PVector(pressedTile.position.x + pressedTile.size/2,pressedTile.position.y + pressedTile.size/2);
              PVector leftdestination = new PVector(pressedTile.left.position.x + pressedTile.left.size/2,pressedTile.left.position.y + pressedTile.left.size/2);
              Projectile pleft = new Projectile(leftorigin,leftdestination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2, 15);
              Projectiles.add(pleft);
              
              pressedTile.left.hit(attacker.strength);
            }
            if(pressedTile.right!=null){
              PVector rightorigin = new PVector(pressedTile.position.x + pressedTile.size/2,pressedTile.position.y + pressedTile.size/2);
              PVector rightdestination = new PVector(pressedTile.right.position.x + pressedTile.right.size/2,pressedTile.right.position.y + pressedTile.right.size/2);
              Projectile pright = new Projectile(rightorigin,rightdestination,(attacker.owner.playerNumber == 1)?loader.fireball1:loader.fireball2, 15);
              Projectiles.add(pright);
              
              pressedTile.right.hit(attacker.strength);
            }
            attacker.canMove = false;
            attacker.canAttack = false;
            infoBox i = (infoBox)UIElements.get("info");
            i.infoText = target.makeInfoText();
            i.active = true;
          }
        }
      }
    selectedTile = pressedTile;
    }

    else {
      println("UIElements");
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
    buildMode = false;
    clearBuyArea();
  }
}

//Test for spawning units
void keyPressed() {
  if (key == '1') {
    println("ToSpawn: Swordsman");
    unitToSpawn = "Swordsman";
  } else if (key == '2') {
    println("ToSpawn: Archer");
    unitToSpawn = "Archer";
  } else if (key == '3') {
    println("ToSpawn: Builder");
    unitToSpawn = "Builder";
  } else if (key == '4') {
    println("ToSpawn: Cavalier");
    unitToSpawn = "Cavalier";
  } else if (key == '5') {
    println("ToSpawn: Giant");
    unitToSpawn = "Giant";
  } else if (key == 'Q' || key == 'q') {
    toBuildClass = "Barrack";
  } else if (key == 'W' || key == 'w') {
    toBuildClass = "Library";
  } else if (key == 'E' || key == 'e') {
    toBuildClass = "Gold";
  } else if (key == 'R' || key == 'r') {
    println("TO build wall");
    toBuildClass = "Wall";
  }
  //CHEATS!!!!!!
  else if (key == 'I' || key == 'i') {
    players[turn].tribesmenLevel +=1;
  } else if (key == 'O' || key == 'o') {
    players[turn].dwarvesLevel +=1;
  } else if (key == 'P' || key == 'p') {
    players[turn].sorcerersLevel +=1;
  } else if (key == ESC) {
    println("Cancelled");
    selectedBuilding = null;
    unitToSpawn = "";
  }
}

void clearBuyArea() {
  infoBox i = (infoBox)UIElements.get("info");
  i.active = false;
  researchBuyButton r = (researchBuyButton)UIElements.get("buy");
  r.active = false;
}

void resetSelection() {
  selectedBuilding = null; //Reset selection
  unitToSpawn = "";
  availbleTiles = null;
  infoBox i = (infoBox)UIElements.get("info");
  i.active = false;
  researchBuyButton r = (researchBuyButton)UIElements.get("buy");
  r.active = false;
}

void resetBuildSelection() {
  toBuildClass = "";
  buildMode = false;
  availbleTiles = null;
  infoBox i = (infoBox)UIElements.get("info");
  i.active = false;
  researchBuyButton r = (researchBuyButton)UIElements.get("buy");
  r.active = false;
}

void reCalculateFog() {
  //hide everything
  for (Tile[] ts : gameBoard.grid) {
    for (Tile t : ts) {
      t.hidden = true&&fowSetting;
    }
  }

  for (Tile[] ts : gameBoard.grid) {
    for (Tile t : ts) {
      if (t.unit!=null && t.unit.owner.equals(players[turn])) {
        for (Tile see : gameBoard.range(t, t.unit.sightRange)) {
          see.hidden = false;
        }
        t.hidden = false;
      } else if (t.building!=null && t.building.owner.equals(players[turn])) {

        for (Tile see : gameBoard.range(t, buildingSightRange)) {
          see.hidden = false;
        }
        t.hidden = false;
      }
    }
  }
}

void renderProjectiles(){
  ArrayList<Projectile> toRemove = new ArrayList<Projectile>();
  for(Projectile p: Projectiles){
    if(p.draw()){
      toRemove.add(p);
    }
  }
  
  for(Projectile p: toRemove){
    if(p.draw()){
      Projectiles.remove(p);
    }
  }
}
