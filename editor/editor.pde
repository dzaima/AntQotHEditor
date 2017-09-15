/*

o - overwrite
0 or ` - switch mode to move
1-8 - switch to color placing
+ and -, * and / - increase/decrease speed 
e - set speed to 1
q - snap to the queen
s - save as a JavaScript array
m - switch to map editing mode (0 = place/remove food)

LMB to go to/color a cell
RMB to move camera
MMB to place a worker

*/

import java.util.Map;
//int[][] surDirs = {{-1,-1}, {0,-1}, {1,-1},
//                   {-1, 0},         {1, 0},
//                   {-1, 1}, {0, 1}, {1, 1}};
int[][] allDirs = {{-1,-1}, {0,-1}, {1,-1},
                   {-1, 0}, {0, 0}, {1, 0},
                   {-1, 1}, {0, 1}, {1, 1}};
int[][] allRots = {{0,1,2,3,4,5,6,7,8},
                   {6,3,0,7,4,1,8,5,2},
                   {8,7,6,5,4,3,2,1,0},
                   {2,5,8,1,4,7,0,3,6}};
int[][] invRots = {{0,1,2,3,4,5,6,7,8},
                   {2,5,8,1,4,7,0,3,6},
                   {8,7,6,5,4,3,2,1,0},
                   {6,3,0,7,4,1,8,5,2}};
int mw = 2500,
    mh = 1000;
int moveCount = 0, stepCount = 0;
Cell[][] map = new Cell[mw][mh];
HashMap<View, Call> learned = new HashMap<View, Call>();
ArrayList<Ant> ants = new ArrayList<Ant>();
color[] colors = new color[]{#917D54, #FFFFFF, #FFFF00, #FF00FF, #00FFFF, #FF0000, #00FF00, #0000FF, #000000};
void setup() {
  size(1600, 844);
  //println(new View(new Cell[]{new Cell(1), new Cell(1), new Cell(1),
  //                            new Cell(1), new Cell(1,new Ant(1,1,5,0)), new Cell(1),
  //                            new Cell(1), new Cell(1), new Cell(1)}).equals(
  //        new View(new Cell[]{new Cell(1), new Cell(1), new Cell(1),
  //                            new Cell(1), new Cell(1,new Ant(1,1,5,0)), new Cell(1),
  //                            new Cell(1), new Cell(1), new Cell(1)})));
  setupMap();
  ants.add(new Ant(1250, 500, 5, 0));
  //learned.put(new Cell(1, 2), new Call(0, 1, 2));
  //println(learned);
  //println(((Object)new Cell(1, 2)).hashCode());
  //println(((Object)new Cell(1, 2)).equals((Object)(new Cell(1, 2))));
  //println(learned.get(new Cell(1, 2)));
  //println(learned.containsKey(new Cell(1, 2)));
}
float px = 1250.5, py = 500.5,
      zoom = 100;
int smouseX, smouseY;
int speed = 1;
boolean pmousePressed = false;

boolean addlogic = false;
boolean toQueen = false;
int addMode = 0;
boolean playing = false;

//these should be on if there's any chance that the corresponding value is of matter anywhere. //turned on ONLY when that is not used because it makes a rules hash (and usually .equals too) equalivent
final boolean globalIgnoreAnts = false;
final boolean globalIgnoreFriend = false;
final boolean globalIgnoreAntFood = false;

final boolean globalIgnoreFood = true;
final boolean globalIgnoreColor = false;

int defaultMode = 1;

boolean mapEditMode = false;
int mapEditAction = 0;

boolean forceFood = false;


void draw() {
  if (mousePressed && !pmousePressed) {
    smouseX = mouseX;
    smouseY = mouseY;
  }
  if (mousePressed && (!mapEditMode || mouseButton != LEFT)) {
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
      if ((addlogic || mapEditMode) && !placedThisFrame && cx == mmx && cy == mmy) {
        res = mget(cx, cy).pcol(xsp, ysp, true);
        if (mousePressed && (!pmousePressed || mapEditMode) && mouseButton != RIGHT) {
          if (addlogic) {
            Ant cant = ants.get(cAntId);
            int modPos = (cx - cant.x + 1) + 3 * (cy - cant.y+1);
            if (abs(cx - cant.x)<2 && abs(cy - cant.y)<2)
            for (int i = 0; i < 4; i++) {
              View toPut = new View(cant.getView(i));
              println("learned", toPut);
              learned.put(toPut, mouseButton==LEFT? new Call(allRots[i][modPos], addMode, 0) : new Call(allRots[i][modPos], 0, addMode));
            }
            addlogic = false;
          } else {
            if (addMode == 0 && mouseButton == LEFT) {
              if (mapEditAction == 0) mapEditAction = mget(cx, cy).food? 2 : 1;
              set(cx, cy, mapEditAction == 1);
            } else {
              if (mapEditAction == 0) mapEditAction = mget(cx, cy).col == 1? addMode : 1;
              set(cx, cy, mapEditAction);
            }
            placedThisFrame = true;
          }
        }
      } else res = mget(cx, cy).pcol(xsp, ysp, false);
      pixels[y*width+x] = res;
    }
  }
  if (!placedThisFrame) mapEditAction = 0;
  updatePixels();
  if (zoom > 0) {
    stroke(#FF0000);
    for (Ant a : ants) {
      fill(a.food>0? #333333 : #999999);
      ellipse((a.x - px + .5)/zoom*width+width/2, (a.y - py + .5)/zoom*width+height/2, 8, 8);
    }
  }
  pmousePressed = mousePressed;
  //println(px, py);
  //try {
  for (int i = 0; i < speed; i++) if (playing && !addlogic) fullStep();
  //} catch (Exception e) {
  //  e.printStackTrace();
  //  exit();
  //}
  if (toQueen) {
    px = ants.get(0).x+.5;
    py = ants.get(0).y+.5;
  }
  if (mapEditMode) {
    
  }
  println(learned.size(), speed, ants.get(0).y, ants.get(0).food, stepCount, moveCount, frameRate, zoom);
}
void keyPressed() {
  if (key == ' ') playing = !playing;
  if (key == 'z') {
    playing = false;
    step();
  }
  if (key == 'o') addlogic = !addlogic;
  if (key >= '0' && key <= '8') addMode = key-'0';
  if (key == '`') addMode = 0;
  if (key == '+') speed++;
  if (key == '-') speed--;
  if (key == '/') speed/= 2;
  if (key == '*') speed*= 2;
  if (key == 'e') speed = 1;
  if (key == '\'') zoom = zoom*4;
  if (key == 'q') toQueen = !toQueen;
  if (key == 'm') mapEditMode = !mapEditMode;
  if (key == 's') saveStrings("save.js",new String[]{toJS()});
}
void mouseWheel(MouseEvent event) {
  int c = event.getCount();
  float power = 0.9;
  if (c == -1) zoom*= power;
  if (c == 1) zoom/= power;
}
int cAntId = 0;
boolean continueFullStep;
void fullStep() {
  continueFullStep = true;
  do {
    step();
  } while (continueFullStep);
}
void step() {
  stepCount++;
  Ant currentAnt = ants.get(cAntId);
  try {
    currentAnt.step();
    cAntId++;
  } catch (Pause e) {
    continueFullStep = false;
  }
  if (cAntId >= ants.size()) {
    cAntId = 0;
    moveCount++;
    continueFullStep = false;
  }
}