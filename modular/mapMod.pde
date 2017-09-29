
void set(int x, int y, int col) {
  x%= mw;
  y%= mh;
  if (x<0) x+= mw;
  if (y<0) y+= mh;
  map[x][y] = col;
}
int mget(int x, int y) {
  x%= mw;
  y%= mh;
  if (x<0) x+= mw;
  if (y<0) y+= mh;
  return map[x][y];
}


color pcol(int x, int y) {
  //mx%= mw;
  //if (mx<0) mx+= mw;
  //my%= mh;
  //if (my<0) my+= mh;
  /*if (addingMode) {
    if (Math.abs(x+.5-mx) < 0.10) return colors[addMode];
    if (Math.abs(y+.5-my) < 0.10) return colors[addMode];
    if (Math.abs(x+.5-mx) < 0.20) return colors[addMode] ^ 0x00575757;
    if (Math.abs(y+.5-my) < 0.20) return colors[addMode] ^ 0x00575757;
  }*/
  //if (ant != null) {
    //return new color[]{#7F85FF, #FF93CD, #FF9D87, #639E6E, #FF8832}[ant.type-1];
  //}
  return colors[mget(x,y)];
}