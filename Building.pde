class Building {
  PVector position; // Position on the grid
  int maxHealth;
  int health;
  String owner; //TODO change class
  boolean destroyed;
  int size;

  // Constructor
  Building(PVector position, int health, String owner, int size) {
    this.position = position;
    this.maxHealth = this.health = health;
    this.owner = owner;
    this.destroyed = true;
    this.size =  size;
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
    fill(255,0,0);
    rect(position.x + 5, position.y + 5, size-10, size-10); //TODO Change or Delete
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Base extends Building {
  
  Base(PVector position, int size, String owner) {
    super(position,500,owner,size); 
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
  Barrack(PVector position, int size, String owner) {
    super(position, 80, owner, size);
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

  Library(PVector position, int size, String owner) {
    super(position, 60, owner, size);
  }


  int research() {
    //Logic to calculate the amount of research point given
    return 0;
  }


  
  @Override
  void display() {
        //TODO add display
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Wall extends Building {
  // Constructor
  Wall(PVector position, int size, String owner ) {
    super(position, 100, "Neutral", size);
  }


  
  @Override
  void display() {
    //TODO add display
  }
}
