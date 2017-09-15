void setupMap() {
  for (int i = 0; i < mw; i++) {
    for (int j = 0; j < mh; j++) {
      map[i][j] = new Cell(i, j, random(100)<1? true : false);
      /*map borders
      if (i == 0) map[i][j].col = 2;
      if (j == 0) map[i][j].col = 3;
      */
    }
  }
}
void set(int x, int y, int col) {
  x%= mw;
  y%= mh;
  if (x<0) x+= mw;
  if (y<0) y+= mh;
  map[x][y].col = col;
}
void set(int x, int y, boolean food) {
  x%= mw;
  y%= mh;
  if (x<0) x+= mw;
  if (y<0) y+= mh;
  map[x][y].food = food;
}
void set(int x, int y, Cell cell) {
  x%= mw;
  y%= mh;
  if (x<0) x+= mw;
  if (y<0) y+= mh;
  map[x][y] = cell;
}
void set(int x, int y, Ant ant) {
  x%= mw;
  y%= mh;
  if (x<0) x+= mw;
  if (y<0) y+= mh;
  map[x][y].ant = ant;
}
Cell mget(int x, int y) {
  x%= mw;
  y%= mh;
  if (x<0) x+= mw;
  if (y<0) y+= mh;
  return map[x][y];
}