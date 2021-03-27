/**
 * A force generator that applies a force specified
 *  by the user.
 */
public final class UserForce extends ForceGenerator {
  // Holds the acceleration due to gravity
  private PVector force ;
  
  // Constructs the generator with the given initial force
  UserForce(PVector force) {
    this.force = force ;
  }

  // Allow the user to set this force
  void set(float x, float y) {
    force.x = x ;
    force.y = y ; 
  }

  // Applies the user force to the given particle
  void updateForce(Particle particle) {
    particle.addForce(force);
  }
}
