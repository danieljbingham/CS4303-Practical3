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
public static final int UPGRADES = 3;

public static final long TIMER_MAX = 60000;
public static final long JETPACK_MAX = 300;
public static final int LIVES_MAX = 5;

public static final long currTimerMax = 10000;
public static final long currJetpackMax = 50;
public static final int currLivesMax = 1;


// GAME
int gameState;
Level level;
Astronaut astronaut;
Rock rock;

// IMAGES
public static PImage menuImg;
public static PImage upgradesImg;
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
UpgradeButton upBtn1;
UpgradeButton upBtn2;
UpgradeButton upBtn3;
UpgradeButton upBtn4;
UpgradeButton upBtn5;
UpgradeButton upBtn6;


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
  upgradesImg = loadImage("upgrades.jpg");
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
  upBtn1 = new UpgradeButton(100, 300, "Time");
  upBtn2 = new UpgradeButton(450, 300, "Astronaut Speed");
  upBtn3 = new UpgradeButton(800, 300, "Jetpack Fuel");
  upBtn4 = new UpgradeButton(100, 500, "Rover Strength");
  upBtn5 = new UpgradeButton(450, 500, "Ammo Reload");
  upBtn6 = new UpgradeButton(800, 500, "Up6");
  
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
      roverCollision();
      
      if (rock.outOfScreen(level.camera.pos.x - 20)) {
        if (random(0,1) < 0.05) {
          rock.fireRock(int(level.camera.pos.x + width));
        }
      }
      
      if (astronaut.jetpack && !astronaut.jetpackAvailable(currJetpackMax)) {
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
      
    case UPGRADES:
      drawUpgrades();
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
            if (astronaut.jetpackAvailable(currJetpackMax)) {
              astronaut.jetpack = true;
              astronaut.jetpackTransition = true;
              jetpackForce.set(0, -150);
            }
            
            if (astronaut.isGrounded()) {
              astronaut.jump(currJetpackMax);
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
           if (astronaut.jetpackAvailable(currJetpackMax)) {
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
    case UPGRADES:
      if (key == ' ') {
        // start game
        gameState = MENU;
        levelSetup();
      }
      break;
  }
}

void mouseClicked() {
  switch (gameState) {
    case MENU:
      break;
    case UPGRADES:
      if (upBtn1.inButton(mouseX, mouseY)) {
        println("Click");
      }
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
  playBtn.draw();
}

// upgrades screen
void drawUpgrades() {
  image(upgradesImg, 0, 0);
  textAlign(CENTER);
  text("Click to upgrade", width/2, 250);
  upBtn1.draw();
  upBtn2.draw();
  upBtn3.draw();
  upBtn4.draw();
  upBtn5.draw();
  upBtn6.draw();
}

void drawLevelStats() {
    /*text("Astro x = " + astronaut.position.x, level.camera.pos.x + 40, 40);
  text("Camera x = " + level.camera.pos.x, level.camera.pos.x + 200, 40);
  text("FPS = " + frameRate, level.camera.pos.x + 360, 40);*/

  textSize(18);
  text("Time", level.camera.pos.x + 30, 42);
  
  if (!drawTimer()) {
    gameState = UPGRADES;
  }
  
  text("Fuel", level.camera.pos.x + 600, 42);
  drawJetpackFuel();
  
  text("Rover Health", level.camera.pos.x + 30, height-35);
  drawHealth();
}

boolean drawTimer() {
  long currTime = millis();
  float r = ((float)currTime - timer) / currTimerMax;
  float tWidth = 420 - (r * 420);
  rect(level.camera.pos.x + 90, 20, tWidth, 30);
  noFill();
  stroke(255,255,255);
  rect(level.camera.pos.x + 90, 20, 420, 30);
  
  return tWidth >= 1;
}

void drawJetpackFuel() {
  float r = ((float)currJetpackMax - astronaut.jetpackUsed) / currJetpackMax;
  float jetpackWidth = r * 420;
  fill(255,255,255);
  if (astronaut.jetpackAvailable(currJetpackMax)) {
    rect(level.camera.pos.x + 660, 20, jetpackWidth, 30);
  }
  noFill();
  stroke(255,255,255);
  rect(level.camera.pos.x + 660, 20, 420, 30);
}

void drawHealth() {
  float r = ((float)astronaut.rover.hits) / currLivesMax;
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

// check for collision betweek rover and rocks
boolean roverCollision() {
  // check for collision between shell and opposition tank
  if (rock.active) {
    Rover rover = astronaut.rover;
    PVector distance = rock.position.get();
    PVector roverPos = new PVector(rover.position.x + (rover.roverWidth/2), rover.position.y + (rover.roverHeight/2));
    distance.sub(roverPos);
    if (distance.mag() < (rover.roverWidth + rover.roverHeight)/2) {
      rover.hits++;
      rock.active = false;
      if (rover.hits == currLivesMax) {
        gameState = UPGRADES;
      }
      return true; 
    }
  }
  return false;
}
