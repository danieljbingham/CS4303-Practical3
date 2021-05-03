// GAME DIMENSIONS
public static final int WIDTH = 1200;
public static final int HEIGHT = 800;
public static final int FLOOR_Y = HEIGHT - 280;
public static final int ROVER_FLOOR_Y = HEIGHT - 80;
public static final int FULL_WIDTH = 1200*8;
public static final int TILE_SIZE_W = WIDTH/20;
public static final int TILE_SIZE_H = HEIGHT/20;
public static final int NUM_TILES_W = FULL_WIDTH/TILE_SIZE_W;
public static final int NUM_TILES_H = HEIGHT/TILE_SIZE_H;

// GAME STATE VALUES
public static final int SPLASH = 0;
public static final int MENU = 1;
public static final int LEVEL = 2;
public static final int INVENTORY = 3;

public static final long TIMER_MAX = 30000;
public static final long JETPACK_MAX = 150;

// GAME
int gameState;
Level level;
Astronaut astronaut;
Rock rock;

// IMAGES
public static PImage menuImg;
public static PImage mountainsImg;

public static PImage l1;
public static PImage l2;
public static PImage l3;
public static PImage r1;
public static PImage r2;
public static PImage r3;
public static PImage j1l;
public static PImage j2l;
public static PImage j3l;
public static PImage j4l;
public static PImage j1r;
public static PImage j2r;
public static PImage j3r;
public static PImage j4r;

Button playBtn;


// A force generator that applies a force specified by the user.
UserForce leftForce ;
UserForce rightForce ;
UserForce jetpackForce ;
// Holds all the force generators and the particles they apply to
ForceRegistry forceRegistry ;

long timer;


void settings() {
  size(WIDTH, HEIGHT);
}

void setup() {
  frameRate(30);
  
  menuImg = loadImage("menu.jpg");
  mountainsImg = loadImage("mountains.png");
  l1 = loadImage("left1.png");
  l2 = loadImage("left2.png");
  l3 = loadImage("left3.png");
  r1 = loadImage("right1.png");
  r2 = loadImage("right2.png");
  r3 = loadImage("right3.png");
  j1r = loadImage("jetpack1.png");
  j2r = loadImage("jetpack2.png");
  j3r = loadImage("jetpack3.png");
  j4r = loadImage("jetpack4.png");
  j1l = loadImage("jetpack1l.png");
  j2l = loadImage("jetpack2l.png");
  j3l = loadImage("jetpack3l.png");
  j4l = loadImage("jetpack4l.png");
  
  playBtn = new Button(100, 200, "Play");
  
  astronaut = new Astronaut();
  gameState = MENU; 
  rock = new Rock();
  
  //Create a gravitational force
  Gravity gravity = new Gravity(new PVector(0f, .5f)) ;
  //Create the user force
  leftForce = new UserForce(new PVector(0f, 0f)) ;
  rightForce = new UserForce(new PVector(0f, 0f)) ;
  jetpackForce = new UserForce(new PVector(0f, 0f)) ;
  //Create the ForceRegistry
  forceRegistry = new ForceRegistry();
  
  forceRegistry.add(astronaut, gravity) ;
  forceRegistry.add(astronaut, leftForce) ;
  forceRegistry.add(astronaut, rightForce) ;
  forceRegistry.add(astronaut, jetpackForce) ;
  
  forceRegistry.add(rock, gravity);
  
}

void draw() {
  switch (gameState) {
    case SPLASH:
      break;
      
    case MENU:
      drawMenu();
      break;
      
    case LEVEL:
      level.bgDraw();
      level.moveCamera(astronaut.position.x, astronaut.position.x + astronaut.astroWidth);
      forceRegistry.updateForces();
      astronaut.integrate();
      rock.integrate();
      
      if (rock.outOfScreen(level.camera.pos.x - 20)) {
        if (random(0,1) < 0.05) {
          rock.fireRock(int(level.camera.pos.x + width));
        }
      }
      
      if (astronaut.jetpack && !astronaut.jetpackAvailable()) {
        astronaut.jetpack = false;
        jetpackForce.set(0f, 0f);
      }
      astronaut.checkBounds();
      level.backgroundScroll(astronaut.position.x, astronaut.velocity.x);
      level.draw();
      
      /*noFill();
      stroke(255,255,255);
      for (int i = 0; i < 20; i++) {
        for (int j = 0; j < 20; j++) {
          rect(i*(WIDTH/20), j*(HEIGHT/20), WIDTH/20, HEIGHT/20);
        }
      }*/
      
      astronaut.draw();
      rock.draw();
      drawLevelStats();
      break;
      
    case INVENTORY:
      break;
  }
}

