class Building {
  int x, y; // Position on the grid
  int maxHealth;
  int health;
  String owner; //TODO change class
  boolean destroyed;

  // Constructor
  Building(int x, int y, int health, String owner) {
    this.x = x;
    this.y = y;
    this.maxHealth = this.health = health;
    this.owner = owner;
    this.destroyed = true;
  }

  //Damage to building
  void applyDamage(int damage) {
    health -= damage;
    if (health <= 0) {
      destroyed = true;
      onDestroyed();
    }
  }
  
  void fix(int health) {
    this.health += health;
    health = constrain(health, 0, maxHealth);
  }

  void onDestroyed() {
    //To something when destroyed 
  }


  void display() {
    rect(x,y,10,10); //TODO Change or Delete
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Base extends Building {
  
  Base(int x, int y, String owner) {
    super(x, y, 500, owner); 
  }
  

  void onDestroyed() {

  }
  
  @Override
  void display() {
    //TODO add display
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Barrack extends Building {
  // Constructor
  Barrack(int x, int y, String owner) {
    super(x, y, 80, owner);
  }

  
  //TODO return unit object?
  void produceUnit() {
    //new Unit{x, y} 
  }
  
  @Override
  void display() {
    //TODO add display
  }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Library extends Building {

  Library(int x, int y, String owner) {
    super(x, y, 60, owner);
  }


  int research() {
    //Logic to calculate the amount of research point given
  }


  
  @Override
  void display() {
        //TODO add display
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Wall extends Building {
  // Constructor
  Wall(int x, int y, String owner ) {
    super(x, y, 100, "Neutral");
  }


  
  @Override
  void display() {
    //TODO add display
  }
}
