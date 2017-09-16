class Ant {
  int x, y;
  int type;
  int food;
  boolean friend = true;
  Ant (int x, int y, int type, int food) {
    this.x = x;
    this.y = y;
    this.type = type;
    this.food = food;
    moveTo(x, y);
  }
  Ant (Ant c) {
    type = c.type;
    food = c.food;
  }
  void step() {
    int rot = floor(random(4));
    Cell[] view = getView(rot);
    Call res = compute(view);
    //println(x, y, rot, res);
    int xp = x+allDirs[invRots[rot][res.cell]][0];
    int yp = y+allDirs[invRots[rot][res.cell]][1];
    if (res.col != 0) {
      if (res.type != 0) {
        /*ERR*/println("\ntype+col called "+view);print(1/0);
      } else {
        set(xp, yp, res.col);
      }
    } else {
      if (res.type != 0) {
        if (mget(xp, yp).ant!= null) {/*ERR*/println("\ntype+ant on ant placed "+view);print(1/0);}
        if (food < 1) {/*ERR*/println("\nnot enough food "+view);print(1/0);}
        Ant worker = new Ant(xp, yp, res.type, 0);
        food--;
        ants.add(worker);
        set(xp, yp, worker);
      } else {
        moveTo(xp, yp);
        if (mget(x, y).food) {
          set(x, y, false);
          if (food>0 && type!=5) {
            /*ERR*/println("\nworker wanted 2 food D:"+view);print(1/0);
          }
          food++;
        }
      }
    }
    if (type != 5 && food > 0) {
      for (Cell c : getView(0)) {
        if (c.ant != null && c.ant.type==5) {
          c.ant.food++;
          food--;
          break;
        }
      }
    } else if (type == 5) {
      for (Cell c : getView(0)) {
        if (c.ant != null && c.ant.type!=5 && c.ant.food>0) {
          c.ant.food--;
          food++;
          break;
        }
      }
    }
  }
  Cell[] getView(int rot) {
    Cell[] view = new Cell[9];
    int i = 0;
    for (int[] poss : allDirs) {
      view[allRots[rot][i]] = mget(poss[0]+x, poss[1]+y);
      i++;
    }
    //println(rot, new View(view));
    return view;
  }
  Call compute (Cell[] view) {
    //return new Call(0, new int[]{0,1,2}[floor(random(3))], 0);
    //print("computing");
    /*printArray(view);
    for (int i = 0; i < 9; i++) {
      if (view[i].food) return new Call(i, 0, 0);
    }
    for (int i : new int[]{1,3,5,7}) {
      if (view[i].col!=1) {
        if (view[4].col==1) return new Call(4, 8, 0);
        else return new Call(8-i, 0, 0);
      }
    }
    return new Call(1, 8, 0);*/
    Call c = learned.get(new View(view));
    if (c == null) {
      println("didn't find for " + new View(view)+", learned" + learned);
      addlogic = true;
      px = x+.5;
      py = y+.5;
      throw new Pause();
    } else return c;
  }
  String toString() {
    return "ant " + type;
  }
  void moveTo(int x, int y) {
    x%= mw;
    y%= mh;
    if (x<0) x+= mw;
    if (y<0) y+= mh;
    set(this.x, this.y, (Ant)null);
    this.x = x;
    this.y = y;
    set(x, y, this);
  }
  @Override
  boolean equals (Object o) {
    if (!(o instanceof Ant)) return false;
    Ant ao = (Ant)o;
    if (ao.type==type && ((type==5 && (ao.food>0) == (food>0)) || ao.food == food)) return true;
    else return false;
  }
  int idcode () {
    return type*4+(food>0||type==5? 2 : 0) + (friend? 1 : 0);
  }
}