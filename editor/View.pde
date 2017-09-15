class View {
  Cell[] cells;
  View (Cell[] inp) {
    cells = new Cell[9];
    int i = 0;
    for (Cell c : inp) {
      cells[i] = new Cell(c);
      i++;
    }
  }
  @Override
  int hashCode() {
    int res = 0;
    int i = 0;
    for (Cell c : cells) res+= c.idcode() * 100 * ++i;
    //println(this,res); new Exception().printStackTrace();
    return res;
  }
  @Override
  boolean equals (Object o) {
    if (!(o instanceof View)) return false;
    //println("comparing")
    for (int i = 0; i < 9; i++) {
      if (!((View)o).cells[i].equals(cells[i])) return false;
    }
    return true;
  }
  String toString() {
    String res = "[";
    for (Cell c : cells) res+= c;
    return res+"]";
  }
}