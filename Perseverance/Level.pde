class Level {
  
  float mountainPos = 0;
  Camera camera;
  
  PVector[] platforms;
  
  public Level() {
    camera = new Camera();
    platforms = new PVector[10];
    for (int i = 0; i < 10; i++) {
      platforms[i] = new PVector(int(random(0,2300)), int(random(100,600)));
    }
  }
  
  void draw() {
    for (int i = 0; i < 10; i++) {
      rect(platforms[i].x, platforms[i].y, 120, 40);
    }
  }
  
  void bgDraw() {    
    
    background(235, 94, 63);
    
    // looping bg - https://forum.processing.org/two/discussion/12084/looping-background-image
    image(mountainsImg, mountainPos-mountainsImg.width, height-mountainsImg.height);
    image(mountainsImg, mountainPos, height-mountainsImg.height);
    image(mountainsImg, mountainPos+mountainsImg.width, height-mountainsImg.height);
    //mountainPos++;
    if (mountainPos-mountainsImg.width == 0) {
      mountainPos -= mountainsImg.width;
    }
    
    if (mountainPos+(mountainsImg.width*2) < width) {
      mountainPos += mountainsImg.width;
    }
    
    if (mountainPos-mountainsImg.width > 0) {
      mountainPos -= mountainsImg.width;
    }
    
    noStroke();
    fill(225, 78, 44);
    rect(0, height - 80, width, 80);

  }
  
  void backgroundScroll(float pos, float vel) {
    
    if (pos > Camera.LEFT_MARGIN && pos < FULL_WIDTH - Camera.RIGHT_MARGIN) {
      mountainPos -= vel/2;
    }
  }
  
  void moveCamera(float leftX, float rightX) {
    camera.moveCamera(leftX, rightX);
  }
}
