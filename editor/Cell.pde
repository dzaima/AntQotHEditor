class Cell {
  int x, y;
  int col = 1;
  boolean food;
  boolean foodMatters = !globalIgnoreFood;
  boolean antsMatter = !globalIgnoreAnts;
  Ant ant = null;
  /*Cell () {
    if (!(this instanceof CellIgnoreAnt)) {println("\nCELL() CONSTRUCTOR CALLED"); print(1/0);};
  }*/
  Cell (int x, int y, boolean food) {
    this.x = x;
    this.y = y;
    this.food = food;
  }
  Cell (int x, int y, Ant a) {
    this.x = x;
    this.y = y;
    this.ant = a;
  }
  Cell (int col, Ant a) {
    this.col = col;
    this.ant = a;
  }
  Cell (Cell c) {
    col = c.col;
    food = c.food;
    if (c.ant != null) ant = new Ant(c.ant);
  }
  Cell (int col) {
    this.col = col;
  }
  void set (int col) {
    this.col = col;
  }
  @Override
  boolean equals (Object o) {//println("equals ",this, o);
  //if(true)return true;
  
    if (!(o instanceof Cell)) return false;
    if (col==((Cell)o).col && (!antsMatter || (ant==null? (((Cell)o).ant==null) : ant.equals(((Cell)o).ant))) && (!foodMatters || food==((Cell)o).food)) return true;
    else return false;
  }
  @Override
  String toString() {
    return "(Cell " + col +" x:"+ x +" y:"+ y + (ant==null? "" : " "+ ant) +")";
  }
  //@Override
  //int hashCode() {
  //  return (x*2500+y)*8+col;
  //}
  int idcode() {
    return (col*2+((food || globalIgnoreFood)?1:0)) + (globalIgnoreAnts? 0 : (ant==null? 0 : 17 + ant.idcode()));
  }
  color pcol(float mx, float my, boolean addingMode) {
    //if (savedFrame == frameCount) return saved;
    //mx%= mw;
    //if (mx<0) mx+= mw;
    //my%= mh;
    //if (my<0) my+= mh;
    if (food && distSQ(x+.5, y+.5, mx, my) < 0.1) return #555555;
    if (addingMode) {
      if (Math.abs(x+.5-mx) < 0.10) return colors[addMode];
      if (Math.abs(y+.5-my) < 0.10) return colors[addMode];
      if (Math.abs(x+.5-mx) < 0.20) return colors[addMode] ^ 0x00575757;
      if (Math.abs(y+.5-my) < 0.20) return colors[addMode] ^ 0x00575757;
    }
    //if (ant != null) {
      //return new color[]{#7F85FF, #FF93CD, #FF9D87, #639E6E, #FF8832}[ant.type-1];
    //}
    return colors[col];
  }
}
/*class CellIgnoreAnt extends Cell {
  CellIgnoreAnt (Cell c) {
    x = c.x;
    y = c.y;
  }
  @Override
  boolean equals (Object d) {
    if (!(d instanceof Cell)) return false;
    if (col==((Cell)d).col) return true;
    return true;
  }
}*/