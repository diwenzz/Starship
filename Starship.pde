import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

/*
5-11-2018
 Starship gmaes
 @Diwen Wang
 TO_DO: 
 -moving ship
 -background music
 
 */


//<System Variables>
int gameState = 0;
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
int sSize = 100;  //ship size
int tSize = 20;  //turrent size
int shield = 200;  //shield capacity
int sSpdx = 0;  //ship x speed
int sSpdy = 0;  //ship y speed

//<Enemy Variables>
PVector ePos;  //enemy positon
PVector eVel;  //enemy velocity
int numEne = 1;  //amount of the enemy
float eSpeed = 2;  //
int eneAimRate = 30;
int spawnRate = 60;

//<Loot Variables>


void setup() {  //basic game set-up
  fullScreen(P3D);
  init();
  imageMode(CENTER);
}

void init() {  //initialize preload variables
  font1 = loadFont("HarlowSolid-48.vlw");
  font2 = loadFont("Corbel-BoldItalic-48.vlw");

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


  //if (gameNotPause) {  //if the game is not paused 

  //spawnEnemy and drawing enemy
  spawnEnemy();

  //drawing starship and turret
  PImage ship = loadImage("starship/ship01.png");  //loading the ship of player image
  //PImage turret = loadImage("turret/turret.png");  //loading the turret of the ship image
  image(ship, sPos.x, sPos.y, 192, 256);  //displaying the ship
  //image(turret, width/2, height/2, 300, 300);   //displaying the turret

  //moving ship
  if (keyPressed && key == 'W') {
    sPos.y -= 20;
  } else if (keyPressed && key == 'S') {
    sPos.y += 20;
  } else if (keyPressed && key == 'A') {
    sPos.x -= 20;
  } else if (keyPressed && key == 'D') {
    sPos.x += 20;
  }

  //hit detection


  //gamelevel
  //} else if (!gameNotPause) {  //if the game is paused
  //}
}

void gameOver() {  //loading gameover scene
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
