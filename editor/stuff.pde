class Pause extends RuntimeException { }
float distSQ(float sx, float sy, float ex, float ey) {
  return (sx-ex)*(sx-ex)+(sy-ey)*(sy-ey);
}
int nx (int x) {
  x%= mw;
  if (x<0) x+= mw;
  return x;
}
int ny (int y) {
  y%= mh;
  if (y<0) y+= mh;
  return y;
}
float nx (float x) {
  x%= mw;
  if (x<0) x+= mw;
  return x;
}
float ny (float y) {
  y%= mh;
  if (y<0) y+= mh;
  return y;
}
String toJS() {
  String res = "var guesses = [";
  for (Map.Entry<View,Call> entry : learned.entrySet()) {
    Cell[] view = entry.getKey().cells;
    Call call = entry.getValue();
    res+= "[[";
    for (Cell c : view) {
      res+= "{";
      if (!globalIgnoreColor) res+= "c:" + c.col + ",";
      if (!globalIgnoreFood) res+= "f:" + c.food + ",";
      if (!globalIgnoreAnts && c.ant!=null) {
        res+= "a:{t:" + c.ant.type;
        if (!globalIgnoreFriend) res+= ",b:" + c.ant.friend;
        if (!globalIgnoreAntFood) res+= ",f:" + c.ant.food;
        res+= "},";
      }
      res+= "},";
    }
    res+= "],{W:"+call.cell+",C:"+call.col+",T:"+call.type+"}],";
  }
  return res+"]";
}