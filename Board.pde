import java.util.*;
final class Tile{
  final color defaultColour = #69d242;
  final color highlight = #6181d2;  
  PVector position;
  int size;
  Tile up;
  Tile down;
  Tile left;
  Tile right;
  int colour;
  Building building;
  Unit unit;
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
    this.terrain = null;
  }
  
  void draw(){    

    if(this.terrain instanceof Mountain){
      fill(#8B97A6);
      stroke(128);
      square(position.x,position.y,size);
      fill(0);
      textSize(10);
      textAlign(LEFT);
      text(str(int(position.x)) + "," +  str(int(position.y)) +" "+ this.terrain.getClass().getSimpleName() ,position.x,position.y+20);
    }
    else if(this.terrain instanceof Forest){
      fill(#064A00);
      stroke(128);
      square(position.x,position.y,size);
      fill(0);
      textSize(10);
      textAlign(LEFT);
      text(str(int(position.x)) + "," +  str(int(position.y)) +" "+ this.terrain.getClass().getSimpleName() ,position.x,position.y+20);
    }
    else{
      fill(colour);
      stroke(128);
      square(position.x,position.y,size);
      fill(0);
      textSize(10);
      textAlign(LEFT);      
      text(str(int(position.x)) + "," +  str(int(position.y)) ,position.x,position.y+20);
    }
    
    
    
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
    
    grid[4][4].terrain = new Mountain(2);
    grid[4][5].terrain = new Mountain(2);
    grid[5][4].terrain = new Mountain(2);
    grid[5][5].terrain = new Mountain(2);
    
    Tile selectedTile;
    
    //Initiate Mountains
    for(int i=0; i<6; i++){
     selectedTile = grid[random.nextInt(size)][random.nextInt(size)];
     if (selectedTile.terrain == null){
       selectedTile.terrain = new Mountain(1);
     }
     else{
       i--;
     }
    }
    for(int i=0; i<8; i++){
     selectedTile = grid[random.nextInt(size)][random.nextInt(size)];
     if (selectedTile.terrain == null){
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
      return new HashSet<Tile>();
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
