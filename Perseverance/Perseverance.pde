import java.text.SimpleDateFormat;
import java.util.Date;

// GAME DIMENSIONS
public static final int WIDTH = 1200;
public static final int HEIGHT = 800;
public static final int FLOOR_Y = HEIGHT - 280;
public static final int ROVER_FLOOR_Y = HEIGHT - 80;
public static final int FULL_WIDTH = 1200*5;
public static final int TILE_SIZE_W = WIDTH/20;
public static final int TILE_SIZE_H = HEIGHT/20;
public static final int NUM_TILES_W = FULL_WIDTH/TILE_SIZE_W;
public static final int NUM_TILES_H = HEIGHT/TILE_SIZE_H;

// GAME STATE VALUES
public static final int SPLASH = 0;
public static final int MENU = 1;
public static final int SAVES = 2;
public static final int LEVEL = 3;
public static final int UPGRADES = 4;
public static final int HOWTO = 5;
public static final int INTRO = 6;

public static final long TIMER_MAX = 60000;
public static final long SPEED_MAX = 10;
public static final long JETPACK_MAX = 300;
public static final int LIVES_MAX = 11;
public static final int AMMO_MAX = 15;
public static final float ACCURACY_MAX = 0;


public static int gameId = 0;

// GAME
int gameState;
boolean overwrite;
Level level;
Astronaut astronaut;
Rock rock;
ArrayList<Ammo> ammo;

// UPGRADEABLE ATTRIBUTES
public static long currTimerMax = 10000;
public static float currSpeedMax = 2;
public static long currJetpackMax = 15;
public static int currLivesMax = 2;
public static int currAmmo = 100;
public static float currAccuracy = 0.9;

// IMAGES
public static PImage menuImg;
public static PImage upgradesImg;
public static PImage howtoImg;
public static PImage introImg;
public static PImage savesImg;
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

public static PImage[] rockImg = new PImage[5];

// menu buttons
Button newGameBtn;
Button continueGameBtn;
Button howtoBtn;
Button backBtn;

// saves buttons
UpgradeButton saveBtn1;
UpgradeButton saveBtn2;
UpgradeButton saveBtn3;

// upgrade screen buttons
Button playBtn;
UpgradeButton upBtn1;
UpgradeButton upBtn2;
UpgradeButton upBtn3;
UpgradeButton upBtn4;
UpgradeButton upBtn5;
UpgradeButton upBtn6;

// saved games
JSONObject[] saves = new JSONObject[3];

// A force generator that applies a force specified by the user.
UserForce leftForce ;
UserForce rightForce ;
UserForce jetpackForce ;
// Holds all the force generators and the particles they apply to
ForceRegistry forceRegistry ;

long timer;
int ammoReload;
int coins;
int maxDistance;
int runs;

int timerUps = 0;
int speedUps = 0;
int jetpackUps = 0;
int livesUps = 0;
int ammoUps = 0;
int accuracyUps = 0;


void settings() {
  size(WIDTH, HEIGHT);
}

