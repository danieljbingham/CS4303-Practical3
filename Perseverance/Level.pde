class Level {
  
  float mountainPos = 0;
  Camera camera;
  
  int[][] tiles;
  boolean showStroke;
  
  public Level(int levelNo) {
    camera = new Camera();
    showStroke = false;
    tiles = new int[NUM_TILES_W][NUM_TILES_H];
    
    Table table = loadTable("level" + levelNo + ".csv", "csv");
    
    for (int i = 0; i < table.getColumnCount(); i++) {
      for (int j = 0; j < table.getRowCount(); j++) {
        tiles[i][j] = table.getInt(j,i);
      }
    }

  }
  
  public Level() {
    camera = new Camera();
    showStroke = true;
    tiles = new int[NUM_TILES_W][NUM_TILES_H];
  }
  
  void draw() {

    for (int i = 0; i < tiles[0].length; i++) {
      for (int j = 0; j < tiles.length; j++) {
        if (showStroke) {
          stroke(255,255,255);
        }
        
        if (tiles[j][i] == 1) {
          PVector xy = toXY(new PVector(j,i));
          fill(225, 78, 44);
          rect(xy.x, xy.y, TILE_SIZE_W, TILE_SIZE_H);
        } else if (tiles[j][i] == 2) {
          PVector xy = toXY(new PVector(j,i));
          fill(255,220,0);
          ellipse(xy.x + TILE_SIZE_W/2, xy.y + TILE_SIZE_H/2, 25, 25);
        } else if (tiles[j][i] == 0 && i <= 12) {
          PVector xy = toXY(new PVector(j,i));
          noFill();
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
    rect(0, height - 280, width, 40);
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
     //<>//
    for (int i = 0; i <= tileMax.x - tileMin.x; i++) {
      for (int j = int(tileMin.y); j < tiles[0].length && j >= 0; j+=increment) {
        if (int(tileMin.x + i) < NUM_TILES_W && tiles[int(tileMin.x + i)][j] == 1) {
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
  
  void setCell(float x, float y, int cellType) {
    PVector tile = toTile(x, y);
    PVector tileMax = toTile(FULL_WIDTH + 1, y);
    
    if (int(tile.y) >= 0 && int(tile.y) <= 12 && int(tile.x) < int(tileMax.x) && int(tile.x) >= 0) {
      if (!(tile.x == 2 && (tile.y == 11 || tile.y == 12))) {
        tiles[int(tile.x)][int(tile.y)] = cellType;
      }
    }
  }
  
  void toCSV(int levelNo) {
    Table table = new Table();
    for (int i = 0; i < NUM_TILES_W; i++) {
      table.addColumn();
    }
    
    for (int i = 0; i < tiles[0].length; i++) {
      TableRow row = table.addRow();
      for (int j = 0; j < tiles.length; j++) {
        row.setInt(j, tiles[j][i]);
      }
    }
    saveTable(table, "data/level" + levelNo + ".csv");
  }
}
