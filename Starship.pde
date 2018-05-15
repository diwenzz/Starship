import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

/*
5-14-2018
 Starship gmaes
 @Diwen Wang
 TO_DO: 
 -moving ship
 -spawn enemy and detect hit
 -score chech
 
 */


//<System Variables>
int gameState = 1;
int gameLevel = 1;
int currentFrame = 0;
PVector mouse; 
PFont font1;
PFont font2;

//<Starship Variables>
PVector tPos;  //turret position of the ship
PVector tDir;  //turret direction of the ship
PVector sPos;  //ship position in game
PVector sDir;  //ship direction in game (not necesary)
PVector velocity;
int sSize = 100;  //ship size
int tSize = 20;  //turrent size
int shield = 200;  //shield capacity
float sSpd = 20;

//<Enemy Variables>
PVector ePos;  //enemy positon
PVector eVel;  //enemy velocity
int numEne = 1;  //amount of the enemy
float eSpeed = 2;  //
int eneAimRate = 30;
int spawnRate = 60;

//<Loot Variables>
int score;

void setup() {  //basic game set-up
  fullScreen(P3D);
  init();
  imageMode(CENTER);
}

void init() {  //initialize preload variables
  font1 = loadFont("HarlowSolid-48.vlw");
  font2 = loadFont("Corbel-BoldItalic-48.vlw");
  
  velocity = new PVector();
  sPos = new PVector (width/2, height/2);
}

void preGame() {  //loading pregame scene and bgm-->minim

  PImage bgShip = loadImage("background/background1.png");
  PImage bgUni = loadImage("background/backgroundU.png");
  image(bgUni, 0, 0, width * 2, height * 2);  //background image of universe
  image(bgShip, width/2, height/2, 1098, 725);  //background image of ship

  fill(0, 150, 200);
  textFont(font1, 100);
  text("Starship", width/2 + 200, height/2 + 200);
  textFont(font2, 70);
  text("PRESS \'ENTER\' TO PLAY", width/2 - 100, height/2 + 350);  //text the information of the game 

  if (keyPressed && key == ENTER) {
    gameState += 1;
  }  //end of the 'if' key pressed
}  //end of the function pregame()

void spawnEnemy() {  //spawning enemy, running when game() is called
}

void keyPressed() {
  moveShip();
}

void moveShip() {
  //moving ship
  if (key == 'W' || key == 'w') {
    velocity.y = - sSpd;
  } else if (key == 'S' || key == 's') {
    velocity.y =  sSpd;
  }
  
  if (key == 'A' || key == 'a') {
    velocity.x = - sSpd;
  } else if (key == 'D' || key == 'd') {
    velocity.x = sSpd;
  }
  fill(0);
  text(sPos.x, 100, 100);
  text(sPos.y, 100, 150);
}

void keyReleased(){
  if (key == 'W' || key == 'w' || key == 'S' || key == 's'){
    velocity.y = 0;
  }
  if (key == 'A' || key == 'a' || key == 'D' || key == 'd'){
    velocity.x = 0;
  }
}

void mouseClicked() {
}

void checkHit() {
}

boolean checkHit(PVector pos1, float size1, PVector pos2, float size2) {
  return PVector.dist(pos1, pos2) < (size1 + size2)/2;
}  //check hit, not done yet

void game() {  //loading playing state
  //boolean gameNotPause = true;  //check if the game was paused

  background (255);
  score = 0;

  //if (gameNotPause) {  //if the game is not paused 

  //spawnEnemy and drawing enemy
  spawnEnemy();

  //drawing starship and turret
  PImage shipS = loadImage("starship/ship_S.png");  //loading the ship of player image
  //PImage turret = loadImage("turret/turret.png");  //loading the turret of the ship image
  image(shipS, sPos.x, sPos.y, 192, 256);  //displaying the ship
  //image(turret, width/2, height/2, 300, 300);   //displaying the turret
  keyPressed();
  
  sPos.add(velocity);

  //hit detection


  //gamelevel
  //} else if (!gameNotPause) {  //if the game is paused
  //}
}

void gameOver() {  //loading gameover scene
  if (shield <= 0) {
    gameState = 0;
    shield = 200;
    score = 0;
  }
}  

void draw() {  //running all functions

  if (gameState == 0) {
    preGame();
  } else if (gameState == 1) {
    game();
  } else if (gameState == 2) {
    gameOver();
  }  //end of gameState 'if' statement
}  //end of the main draw function