void keyPressed() {
  
  switch (gameState) {
    case LEVEL:
      if (key == CODED) {
        switch (keyCode) {
          case LEFT :
            astronaut.left = true;
            astronaut.rightFacing = false;
            leftForce.set(-25, 0);
            break;
          case RIGHT :
            astronaut.right = true;
            astronaut.rightFacing = true;
            rightForce.set(25, 0);
            break;
          case UP :
            if (astronaut.jetpackAvailable()) {
              astronaut.jetpack = true;
              astronaut.jetpackTransition = true;
              jetpackForce.set(0, -150);
            } else if (astronaut.isGrounded()) {
              astronaut.jump();
            }
            break;
          case DOWN :
            break;
        }
      }
      break;
  }
}

void keyReleased() {
  switch (gameState) {
    case LEVEL:
      if (key == CODED) {
        switch (keyCode) {
          case LEFT :
            astronaut.left = false;
            leftForce.set(0, 0);
            break;
          case RIGHT :
            astronaut.right = false;
            rightForce.set(0, 0);
            break;
          case UP :
           if (astronaut.jetpackAvailable()) {
              astronaut.jetpack = false;
              astronaut.jetpackTransition = true;
              jetpackForce.set(0, 0);
              break;
           }
          case DOWN :
            break;
        }
      }
      break;
  }
}

void keyTyped() {
  switch (gameState) {
    case MENU:
      if (key == ' ') {
        // start game
        gameState = LEVEL;
        levelSetup();
      }
      break;
    case LEVEL:
      break;
    case INVENTORY:
      break;
  }
}

void levelSetup() {
  level = new Level();
  timer = millis();
  astronaut.reset();
  rock.reset();
  leftForce.set(0f, 0f);
  rightForce.set(0f, 0f);
  jetpackForce.set(0f, 0f);
}

// menu screen
void drawMenu() {
  image(menuImg, 0, 0);
  playBtn.draw(false);
}

void drawLevelStats() {
    /*text("Astro x = " + astronaut.position.x, level.camera.pos.x + 40, 40);
  text("Camera x = " + level.camera.pos.x, level.camera.pos.x + 200, 40);
  text("FPS = " + frameRate, level.camera.pos.x + 360, 40);*/

  textSize(18);
  text("Time", level.camera.pos.x + 30, 42);
  
  if (!drawTimer()) {
    gameState = MENU;
  }
  
  text("Fuel", level.camera.pos.x + 600, 42);
  drawJetpackFuel();
  
  text("Rover Health", level.camera.pos.x + 30, height-35);
  drawHealth();
}

boolean drawTimer() {
  long currTime = millis();
  float r = ((float)currTime - timer) / TIMER_MAX;
  float tWidth = 420 - (r * 420);
  rect(level.camera.pos.x + 90, 20, tWidth, 30);
  noFill();
  stroke(255,255,255);
  rect(level.camera.pos.x + 90, 20, 420, 30);
  
  return tWidth >= 1;
}

void drawJetpackFuel() {
  float r = ((float)JETPACK_MAX - astronaut.jetpackUsed) / JETPACK_MAX;
  float jetpackWidth = r * 420;
  fill(255,255,255);
  if (astronaut.jetpackAvailable()) {
    rect(level.camera.pos.x + 660, 20, jetpackWidth, 30);
  }
  noFill();
  stroke(255,255,255);
  rect(level.camera.pos.x + 660, 20, 420, 30);
}

void drawHealth() {
  long currTime = millis();
  float r = ((float)currTime - timer) / TIMER_MAX;
  float tWidth = 420 - (r * 420);
  fill(255,255,255);
  rect(level.camera.pos.x + 160, height-55, tWidth, 30);
  noFill();
  stroke(255,255,255);
  rect(level.camera.pos.x + 160, height-55, 420, 30);
}

public static PVector toTile(float x, float y) {
  return new PVector(floor(x/TILE_SIZE_W), floor(y/TILE_SIZE_H));
}

public static PVector toXY(PVector tile) {
  return new PVector(tile.x*TILE_SIZE_W, tile.y*TILE_SIZE_H);
}
