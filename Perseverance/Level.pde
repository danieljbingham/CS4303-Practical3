class Level {
  
  float mountainPos = 0;
  Camera camera;
  
  int[][] tiles;
  //PVector[] platforms;
  
  public Level() {
    camera = new Camera();
    //platforms = new PVector[10];
    //for (int i = 0; i < 10; i++) {
    //  platforms[i] = new PVector(int(random(0,2300)), int(random(100,600)));
    //}
    
    tiles = new int[NUM_TILES_W][NUM_TILES_H];
    for (int i = 3; i < 17; i++) {
      int r = int(random(2, tiles.length - 6));
      for (int j = 0; j < 4; j++) {
        tiles[r+j][i] = 1;
      }
    }
    
    /*for (int i = 0; i < tiles[0].length; i++) {        //println();

      for (int j = 0; j < tiles.length; j++) {
        if (tiles[j][i] == 1) {
          PVector xy = toXY(new PVector(j,i));
          //println("rect: ", xy.x, xy.y, TILE_SIZE_W, TILE_SIZE_H);
          //print("_");
        } else {
          //print(".");
        }
      }
    }*/

  }
  
  void draw() {
    //for (int i = 0; i < 10; i++) {
    //  rect(platforms[i].x, platforms[i].y, 120, 40);
    //}
    
    for (int i = 0; i < tiles[0].length; i++) {
      for (int j = 0; j < tiles.length; j++) {
        if (tiles[j][i] == 1) {
          PVector xy = toXY(new PVector(j,i));
          //println("rect: ", xy.x, xy.y, TILE_SIZE_W, TILE_SIZE_H);
          rect(xy.x, xy.y, TILE_SIZE_W, TILE_SIZE_H);
        }
      }
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
  
  float isXCollision(float x, float y, int h, int increment) {
    PVector tileMin = toTile(x, y);
    PVector tileMax = toTile(x, y+h-1);
    float distance = Float.MAX_VALUE;
    
    for (int i = 0; i <= tileMax.y - tileMin.y; i++) {
      for (int j = int(tileMin.x); j < tiles.length && j >= 0; j+=increment) {
        if (tileMin.y + i >=0) {
          if (tiles[j][int(tileMin.y + i)] == 1) {
            float currDistance = toXY(new PVector(j, int(tileMin.y + i))).x - x;
            currDistance = increment < 0 ? currDistance + TILE_SIZE_W : currDistance;
            if (abs(currDistance) < abs(distance)) {
              distance = currDistance;
            }
            break;
          }
        }
      }
    }
    
    return distance;
  }

  float isYCollision(float x, float y, int w, int increment) { 
    PVector tileMin = toTile(x, y);
    PVector tileMax = toTile(x+w-1, y);
    float distance = Float.MAX_VALUE;

    for (int i = 0; i <= tileMax.x - tileMin.x; i++) {
      for (int j = int(tileMin.y); j < tiles[0].length && j >= 0; j+=increment) {
        if (tiles[int(tileMin.x + i)][j] == 1) {
          float currDistance = toXY(new PVector(int(tileMin.x + i),j)).y - y;
          currDistance = increment < 0 ? currDistance + TILE_SIZE_H : currDistance;
          if (abs(currDistance) < abs(distance)) {
            distance = currDistance;
          }
          break;
        }
      }
    }
    
    return distance;
  }
}
