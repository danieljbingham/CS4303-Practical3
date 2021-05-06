class Camera {
  
  final static int LEFT_MARGIN = 600;
  final static int RIGHT_MARGIN = 600;
  
  PVector pos;
  
  Camera() {
    pos = new PVector(0,0);
  }
  
  void moveCamera(float leftX, float rightX) {
    if (rightX > pos.x + width - RIGHT_MARGIN) {
      if (pos.x + width < FULL_WIDTH) {
        pos.x += rightX - (pos.x + width - RIGHT_MARGIN);
      }
    }
    
    if (leftX < pos.x + LEFT_MARGIN) {
      if (leftX > 0) {
        pos.x -= (pos.x + LEFT_MARGIN) - leftX;
      }
    }
    
    if (pos.x < 0) {
      pos.x = 0;
    } else if (pos.x + width > FULL_WIDTH) {
      pos.x = FULL_WIDTH - width;
    }
    
    translate(-pos.x, 0);
  }

}