void setup() {
  frameRate(30);
  
  menuImg = loadImage("menu.jpg");
  upgradesImg = loadImage("upgrades.jpg");
  mountainsImg = loadImage("mountains.png");
  savesImg = loadImage("saves.jpg");
  howtoImg = loadImage("howto.jpg");
  introImg = loadImage("intro.jpg");
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
  
  for (int i = 0; i < 5; i++) {
    rockImg[i] = loadImage("rock" + i + ".png");
  }
  
  newGameBtn = new Button(450, 260, 300, 120, "New Game");
  continueGameBtn = new Button(450, 430, 300, 120, "Continue Game");
  howtoBtn = new Button(450, 600, 300, 120, "How To");
  backBtn = new Button(50, 80, 150, 55, "Back To Menu");

  saveBtn1 = new UpgradeButton(400, 250, 400, 125, "Save slot 1");
  saveBtn2 = new UpgradeButton(400, 425, 400, 125, "Save slot 2");
  saveBtn3 = new UpgradeButton(400, 600, 400, 125, "Save slot 3");

  playBtn = new Button(500, 680, 200, 60, "Play");
  upBtn1 = new UpgradeButton(100, 320, 300, 125, "Time");
  upBtn2 = new UpgradeButton(450, 320, 300, 125, "Astronaut Speed");
  upBtn3 = new UpgradeButton(800, 320, 300, 125, "Jetpack Fuel Efficiency");
  upBtn4 = new UpgradeButton(100, 500, 300, 125, "Rover Strength");
  upBtn5 = new UpgradeButton(450, 500, 300, 125, "Ammo Reload Speed");
  upBtn6 = new UpgradeButton(800, 500, 300, 125, "Ammo Accuracy");
  
  astronaut = new Astronaut();
  gameState = MENU; 
  overwrite = false;
  rock = new Rock();
  ammo = new ArrayList();
  
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
    
    case SAVES:
      drawSaves();
      break;
      
    case LEVEL:
      level.bgDraw();
      level.moveCamera(astronaut.position.x, astronaut.position.x + astronaut.astroWidth);
      forceRegistry.updateForces();
      astronaut.integrate();
      rock.integrate();
      roverCollision();
      ammoCollision();
      
      if ((rock.outOfScreen(level.camera.pos.x - 20) || !rock.active) && !rock.exploding) {
        if (random(0,1) < 0.04) {
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
      
      Iterator<Ammo> itr = ammo.iterator();
      while (itr.hasNext()) {
        Ammo a = itr.next();
        a.integrate();
        a.draw();
        if (a.outOfScreen(level.camera.pos.x)) {
          itr.remove();
        }
      }
      
      if (ammoReload > 0) {
        ammoReload--;
      }
      
      checkPickups();

      drawLevelStats();
      
      if (astronaut.position.x + astronaut.astroWidth > FULL_WIDTH) {
        gameState = UPGRADES;
        runs++;
      }
      
      if (astronaut.position.x/10 > maxDistance) {
        maxDistance = int(astronaut.position.x/10);
      }
      break;
      
    case UPGRADES:
      drawUpgrades();
      break;
    
    case HOWTO:
      drawHowto();
      break;
      
    case INTRO:
      drawIntro();
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
            leftForce.set(-5*currSpeedMax, 0);
            break;
          case RIGHT :
            astronaut.right = true;
            astronaut.rightFacing = true;
            rightForce.set(5*currSpeedMax, 0);
            break;
          case UP :
            if (astronaut.jetpackAvailable(currJetpackMax)) {
              astronaut.jetpack = true;
              astronaut.jetpackTransition = true;
              jetpackForce.set(0, -110);
            }
            
            if (astronaut.isGrounded()) {
              astronaut.jump(currJetpackMax);
            }
            break;
          case DOWN :
            break;
        }
      } else {
        if (key == ' ') {
          if (ammoReload == 0) {
            ammo.add(new Ammo(astronaut.rover.position.copy(), rock.position.copy(), rock.velocity.copy(), rock.active, currAccuracy));
            ammoReload = currAmmo;
          }
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

void mouseClicked() {
  switch (gameState) {
    case MENU:
      if (newGameBtn.inButton(mouseX, mouseY)) {
        //gameState = LEVEL;
        //levelSetup();
        gameState = SAVES;
        overwrite = true;
        for (int i = 0; i < 3; i++) {
          try {
            JSONObject json = loadJSONObject("data/save" + i + ".json");
            saves[i] = json;
          } catch(NullPointerException e) {
            saves[i] = null;            
          }
        }
      } else if (continueGameBtn.inButton(mouseX, mouseY)) {
        gameState = SAVES;
        overwrite = false;
        for (int i = 0; i < 3; i++) {
          try {
            JSONObject json = loadJSONObject("data/save" + i + ".json");
            saves[i] = json;
          } catch(NullPointerException e) {
            saves[i] = null;            
          } //<>//
        }
      } else if (howtoBtn.inButton(mouseX, mouseY)) {
        gameState = HOWTO;
      }
      break;
    case UPGRADES:
      if (upBtn1.inButton(mouseX, mouseY)) {
        upgradeTimer();
      } else if (upBtn2.inButton(mouseX, mouseY)) {
        upgradeSpeed();
      } else if (upBtn3.inButton(mouseX, mouseY)) {
        upgradeJetpack();
      } else if (upBtn4.inButton(mouseX, mouseY)) {
        upgradeLives();
      } else if (upBtn5.inButton(mouseX, mouseY)) {
        upgradeAmmoReload();
      } else if (upBtn6.inButton(mouseX, mouseY)) {
        upgradeAmmoAccuracy();
      } else if (playBtn.inButton(mouseX, mouseY)) {
        gameState = LEVEL;
        levelSetup();
      }
      break;
      
    case SAVES:
      if (saveBtn1.inButton(mouseX, mouseY)) {
        if (overwrite) {
          clearGame();
          gameId = 0;
          gameState = INTRO;
        } else if (saves[0] != null) {
          jsonToGame(saves[0]);
          gameState = UPGRADES;
          gameId = 0;
        }
      } else if (saveBtn2.inButton(mouseX, mouseY)) {
        if (overwrite) {
          clearGame();
          gameId = 1;
          gameState = INTRO;
        } else if (saves[1] != null) {
          jsonToGame(saves[1]);
          gameState = UPGRADES;
          gameId = 1;
        }
      } else if (saveBtn3.inButton(mouseX, mouseY)) {
        if (overwrite) {
          clearGame();
          gameId = 2;
          gameState = INTRO;
        } else if (saves[2] != null) {
          jsonToGame(saves[2]);
          gameState = UPGRADES;
          gameId = 2;
        }
      }
      
      case INTRO:
        if (playBtn.inButton(mouseX, mouseY)) {
          gameState = LEVEL;
          levelSetup();
        }
  }
  
  if (backBtn.inButton(mouseX, mouseY)) {
    if (gameState == UPGRADES) {
      saveGame();
    }
    gameState = MENU;
  }
}

void upgradeTimer() {
  int cost = timerCost();
  if (coins >= cost) {
    if (currTimerMax < TIMER_MAX) {
      currTimerMax += 1000;
      coins -= cost;
      timerUps++;
    }
  }
}

void upgradeSpeed() {
  int cost = speedCost();
  if (coins >= cost) {
    if (currSpeedMax < SPEED_MAX) {
      currSpeedMax += 0.5;
      coins -= cost;
      speedUps++;
    }
  }
}

void upgradeJetpack() {
  int cost = jetpackCost();
  if (coins >= cost) {
    if (currJetpackMax < JETPACK_MAX) {
      currJetpackMax += 15;
      coins -= cost;
      jetpackUps++;
    }
  }
}

void upgradeLives() {
  int cost = livesCost();
  if (coins >= cost) {
    if (currLivesMax < LIVES_MAX) {
      currLivesMax += 1;
      coins -= cost;
      livesUps++;
    }
  }
}

void upgradeAmmoReload() {
  int cost = ammoCost();
  if (coins >= cost) {
    if (currAmmo > AMMO_MAX) {
      currAmmo -= 5;
      coins -= cost;
      ammoUps++;
    }
  }
}

void upgradeAmmoAccuracy() {
  int cost = accuracyCost();
  if (coins >= cost) {
    if (currAccuracy > ACCURACY_MAX) {
      currAccuracy -= 0.1;
      coins -= cost;
      accuracyUps++;
    }
  }
}

int timerCost() {
  return 5 + (timerUps/5)*5;
}

int speedCost() {
  return 5 + (speedUps/5)*5;
}

int jetpackCost() {
  return 5 + (jetpackUps/5)*5;
}

int livesCost() {
  return 5 + (livesUps/5)*5;
}

int ammoCost() {
  return 5 + (ammoUps/5)*5;
}

int accuracyCost() {
  return 5 + (accuracyUps/5)*5;
}

void checkPickups() {
  PVector tile = toTile(astronaut.position.x + astronaut.astroWidth/2, astronaut.position.y + astronaut.astroHeight/2);
  if (int(tile.x) >= 120) {
    println("why"); //<>//
  }
  tile = toTile(astronaut.position.x + astronaut.astroWidth/2, astronaut.position.y + astronaut.astroHeight/2);
  if (astronaut.position.y > 0 && astronaut.position.x < FULL_WIDTH && level.tiles[int(tile.x)][int(tile.y)] == 2) {
    level.tiles[int(tile.x)][int(tile.y)] = 0;
    coins += 5;
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
  ammoReload = 0;
  ammo = new ArrayList();
}

// menu screen
void drawMenu() {
  image(menuImg, 0, 0);
  newGameBtn.draw();
  continueGameBtn.draw();
  howtoBtn.draw();
}

// saves screen
void drawSaves() {
  image(savesImg, 0, 0);
  saveBtn1.draw(getSaveSummary(saves[0]));
  saveBtn2.draw(getSaveSummary(saves[1]));
  saveBtn3.draw(getSaveSummary(saves[2]));
  backBtn.draw();
}

// upgrades screen
void drawUpgrades() {
  image(upgradesImg, 0, 0);
  
  textAlign(LEFT);
  text("Attempts: " + runs, 180, 242);
  text("Max distance travelled: " + maxDistance + "m", 483, 242);
  text(coins + "", 1000, 242);
  fill(255,220,0);
  ellipse(980, 235, 18, 18);
  
  textAlign(CENTER);
  fill(255,255,255);
  text("Click to make upgrades", width/2, 290);
  
  String upBtn1Text = currTimerMax < TIMER_MAX ?  timerCost() + " coins" : "MAX";
  String upBtn2Text = currSpeedMax < SPEED_MAX ? speedCost() + " coins" : "MAX";
  String upBtn3Text = currJetpackMax < JETPACK_MAX ? jetpackCost() + " coins" : "MAX";
  String upBtn4Text = currLivesMax < LIVES_MAX ? livesCost() + " coins" : "MAX";
  String upBtn5Text = currAmmo > 15 ? ammoCost() + " coins" : "MAX";
  String upBtn6Text = currAccuracy > 0 ? accuracyCost() + " coins" : "MAX";
  
  upBtn1.draw(currTimerMax/1000 + " secs        " + upBtn1Text);
  upBtn2.draw(nf(currSpeedMax,0,1) + " m/s        " + upBtn2Text);
  upBtn3.draw(currJetpackMax/3 + "%        " + upBtn3Text);
  upBtn4.draw("Level " + (currLivesMax-1) + "        " + upBtn4Text);
  upBtn5.draw("Level " + (21-(currAmmo/5)) + "        " + upBtn5Text);
  upBtn6.draw("Level " + nf((1-currAccuracy)*10,0,0) + "        " + upBtn6Text);
  playBtn.draw();
  backBtn.draw();
  textAlign(LEFT);
}

void drawHowto() {
  image(howtoImg, 0, 0);
  backBtn.draw();
}

void drawIntro() {
  image(introImg, 0, 0);
  playBtn.draw();
}

void drawLevelStats() {
    /*text("Astro x = " + astronaut.position.x, level.camera.pos.x + 40, 40);
  text("Camera x = " + level.camera.pos.x, level.camera.pos.x + 200, 40);
  text("FPS = " + frameRate, level.camera.pos.x + 360, 40);*/

  fill(255,255,255);
  textSize(18);
  
  text("Time", level.camera.pos.x + 30, 42);
  text("Fuel", level.camera.pos.x + 600, 42);
  text("Rover Health", level.camera.pos.x + 30, height-35);
  text("Ammo", level.camera.pos.x + 620, height-35);
  
  if (!drawTimer()) {
    gameState = UPGRADES;
    runs++;
    saveGame();
    //gameState = MENU;
  }
  drawJetpackFuel();
  drawHealth();
  drawAmmo();
  
  text(coins + "", level.camera.pos.x + 1120, 42);
  fill(255,220,0);
  ellipse(level.camera.pos.x + 1100, 35, 18, 18);

}

boolean drawTimer() {
  long currTime = millis();
  float r = ((float)currTime - timer) / currTimerMax;
  float tWidth = 420 - (r * 420);
  rect(level.camera.pos.x + 90, 20, tWidth, 30);
  noFill();
  stroke(255,255,255);
  rect(level.camera.pos.x + 90, 20, 420, 30);
  fill(225, 78, 44);
  if (tWidth < 21) {
    fill(255,255,255);
  }
  double time = Math.ceil(((float)currTimerMax-(currTime-timer))/1000);
  text((int)time, level.camera.pos.x + 105, 42);

  return tWidth >= 1;
}

void drawJetpackFuel() {
  float r = ((float)currJetpackMax - astronaut.jetpackUsed) / currJetpackMax;
  float jetpackWidth = r * 390;
  fill(255,255,255);
  if (astronaut.jetpackAvailable(currJetpackMax)) {
    rect(level.camera.pos.x + 660, 20, jetpackWidth, 30);
  }
  noFill();
  stroke(255,255,255);
  rect(level.camera.pos.x + 660, 20, 390, 30);
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

void drawAmmo() {
  float r = ((float)ammoReload) / currAmmo;
  float tWidth = 360 - (r * 360);
  fill(255,255,255);
  rect(level.camera.pos.x + 700, height-55, tWidth, 30);
  noFill();
  stroke(255,255,255);
  rect(level.camera.pos.x + 700, height-55, 360, 30);
}

void saveGame() {
  JSONObject json = gameToJson();
  saveJSONObject(json, "data/save" + gameId + ".json");
}

JSONObject gameToJson() {
  JSONObject json = new JSONObject();
  //json.setInt("runs", 0);
  json.setInt("coins", coins);
  json.setInt("runs", runs);
  json.setInt("distance", maxDistance);
  json.setLong("timer", currTimerMax);
  json.setFloat("speed", currSpeedMax);
  json.setLong("jetpack", currJetpackMax);
  json.setInt("lives", currLivesMax);
  json.setInt("ammo", currAmmo);
  json.setFloat("accuracy", currAccuracy);
  json.setString("date", new SimpleDateFormat("dd-MM-yyyy").format(new Date())); //<>//

  return json;
}

void jsonToGame(JSONObject json) {
  coins = json.getInt("coins");
  runs = json.getInt("runs");
  maxDistance = json.getInt("distance");
  currTimerMax = json.getLong("timer");
  currSpeedMax = json.getFloat("speed");
  currJetpackMax = json.getLong("jetpack");
  currLivesMax = json.getInt("lives");
  currAmmo = json.getInt("ammo");
  currAccuracy = json.getFloat("accuracy"); //<>//
}

String getSaveSummary(JSONObject j) {
  if (j == null) {
    return "Empty";
  } else {
    return "Last played: " + j.getString("date");
  }
}

void clearGame() {
  coins = 0;
  runs = 0;
  maxDistance = 0;
  currTimerMax = 10000;
  currSpeedMax = 2;
  currJetpackMax = 15;
  currLivesMax = 2;
  currAmmo = 100;
  currAccuracy = 0.9;
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
  if (rock.active && !rock.exploding) {
    Rover rover = astronaut.rover;
    PVector distance = rock.position.get();
    PVector roverPos = new PVector(rover.position.x + (rover.roverWidth/2), rover.position.y + (rover.roverHeight/2));
    distance.sub(roverPos);
    if (distance.mag() < (rover.roverWidth + rover.roverHeight)/2) {
      rover.hits++;
      rock.active = false;
      if (rover.hits == currLivesMax) {
        gameState = UPGRADES;
        runs++;
        saveGame();
      }
      return true; 
    }
  }
  return false;
}

boolean ammoCollision() {
  if (rock.active && !rock.exploding) {    
    Iterator<Ammo> itr = ammo.iterator();
    while (itr.hasNext()) {
      Ammo a = itr.next();
      PVector distance = rock.position.get();
      distance.sub(a.position);
      if (distance.mag() < rock.radius) {
        // start rock explosion
        rock.exploding = true;
        itr.remove();
        coins++;
        return true;
      }
    }
  }
  return false;
}
