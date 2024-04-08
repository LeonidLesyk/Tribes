class Building {
  PVector position;
  int maxHealth;
  int health;
  Player owner;
  boolean destroyed;
  int size;

  // Constructor
  Building(PVector position, int health, Player owner, int size) {
    this.position = position;
    this.maxHealth = this.health = health;
    this.owner = owner;
    this.destroyed = false;
    this.size =  size;
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
  
  int turnEndAction() {
    //Logic to calculate the amount of gold given
    return 0;
  }




  void display() {
    fill(255, 0, 0);
    rect(position.x + 5, position.y + 5, size-10, size-10); //TODO Change or Delete
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Base extends Building {

  Base(PVector position, Player owner, int size) {
    super(position, 500, owner, size);
  }


  void onDestroyed() {
     //Set player lose
     println("Base Destroyed");
     //this.destroyed = true;
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

  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Barrack extends Building {
  // Constructor
  Barrack(PVector position, Player owner, int size) {
    super(position, 80, owner, size);
  }


  //TODO return unit object?
  void produceUnit() {
    
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
    text("Barrack", position.x+size/2, position.y+size/2);

  }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Library extends Building {

  Library(PVector position, Player owner, int size) {
    super(position, 60, owner, size);
  }


  int turnEndAction() {
    //Logic to calculate the amount of research point given
    return 1;
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
    text("Library", position.x+size/2, position.y+size/2);

  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class GoldMine extends Building {

  GoldMine(PVector position, Player owner, int size) {
    super(position, 100, owner, size);
  }


  int turnEndAction() {
    //Logic to calculate the amount of gold given
    return 1;
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
    text("Gold Mine", position.x+size/2, position.y+size/2);

  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Wall extends Building {
  // Constructor
  Wall(PVector position, Player owner, int size) {
    super(position, 100, owner, size);
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
    text("Wall", position.x+size/2, position.y+size/2+5);
  }
}
