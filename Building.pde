class Building {
  PVector position;
  int maxHealth;
  int health;
  Player owner;
  boolean destroyed;
  int size;
  int cost;
  int completeBuildTurns;
  int currentBuildTurn;
  boolean built;


  // Constructor
  Building(PVector position, int health, Player owner, int size, int completeBuildTurns) {
    this.position = position;
    this.maxHealth = this.health = health;
    this.owner = owner;
    this.destroyed = false;
    this.size =  size;
    this.completeBuildTurns = completeBuildTurns;
    this.built = false;
  }

  //Damage to building
  boolean applyDamage(int damage) {
    health -= damage;
    if (health <= 0) {
      destroyed = true;
      onDestroyed();
    }
    return destroyed;
  }

  void fix(int health) {
    this.health += health;
    health = constrain(health, 0, maxHealth);
  }

  void onDestroyed() {
    //this.destroyed = true;
  }
  
  void turnEndAction() {
    //Logic to calculate the amount of gold given
  }

  String makeInfoText() {
    
    String info = "HP = " + health + "/" + maxHealth + "\n";
    
    return info;
  }


  void display() {
    fill(255, 0, 0);
    rect(position.x + 5, position.y + 5, size-10, size-10); //TODO Change or Delete
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Base extends Building {

  Base(PVector position, Player owner, int size) {
    super(position, 20, owner, size, 0);
  }


  void onDestroyed() {
     //Set player lose
     println("Base Destroyed");
     gameEnd = true;
  }

  void turnEndAction() {
    owner.gainGold(2);
    owner.gainResearch(1);
  }
  
  @Override
  void display() {
    fill(255);
    stroke(owner.teamColour);
    strokeWeight(2);
    
    ellipse(position.x+size/2, position.y+size/2, size-10, size-10);
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    text("Base", position.x+size/2, position.y+size/2);
    
    // HP Bar display
    float hpBarWidth = size;
    float hpBarHeight = size /12;
    float hpBarX = position.x;
    float hpBarY = position.y + size*0.9;
    
    noStroke();
    
    //HP Bar Background
    fill(50); // Dark gray background
    rect(hpBarX, hpBarY, hpBarWidth, hpBarHeight);
    
    float hpPercentage = (float) health / maxHealth; 
    //Current HP
    fill(255, 255, 0);
    rect(hpBarX, hpBarY, hpBarWidth * hpPercentage, hpBarHeight);
    
    //Lost HP
    fill(255, 0, 0);
    rect(hpBarX + hpBarWidth * hpPercentage, hpBarY, hpBarWidth * (1 - hpPercentage), hpBarHeight);

  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Barrack extends Building {
  // Constructor
  Barrack(PVector position, Player owner, int size) {
    super(position, 15, owner, size, barracksBuildTime);
  }

  void turnEndAction() {
    if(!built){
      currentBuildTurn += 1;
      if (currentBuildTurn == barracksBuildTime){
        built = true;
      }
    }
  }

  @Override
    void display() {   
    fill(255);
    stroke(owner.teamColour);
    strokeWeight(2);
  
    triangle(position.x+size/2, position.y+10, position.x+10, position.y+size-10, position.x+size-10, position.y+size-10);
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    if(!built){
      text("Barrack\n" + currentBuildTurn +"/"+ completeBuildTurns, position.x+size/2, position.y+size/2);
    }
    else{
      text("Barrack", position.x+size/2, position.y+size/2);
    }
    
    // HP Bar display
    float hpBarWidth = size;
    float hpBarHeight = size /12;
    float hpBarX = position.x;
    float hpBarY = position.y + size*0.9;
    
    noStroke();
    
    //HP Bar Background
    fill(50); // Dark gray background
    rect(hpBarX, hpBarY, hpBarWidth, hpBarHeight);
    
    float hpPercentage = (float) health / maxHealth; 
    //Current HP
    fill(255, 255, 0);
    rect(hpBarX, hpBarY, hpBarWidth * hpPercentage, hpBarHeight);
    
    //Lost HP
    fill(255, 0, 0);
    rect(hpBarX + hpBarWidth * hpPercentage, hpBarY, hpBarWidth * (1 - hpPercentage), hpBarHeight);

  }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Library extends Building {

  Library(PVector position, Player owner, int size) {
    super(position, 10, owner, size, libraryBuildTime);
  }


  void turnEndAction() {
    if(!built){
      currentBuildTurn += 1;
      if (currentBuildTurn == libraryBuildTime){
        built = true;
      }
    }
    else{
      owner.gainResearch(1);
    }
  }



  @Override
    void display(){
    
    fill(255);
    stroke(owner.teamColour);
    strokeWeight(2);

    rect(position.x+5, position.y+5, size-10, size-10);
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    if(!built){
      text("Library\n" + currentBuildTurn +"/"+ completeBuildTurns, position.x+size/2, position.y+size/2);
    }
    else{
      text("Library", position.x+size/2, position.y+size/2);
    }
    
    // HP Bar display
    float hpBarWidth = size;
    float hpBarHeight = size /12;
    float hpBarX = position.x;
    float hpBarY = position.y + size*0.9;
    
    noStroke();
    
    //HP Bar Background
    fill(50); // Dark gray background
    rect(hpBarX, hpBarY, hpBarWidth, hpBarHeight);
    
    float hpPercentage = (float) health / maxHealth; 
    //Current HP
    fill(255, 255, 0);
    rect(hpBarX, hpBarY, hpBarWidth * hpPercentage, hpBarHeight);
    
    //Lost HP
    fill(255, 0, 0);
    rect(hpBarX + hpBarWidth * hpPercentage, hpBarY, hpBarWidth * (1 - hpPercentage), hpBarHeight);

  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class GoldMine extends Building {

  GoldMine(PVector position, Player owner, int size) {
    super(position, 10, owner, size, mineBuildTime);
  }


  void turnEndAction() {
    if(!built){
      currentBuildTurn += 1;
      if (currentBuildTurn == mineBuildTime){
        built = true;
      }
    }
    else{
      owner.gainGold(1);
    }
  }



  @Override
    void display(){
    
    fill(255);
    stroke(owner.teamColour);
    strokeWeight(2);

    rect(position.x+5, position.y+5, size-10, size-10);
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    if(!built){
      text("Gold Mine\n" + currentBuildTurn +"/"+ completeBuildTurns, position.x+size/2, position.y+size/2);
    }
    else{
      text("GoldMine", position.x+size/2, position.y+size/2);
    }
    
    // HP Bar display
    float hpBarWidth = size;
    float hpBarHeight = size /12;
    float hpBarX = position.x;
    float hpBarY = position.y + size*0.9;
    
    noStroke();
    
    //HP Bar Background
    fill(50); // Dark gray background
    rect(hpBarX, hpBarY, hpBarWidth, hpBarHeight);
    
    float hpPercentage = (float) health / maxHealth; 
    //Current HP
    fill(255, 255, 0);
    rect(hpBarX, hpBarY, hpBarWidth * hpPercentage, hpBarHeight);
    
    //Lost HP
    fill(255, 0, 0);
    rect(hpBarX + hpBarWidth * hpPercentage, hpBarY, hpBarWidth * (1 - hpPercentage), hpBarHeight);

  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Wall extends Building {
  // Constructor
  Wall(PVector position, Player owner, int size) {
    super(position, 20, owner, size, wallBuildTime);
  }
  
  void turnEndAction() {
    if(!built){
      currentBuildTurn += 1;
      if (currentBuildTurn == wallBuildTime){
        built = true;
      }
    }
  }


  @Override
  void display() {
    fill(255);
    stroke(owner.teamColour);
    strokeWeight(2);

    rect(position.x+5, position.y+25, size-10, size-40);
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);
    if(!built){
      text("Wall\n" + currentBuildTurn +"/"+ completeBuildTurns, position.x+size/2, position.y+size/2);
    }
    else{
      text("Wall", position.x+size/2, position.y+size/2);
    }
    
    // HP Bar display
    float hpBarWidth = size;
    float hpBarHeight = size /12;
    float hpBarX = position.x;
    float hpBarY = position.y + size*0.9;
    
    noStroke();
    
    //HP Bar Background
    fill(50); // Dark gray background
    rect(hpBarX, hpBarY, hpBarWidth, hpBarHeight);
    
    float hpPercentage = (float) health / maxHealth; 
    //Current HP
    fill(255, 255, 0);
    rect(hpBarX, hpBarY, hpBarWidth * hpPercentage, hpBarHeight);
    
    //Lost HP
    fill(255, 0, 0);
    rect(hpBarX + hpBarWidth * hpPercentage, hpBarY, hpBarWidth * (1 - hpPercentage), hpBarHeight);


  }
}
