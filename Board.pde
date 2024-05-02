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

  }
  
  void draw(){    
    fill(colour);
    stroke(128);
    square(position.x,position.y,size);
    fill(0);
    
    
    if (this.building != null && !this.building.destroyed) {
        this.building.display();
    }
    else if (this.building != null && this.building.destroyed) {
        this.building = null;//Unbind building
    }
    //Display the unit
    if (this.unit != null) {
        this.unit.display(position.x, position.y, this.size);
    }
  }
  void hit(int dmg){
    if(this.unit!=null){
      if(this.unit.damage(dmg)){
        this.unit = null;
      }
    }else if(this.building!=null){
      if(this.building.applyDamage(dmg)){
        this.building = null;
      }
        
    }
  }
  
}

final class Board{
  
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
  void draw(){
    for(int y = 0; y < size; y+=1){
      for(int x = 0; x < size; x+=1){
        grid[x][y].draw();
      }
    }
  }
  
}
