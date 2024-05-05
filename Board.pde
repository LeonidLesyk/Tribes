import java.util.*;
final class Tile{
  final color defaultColour = #69d242;
  final color highlight = #6181d2;
  final color atkHighlight = #EE4B2B;
  PVector position;
  int size;
  Tile up;
  Tile down;
  Tile left;
  Tile right;
  int colour;
  Building building;
  Unit unit;
  Boolean hidden;
  Terrain terrain;
  
  
  Tile(int size, PVector position, Tile up, Tile down, Tile left, Tile right){
    this.position = position;
    this.size = screen_height/size;
    this.up = up;
    this.down = down;
    this.left = left;
    this.right = right;
    this.colour = defaultColour;
    this.building = null;
    this.unit = null;
    this.hidden = true;
    this.terrain = null;
  }
  
  void draw(){    
    if(hidden){
      fill(64);
      stroke(128);
      square(position.x,position.y,size);
      fill(0);
      textAlign(CENTER,CENTER);
      textSize(40);
      text("?",position.x,position.y,size,size);
    }
    else {
      
      //fill to green
      fill(colour);
      stroke(128);
      square(position.x,position.y,size);
      fill(0);
        
      if(this.terrain instanceof Mountain){
        image(loader.mountain, position.x, position.y, size, size);
        /*
        fill(#8B97A6);
        stroke(128);
        square(position.x,position.y,size);
        fill(0);
        textSize(10);
        textAlign(LEFT);
        text(str(int(position.x)) + "," +  str(int(position.y)) +" "+ this.terrain.getClass().getSimpleName() ,position.x,position.y+20);
        */
        
      }
      else if(this.terrain instanceof Forest){
        image(loader.forest, position.x, position.y, size, size);
        /*
        fill(#064A00);
        stroke(128);
        square(position.x,position.y,size);
        fill(0);
        textSize(10);
        textAlign(LEFT);
        text(str(int(position.x)) + "," +  str(int(position.y)) +" "+ this.terrain.getClass().getSimpleName() ,position.x,position.y+20);
        */
        
      }
      /*
      else {
        //in sight range
        fill(colour);
        stroke(128);
        square(position.x,position.y,size);
        fill(0);
      }*/
      if (this.building != null && !this.building.destroyed) {
        if (this.terrain instanceof Mountain) {
          this.building.displayOnMountain();
        }
        else {
          this.building.display();
        }
      }
    else if (this.building != null && this.building.destroyed) {
        this.building = null;//Unbind building
    }
    //Display the unit
    if (this.unit != null) {
      this.unit.display(position.x, position.y, this.size);
    }
  }
  }
  void hit(int dmg){
    if(this.unit!=null){
      if(this.unit.damage(dmg)){
        this.unit = null;
      }
    }
    else if(this.building!=null){
      if(this.building.applyDamage(dmg)){
        this.building = null;
      }
        
    }
  }

}

final class Board{
  Random random = new Random();
  
  Tile[][] grid;
  int size;
  Board(int size){
    this.size = size;
    grid = new Tile[size][size];
    for(int y = 0; y < size; y+=1){
      Tile left = null;
      for(int x = 0; x < size; x+=1){
        int xpos = (screen_width-screen_height)/2 + x*(screen_height/size);
        int ypos = y*(screen_height/size);
        grid[x][y] = new Tile(size,new PVector(xpos,ypos),null,null,left,null);
        if(left!=null){
          left.right = grid[x][y];
        }
        left = grid[x][y];
      }
    }
    
    for(int x = 0; x < size; x+=1){
      Tile up = null;
      for(int y = 0; y < size; y+=1){   
        grid[x][y].up = up;
        if(up!=null){
          up.down = grid[x][y];
        }
        up = grid[x][y];   
      }
    }
    
    
    //Center Mountains
    for(int i=size/2-1; i<size/2+1; i++){
      for(int j=size/2-1; j<size/2+1; j++){
        grid[i][j].terrain = new Mountain(2);  
      }
    }
    
    
    Tile selectedTile;
    
    //Initiate Mountains
    for(int i=0; i<size/2+1; i++){
      int randomx = random.nextInt(size);
      int randomy = random.nextInt(size);
      selectedTile = grid[randomx][randomy];
      if (selectedTile.terrain == null && !isNearBase(randomx, randomy, size)){
         selectedTile.terrain = new Mountain(1);
      }
      else{
        i--;
      }
    }
    for(int i=0; i<size*0.6; i++){
     int randomx = random.nextInt(size);
     int randomy = random.nextInt(size);
     selectedTile = grid[randomx][randomy];
     if (selectedTile.terrain == null && !isNearBase(randomx, randomy, size)){
       selectedTile.terrain = new Forest();
     }
     else{
       i--;
     }
    }
    
    
    
    
    
  }
  
  
  Set<Tile> range(Tile start, int distance){
    Set<Tile> locations = new HashSet<Tile>(); 
    
    locations.add(start);
    locations.addAll(rangeRecurse(start.left,distance-1));
    locations.addAll(rangeRecurse(start.right,distance-1));
    locations.addAll(rangeRecurse(start.up,distance-1));
    locations.addAll(rangeRecurse(start.down,distance-1));
    locations.remove(start);
    return locations;
  }
  Set<Tile> rangeRecurse(Tile start, int distance){
    Set<Tile> locations = new HashSet<Tile>(); 
    //base case
    if(start == null || distance < 0){
      //return empty list
      return locations;
    }else if( (start.unit!=null && start.unit.owner!=players[turn])||(start.building!=null && start.building.owner!=players[turn])){
      locations.add(start);
      return locations;
    }
    locations.add(start);
    locations.addAll(rangeRecurse(start.left,distance-1));
    locations.addAll(rangeRecurse(start.right,distance-1));
    locations.addAll(rangeRecurse(start.up,distance-1));
    locations.addAll(rangeRecurse(start.down,distance-1));
    
    return locations;
  }
  
  boolean isNearBase(int x, int y, int size) {
    int exclusionRange = 1;
    boolean nearBase1 = (x >= size - 2 - exclusionRange && x <= size - 2 + exclusionRange) && (y >= 1 - exclusionRange && y <= 1 + exclusionRange);
    boolean nearBase2 = (x >= 1 - exclusionRange && x <= 1 + exclusionRange) && (y >= size - 2 - exclusionRange && y <= size - 2 + exclusionRange);
    return nearBase1 || nearBase2;
  }
  
  void draw(){
    for(int y = 0; y < size; y+=1){
      for(int x = 0; x < size; x+=1){
        grid[x][y].draw();
      }
    }
  }
  
}
