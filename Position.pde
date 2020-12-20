class Position{
  final int x;
  final int y;
  
  Position(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  public int getX(){
    return this.x; 
  }
  
  public int getY(){
    return y; 
  }
  
  public boolean equals(Position pos){
    return this.x == pos.x && this.y == pos.y;
  }
  
  public boolean isNextTo(Position pos){
    return (abs(this.x - pos.x) == 1 && this.y - pos.y == 0)
            || (abs(this.y - pos.y) == 1 && this.x - pos.x == 0);
  }
  
  public final boolean canItCross(Position p1, Position p2, Position p3){
    //println("Position a check " + p1.x + ":" + p1.y + " " + p2.x + ":" + p2.y + " " + p3.x + ":" + p3.y + " ");
    if(p1.x - p2.x == 0 && p1.x - p3.x == 0){
      // Allignés sur l'axe des x 
      boolean res = this.x - p1.x == 0;
      return !res;
    } else if(p1.y - p2.y == 0 && p1.y - p3.y == 0){
     // Allignés sur l'axe des y
      boolean res = this.y - p1.y == 0;
      return !res;
    } else {
     return false; 
    }
  }
  
  public final boolean canItCross(Position p1, Position p2){
    if(p1.x - p2.x == 0){
      // Allignés sur l'axe des x 
      boolean res = this.x - p1.x == 0;
      return !res;
    } else if(p1.y - p2.y == 0){
     // Allignés sur l'axe des y 
     boolean res = this.y - p1.y == 0;
     return !res;
    } else {
     return false; 
    }
  }
}
