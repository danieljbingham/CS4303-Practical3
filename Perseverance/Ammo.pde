final class Ammo extends Particle {
  
  public boolean active;
  
  Ammo(PVector startingPos, PVector targetPos, PVector rockVel, boolean rockActive, float accuracy) {
    active = true;
    invMass = 1f;
    
    if (!rockActive) {
      targetPos = startingPos.get().add(100, -5);
      rockVel = new PVector(0,0);
    }
    
    // fire ammo using given params
    position = new PVector(startingPos.x, startingPos.y);
    
    PVector intersection = predictAim(startingPos, targetPos, rockVel);
    intersection.add(random(-accuracy,accuracy)*intersection.x, random(-accuracy,accuracy)*intersection.y);
    intersection.normalize().mult(25);
    
    velocity = new PVector(intersection.x, intersection.y);
    forceAccumulator = new PVector(0, 0);

  }
  
  // draw shell
  void draw() {      
    if (active) {
      push();
      ellipse(position.x, position.y, 6, 6);
      fill(255);
      pop();
    }
  }
  
  void integrate() {
    if (active) {
      // update position and velocity
      // If infinite mass, we don't integrate
      if (invMass <= 0f) return ;
      
      //PVector newPos = PVector.add(position, velocity);
  
      // update position
      position.add(velocity) ;
            
      if (position.y > ROVER_FLOOR_Y || position.y < FLOOR_Y + 50) {
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
  
  // Using trig to predict ammo/rock intersection, adapted from:
  // https://gamedev.stackexchange.com/questions/25277/how-to-calculate-shot-angle-and-velocity-to-hit-a-moving-target
  PVector predictAim(PVector startingPos, PVector targetPos, PVector rockVel) {
    PVector toTarget = PVector.sub(targetPos, startingPos);
    float a = PVector.dot(rockVel, rockVel) - (25 * 25);
    float b = 2 * PVector.dot(rockVel, toTarget);
    float c = PVector.dot(toTarget, toTarget);

    float p = -b / (2 * a);
    float q = sqrt((b * b) - 4 * a * c) / (2 * a);
    
    float t1 = p - q;
    float t2 = p + q;
    float t;
    
    if (t1 > t2 && t2 > 0) {
      t = t2;
    } else {
      t = t1;
    }
    
    PVector aimSpot = PVector.mult(rockVel, t).add(targetPos);
    return aimSpot.sub(startingPos);
  }
  
  boolean outOfScreen(float xPos) {
    return position.x < xPos || position.x > xPos + width;
  }
  
  void reset() {
    active = false;
    position = new PVector(0, 0) ;
    velocity = new PVector(0, 0) ;

  }
  
}
