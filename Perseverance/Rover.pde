class Rover extends Particle {

  private final PImage img = loadImage("rover.png");

  public Rover() {
    super(150, height-80-40, 0, 0, 0.01f);
  }
  
  void draw() {
    imageMode(CORNER);
    image(img, position.x, position.y);
    //fill(200,200,200);
    //rect(position.x, position.y, 80, 40);
  }
  
  void setPos(float x) {
    position.x = x;
  }
  
}
