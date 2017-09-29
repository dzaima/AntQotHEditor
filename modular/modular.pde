int mw = 4;//change these to change map side
int mh = 3;
int[][] map = new int[mw][mh];
void setup() {
  size(1600, 833);
  for (int y = 0; y < mh; y++) {
    for (int x = 0; x < mw; x++) {
      map[x][y] = 1;
    }
  }
}

color[] colors = new color[]{#917D54, #FFFFFF, #FFFF00, #FF00FF, #00FFFF, #FF0000, #00FF00, #0000FF, #000000};

float px = 1250.5, py = 500.5, 
  zoom = 100;

int smouseX, smouseY;
int addMode = 8;
int mapEditAction = 0;

boolean pmousePressed = false;
void draw() {
  if (mousePressed && !pmousePressed) {
    smouseX = mouseX;
    smouseY = mouseY;
  }
  if (mousePressed && mouseButton == RIGHT) {
    float zp = zoom*1f/width;
    px+= (pmouseX - mouseX)*zp;
    py+= (pmouseY - mouseY)*zp;
  }

  int mmx = floor((mouseX-width/2)*zoom/width + px);
  int mmy = floor((mouseY-height/2)*zoom/width*height/height + py);

  loadPixels();
  boolean placedThisFrame = false;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float xsp = (x-width/2)*zoom/width + px;
      float ysp = (y-height/2)*zoom/width*height/height + py;
      int cx = floor(xsp);
      int cy = floor(ysp);
      int res;
      if (!placedThisFrame && cx == mmx && cy == mmy) {
        res = pcol(cx, cy);//, xsp, ysp, true);
        if (mousePressed && mouseButton == LEFT) {
          if (mapEditAction == 0) mapEditAction = mget(cx, cy) == addMode? 1 : addMode;
          set(cx, cy, mapEditAction);
          placedThisFrame = true;
        }
      } else res = pcol(cx, cy);//, xsp, ysp, false);
      pixels[y*width+x] = res;
    }
  }
  if (!placedThisFrame) mapEditAction = 0;
  updatePixels();
  float cellsize = width*1f/zoom;
  float start = height/2f-(py%1)*cellsize;
  start-= cellsize*floor(start/cellsize);
  stroke(#888888);
  for (float i = floor(start); i < height; i+= cellsize) {
    line(0, round(i), width, round(i));
  }
  
  start = width/2f-(px%1)*cellsize;
  start-= cellsize*floor(start/cellsize);
  stroke(#888888);
  for (float i = floor(start); i < width; i+= cellsize) {
    line(round(i), 0, round(i), width);
  }
  //line(0, height/2, width, height/2);
  pmousePressed = mousePressed;
}

float vx (int x) {
  return (x-width/2)*zoom/width + px;
}
float vy (int y) {
  return (y-height/2)*zoom/width*height/height + py;
}

void keyPressed() {
  if (key >= '0' && key <= '8') addMode = key-'0';
}
void mouseWheel(MouseEvent event) {
  int c = event.getCount();
  float power = 0.9;
  if (c == -1) zoom*= power;
  if (c == 1) zoom/= power;
}