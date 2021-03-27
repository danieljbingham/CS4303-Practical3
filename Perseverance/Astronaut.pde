class Astronaut extends Particle {

  int astroWidth;
  int astroHeight;

  boolean left;
  boolean right;
  boolean up;

  boolean rightFacing;
  boolean jetpack;
  boolean jetpackTransition;
  int frame;

  public Astronaut() {
    super(150, FLOOR_Y-49, 0, 0, 0.01f);
    astroWidth = 29;
    astroHeight = 49;
    rightFacing = true;
    jetpack = false;
    jetpackTransition = false;
    frame = 0;
  }

  /*void integrate() {
   PVector movement = new PVector(0,0);
   if (left) movement.x -= 2;
   if (right) movement.x += 2;
   if (up) movement.y -= 3;
   else movement.y += 5; 
   
   //movement.y += 6; // gravity
   //println(movement);
   position.add(movement);
   //println(position);
   
   if (position.y + astroHeight > FLOOR_Y) {
   position.y = FLOOR_Y - astroHeight;
   }
   //println(position);
   
   }*/

  void draw() {
    fill(255, 255, 255);
    //println(position);
    //rect(position.x, position.y, astroWidth, astroHeight);
    float yShift = position.y-5; // accounts for sprite variation
    
    println(position.y, "+", astroHeight, " < ", FLOOR_Y);
    if (rightFacing) {
      if ((!right && !left && !jetpack) || (!jetpack && position.y+astroHeight < FLOOR_Y)) {
        image(r1, position.x, yShift);
      } else if (!jetpack) {
        if (frame < 2) {
          image(r1, position.x, yShift);
        } else if (frame < 4) {
          image(r2, position.x, yShift);
        } else if (frame < 6) {
          image(r3, position.x, yShift);
        } else {
          image(r2, position.x, yShift);
        }
        frame = (frame + 1) % 8;
      } else {
        if (jetpackTransition) {
          image(j1r, position.x, yShift);
          jetpackTransition = false;
        } else {
          if (frame < 2) {
            image(j2r, position.x, yShift);
          } else if (frame < 4) {
            image(j3r, position.x, yShift);
          } else if (frame < 6) {
            image(j4r, position.x, yShift);
          } else {
            image(j3r, position.x, yShift);
          }
          frame = (frame + 1) % 8;
        }
      }
    } else {
      if ((!right && !left && !jetpack) || (!jetpack && position.y+astroHeight < FLOOR_Y)) {
        image(l1, position.x, yShift);
      } else if (!jetpack) {
        if (frame < 2) {
          image(l1, position.x, yShift);
        } else if (frame < 4) {
          image(l2, position.x, yShift);
        } else if (frame < 6) {
          image(l3, position.x, yShift);
        } else {
          image(l2, position.x, yShift);
        }
        frame = (frame + 1) % 8;
      } else {
        if (jetpackTransition) {
          image(j1l, position.x, yShift);
          jetpackTransition = false;
        } else {
          if (frame < 2) {
            image(j2l, position.x, yShift);
          } else if (frame < 4) {
            image(j3l, position.x, yShift);
          } else if (frame < 6) {
            image(j4l, position.x, yShift);
          } else {
            image(j3l, position.x, yShift);
          }
          frame = (frame + 1) % 8;
        }
      }
    }
  }

  void checkBounds() {
    if (position.x < 0) {
      position.x = 0;
      velocity.x = 0;
    }

    if (position.x + astroWidth > FULL_WIDTH) {
      position.x = FULL_WIDTH - astroWidth;
      velocity.x = 0;
    }

    if (position.y + astroHeight > FLOOR_Y) {
      position.y = FLOOR_Y - astroHeight;
    }
  }
}
