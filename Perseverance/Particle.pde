// a representation of a point mass
class Particle {
  
  // Vectors to hold pos, vel
  // I'm allowing public access to keep things snappy.
  public PVector position, velocity ;
  
  // Vector to accumulate forces prior to integration
  PVector forceAccumulator ; 
  
  // damping factor to simulate drag, as per Millington
  // Disabled when using Drag Force Generator
  static final float DAMPING = .995f ;
  
  // Store inverse mass to allow simulation of infinite mass
  float invMass ;
  
  // If you do need the mass, here it is:
  public float getMass() {return 1/invMass ;}
  
  Particle() {
    position = new PVector(0, 0) ;
    velocity = new PVector(0, 0) ;
    forceAccumulator = new PVector(0, 0) ;
    invMass = 1 ;    
  }
  
  Particle(int x, int y, float xVel, float yVel, float invM) {
    position = new PVector(x, y) ;
    velocity = new PVector(xVel, yVel) ;
    forceAccumulator = new PVector(0, 0) ;
    invMass = invM ;    
  }
  
  // Add a force to the accumulator
  void addForce(PVector force) {
    forceAccumulator.add(force) ;
  }
  
  // update position and velocity
  void integrate() {
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
    velocity.mult(DAMPING) ;

    // Clear accumulator
    forceAccumulator.x = 0 ;
    forceAccumulator.y = 0 ;    
  }
}
