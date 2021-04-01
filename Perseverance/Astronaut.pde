class Astronaut extends Particle {

  int astroWidth;
  int astroHeight;

  boolean left;
  boolean right;
  boolean up;

  boolean rightFacing;
  boolean onPlatform;
  boolean jetpack;
  boolean jetpackTransition;
  int frame;
  int jetpackUsed;

  public Astronaut() {
    super(150, FLOOR_Y-49, 0, 0, 0.01f);
    astroWidth = 29;
    astroHeight = 49;
    rightFacing = true;
    jetpack = false;
    jetpackTransition = false;
    frame = 0;
    jetpackUsed = 0;
  }

  // update position and velocity
  void integrate() {
    // If infinite mass, we don't integrate
    if (invMass <= 0f) return ;
    
    if (jetpack) jetpackUsed++;
    
    boolean resetXVel = false;
    boolean resetYVel = false;
    
    PVector newPos = PVector.add(position, velocity);
    
    if (newPos.y > 0) {
      if (velocity.x != 0) {
        float xBound = velocity.x < 0 ? position.x : position.x + astroWidth;
        int incrementX = int(velocity.x/abs(velocity.x));
        float safeMovementX = level.isXCollision(xBound, position.y, astroHeight, incrementX);
        position.x = abs(safeMovementX) < abs(velocity.x) ? position.x + safeMovementX : position.x + velocity.x;
        
        resetXVel = safeMovementX == 0;
      }
      //if (!level.isXCollision(xBound, newPos.y, astroHeight)) {
      //  position.x += velocity.x;
      //}
      
      if (velocity.y != 0) {
        float yBound = velocity.y < 0 ? position.y : position.y + astroHeight;
        int incrementY = int(velocity.y/abs(velocity.y));
        float safeMovementY = level.isYCollision(position.x, yBound, astroWidth, incrementY);
        position.y = abs(safeMovementY) < abs(velocity.y) ? position.y + safeMovementY : position.y + velocity.y;
        
        onPlatform = safeMovementY == 0 && velocity.y > 0;
        resetYVel = safeMovementY == 0;
      }
      
      //if (!level.isYCollision(newPos.x, yBound, astroWidth)) {
      //  position.y += velocity.y;
      //}
    } else {
      position.add(velocity) ;
    }
    
    // update position
    //position.add(velocity) ;
    
    // NB If you have a constant acceleration (e.g. gravity) start with
    //    that then add the accumulated force / mass to that.
    PVector resultingAcceleration = forceAccumulator.get() ;
    resultingAcceleration.mult(invMass) ;

    // update velocity
    velocity.add(resultingAcceleration) ;
    // apply damping - disabled when Drag force present
    velocity.mult(DAMPING) ;
    
    // Clear accumulator
    forceAccumulator.x = 0 ;
    forceAccumulator.y = 0 ;  
    
    if (resetXVel) velocity.x = 0;
    if (resetYVel) velocity.y = 0;
    
  }

   
  void reset() {
    rightFacing = true;
    jetpack = false;
    jetpackTransition = false;
    frame = 0;
    jetpackUsed = 0;
    
    position = new PVector(150, FLOOR_Y-49) ;
    velocity = new PVector(0, 0) ;
  }

  void draw() {
    fill(255, 255, 255);
    //println(position);
    //rect(position.x, position.y, astroWidth, astroHeight);
    float yShift = position.y-5; // accounts for sprite variation
    
    //println(position.y, "+", astroHeight, " < ", FLOOR_Y);
    //println(right, left, jetpack, velocity);
    if (rightFacing) {
      if ((!right && !left && !jetpack) || (!jetpack && position.y+astroHeight < FLOOR_Y && !onPlatform)) {
        image(r1, position.x, yShift);
      } else if (!jetpack || onPlatform) {
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
      if ((!right && !left && !jetpack) || (!jetpack && position.y+astroHeight < FLOOR_Y && !onPlatform)) {
        image(l1, position.x, yShift);
      } else if (!jetpack || onPlatform) {
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
  
  boolean jetpackAvailable() {
    return jetpackUsed <= JETPACK_MAX;
  }
  
  
}
