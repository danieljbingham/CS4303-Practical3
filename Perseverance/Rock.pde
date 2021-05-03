final class Rock extends Particle {
  
  public boolean active;
  private final PImage img = loadImage("rock.png");
  int imgRotation = 0; // hold current rotation value
  
  Rock() {
    active = false;
    invMass = 1f;
  }
  
  // draw shell
  void draw() {      
    if (active) {
      // rotate image to give illusion of spinning
      imageMode(CENTER);
      translate(position.x, position.y);
      rotate(radians(imgRotation));
      image(img, 0, 0);
      rotate(radians(-imgRotation));
      translate(-position.x, -position.y);
      imageMode(CORNER);
      imgRotation = (imgRotation - 5) % 360;
    }
  }
  
  // fire rock using given params
  void fireRock(int x) {
    float xVel = random(-12, -8);
    float yVel = random(-7, -3);
    float startingY = random(height-150, height-200);
    
    position = new PVector(x, startingY) ;
    velocity = new PVector(xVel, yVel) ;
    forceAccumulator = new PVector(0, 0) ;
    active = true;
  }
  
  void integrate() {
    if (active) {
      // update position and velocity
      // If infinite mass, we don't integrate
      if (invMass <= 0f) return ;
      
      //PVector newPos = PVector.add(position, velocity);
  
      // update position
      position.add(velocity) ;
      
      // NB If you have a constant acceleration (e.g. gravity) start with
      //    that then add the accumulated force / mass to that.
      PVector resultingAcceleration = forceAccumulator.get() ;
      resultingAcceleration.mult(invMass) ;
  
      // update velocity
      velocity.add(resultingAcceleration) ;
      // apply damping - disabled when Drag force present
      velocity.mult(.998f) ;
  
      // Clear accumulator
      forceAccumulator.x = 0 ;
      forceAccumulator.y = 0 ;    
      
      if (position.y > ROVER_FLOOR_Y - 25 || position.y < FLOOR_Y + 50) {
        velocity.y = -velocity.y;
      }
    }
  }
  
  // Add a force to the accumulator
  void addForce(PVector force) {
    if (active) {
      forceAccumulator.add(force) ;
    }
  }
  
  boolean outOfScreen(float xPos) {
    return position.x < xPos;
  }
  
  void reset() {
    active = false;
    position = new PVector(0, 0) ;
    velocity = new PVector(0, 0) ;

  }
  
}