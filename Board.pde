final class Tile{
  PVector position;
  int size;
  Tile up;
  Tile down;
  Tile left;
  Tile right;
  int colour;
  Building building;
  
  Tile(int size, PVector position, Tile up, Tile down, Tile left, Tile right){
    this.position = position;
    this.size = screen_height/size;
    this.up = up;
    this.down = down;
    this.left = left;
    this.right = right;
    this.colour = 255;
    this.building = null;
  }
  
  void draw(){
    
    fill(0,colour,0);
    stroke(128);
    square(position.x,position.y,size);
    text(str(position.x) + str(position.y),position.x,position.y);
    if(this.building !=null){
      this.building.display();
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
  
  void draw(){
    for(int y = 0; y < size; y+=1){
      for(int x = 0; x < size; x+=1){
        grid[x][y].draw();
        
      }
    }
  }
  
}
