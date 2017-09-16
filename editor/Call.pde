class Call {
  int cell, type, col;
  Call (int cell, int col, int type) {
    this.cell = cell;
    this.col = col;
    this.type = type;
  }
  String toString() {
    return "(Call c "+ cell +" t "+ type +" col"+ col +")";
  }
}