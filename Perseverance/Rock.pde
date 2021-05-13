final class Rock extends Particle {
  
  public boolean active;
  public boolean exploding;
  int imgRotation = 0; // hold current rotation value
  int radius;
  int frame = 0;
  float resize;
  
  Rock() {
    active = false;
    exploding = false;
    invMass = 1f;
    resize = random(5,11)/10;
    radius = int((rockImg[0].width/2)*resize);
  }
  
  // draw shell
  void draw() {      
    if (active) {
      // rotate image to give illusion of spinning
      imageMode(CENTER);
      translate(position.x, position.y);
      rotate(radians(imgRotation));
      image(rockImg[frame], 0, 0, rockImg[0].width*resize, rockImg[0].height*resize);
      rotate(radians(-imgRotation));
      translate(-position.x, -position.y);
      imageMode(CORNER);
      imgRotation = (imgRotation - 5) % 360;
      
      if (exploding) {
        textAlign(CENTER);
        fill(255,220,0);
        text("+1", position.x, position.y);
        textAlign(LEFT);
        frame++;
        if (frame == rockImg.length) {
          exploding = false;
          active = false;
          frame = 0;
        }
      }
    }
  }
  
  // fire rock using given params
  void fireRock(int x) {
    float xVel = random(-12, -6);
    float yVel = random(-8, -3);
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
    exploding = false;
    frame = 0;
    position = new PVector(0, 0) ;
    velocity = new PVector(0, 0) ;

  }
  
}
