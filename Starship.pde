import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

/*
5-16-2018
 Starship gmaes
 Verision 1.0 Alpha
 @Diwen Wang
 TO_DO: 
 -Check Hit
 -Boss
 */


//<System Variables>
int gameState = 1;  //starting game state
int gameLevel = 1;  //starting game level
int currentFrame = 0;  //current fame count 
PVector mouse;  //mouse vector
PFont font1;  //font of displaying title
PFont font2;  //font of displaying instruction

//<Starship Variables>
PVector sPos;  //ship position in game
PVector sDir;  //ship direction in game (not necesary)
PVector velocity;  //ship moving velocity
int shield = 200;  //shield capacity
float sSpd = 20;  //ship moving speed
float sWidth = 96;  //ship width
float sHeight = 128;  //ship height
PImage shipS;  //loading the image of player ship from file

//<Turret Variables>
PVector tPos;  //turret position of the ship
PVector tDir;  //turret direction of the ship
PVector missilePos;  //missile bullet position
PVector [] missilePoss;  //**
PVector missileVel;  //missile bullet velocity
PVector [] missileVels;  //**
float missileSpeed = 10;  //missile bullet moving spped
float tSize = 60;
float missileTWidth = 30;  //missile turret width
float missileTHeight = 29;  //missile turret height
float missileWidth = 33;  //missile width
float missileHeight = 137;  //missile height
PImage missileT;  //loading the image of missile turret from file
PImage missileB;  //loading the image of missile bullet from file

//<Enemy Variables>
PVector[] ePos;  //enemy positon
PVector[] eVel;  //enemy velocity
float eSpeed = 2;  //enemy speed
float enemy01Width = 73;
float enemy01Height = 54;
float bossWidth = 388;
float bossHeight = 505;
int eneAimRate = 30;  //enemy aimming player rate
int spawnRate = 60;  //enemy spawn rate
int numEne = 5;  //amount of the enemy
int eShield = 100;  //enemy shield amount
PImage enemy01;
PImage bossL;

//<Loot Variables>
int score;  //game score, gain score after eliminte enemy

//<Background>
PImage gameBackground;  //loading game background from file
PImage bgShip;  //loading background ship from file
PImage bgUni;  //loading the background universe from file

void setup() {  //basic game set-up

  fullScreen(P3D);
  frameRate(60);
  init();
  imageMode(CENTER);
  if (gameState == 0) {
    bgShip = loadImage("background/background1.png");  //loading background ship from file
    bgShip.resize(1098, 725);
    bgUni = loadImage("background/backgroundU.png");  //loading the background universe from file
    bgUni.resize(displayWidth, displayHeight);
  } else if (gameState == 1) {
    gameBackground = loadImage("background/gamebackground.jpg");
    gameBackground.resize(displayWidth, displayHeight);
  }
}

void init() {  //initialize preload variables

  //<Font>
  font1 = loadFont("HarlowSolid-48.vlw");
  font2 = loadFont("Corbel-BoldItalic-48.vlw");

  //<Ship>
  velocity = new PVector();  //declearing ship veolicity
  sPos = new PVector (width/2, height/2);  //declearing ship starting position
  tPos = new PVector (width/2, height/2);
  shipS = loadImage("starship/ship_S.png");  //loading the image of player ship from file
  
  //<Turret>
  missileVel = new PVector();  
  missilePoss = new PVector[100];
  missileVels = new PVector[100]; 
  missileT = loadImage("turret/missile/missile01.png");  //loading the image of missile turret from file
  missileB = loadImage("turret/missile/missile01_b.png");  //loading the image of missile bullet from file
  
  //<Enemy>
  ePos = new PVector[numEne];
  eVel = new PVector[numEne];
  enemy01 = loadImage("enemy/enemy01.png");
  bossL = loadImage("boss/boss_L.png");
}  //end of ini() function

void preGame() {  //loading pregame scene and bgm-->minim

  image(bgUni, width/2, height/2);  //display background image of universe
  image(bgShip, width/2, height/2);  //display background image of ship

  //text title
  fill(0, 150, 200);
  textFont(font1, 100);
  text("Starship", width/2 + 200, height/2 + 200);
  textFont(font2, 70);
  text("PRESS \'ENTER\' TO PLAY", width/2 - 100, height/2 + 350);  //text the information of the game
  startGame();
}  //end of the pregame() function

void spawnEnemy() {  //spawning enemy, running when game() is called
  
  
  image(bossL, width/2, 120, bossWidth * 0.5, bossHeight * 0.5);
  //if the framerate is 60*n, spawn enemy   
  if (frameCount % spawnRate == 0) {
    //scan the array looking for avaiable one
    for (int i = 0; i < ePos.length; i++) {
      //if null then construct
      if (ePos[i] == null) {
        PVector temp = PVector.random2D();  //spawn random vetor on the unit circle
        temp.mult(width/2);   //scale the unit circle up to the size of the screen
        temp.add(tPos);  //translate the center of the circle to the center of the screen
        ePos[i] = temp;  //set the enemy array to the temp array
        //enemy aims player
        eVel[i] = aim(ePos[i], tPos, null, 1);
        return;  //return the values
      }
    }
  }
}  //end of the spawnEnemy() function

//<Enemy aiming player>
PVector aim(PVector ePos, PVector tPos, PVector vel, int aimRate) {
  if (frameCount % aimRate == 0) {
    //enemy aims player
    PVector temp = PVector.sub(tPos, ePos);
    temp.normalize();
    return temp.mult(eSpeed);
  }
  return vel;
}  //end of enemy aiming player

void keyPressed() {
  moveShip();
  startGame();
}  //end of the keyPressed() function

void startGame() {
  if (key == ENTER) {
    gameState = 1;
  }
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
}  //end of moveship() function

void keyReleased() {

  if (key == 'W' || key == 'w' || key == 'S' || key == 's') {
    velocity.y = 0;
  } else if (key == 'A' || key == 'a' || key == 'D' || key == 'd') {
    velocity.x = 0;
  }
}  //end of keyReleased() function

void mouseClicked() {

  //if the bullet is null then it is available to be fired again
  if (missilePos == null) {
    missilePos = new PVector(tPos.x, tPos.y);//setting the bullets initial position to the turret position
    missileVel.set(tDir);//get the direction the bullet should travel
    missileVel.normalize();//set the velocity to one so we can scale it
    missileVel.mult(missileSpeed);
    missilePos.add(tDir);//makes the bullet starting position the end of the barrel
  }

  for (int i = 0; i < missilePoss.length; i++) {
    if (missilePoss[i] == null) {
      missilePoss[i] = new PVector(tPos.x, tPos.y);
      missileVels[i]= new PVector(tDir.x, tDir.y);
      missileVels[i].normalize();
      missileVels[i].mult(missileSpeed);
      //make this better
      return; //<==this
    }
  }
}  //end of mouseClicked() function

boolean checkHit(PVector pos1, float size1, PVector pos2, float size2) {
  return PVector.dist(pos1, pos2) < (size1 + size2)/2;
}  //check hit, not done yet

void game() {  //Playing state
  image(gameBackground, width/2, height/2);
  score = 0;  //set initial score to 0
  mouse = new PVector(mouseX, mouseY);  //declearing mouse vector variables

  //<SpawnEnemy and drawing enemy>
  spawnEnemy();
  for (int i = 0; i < ePos.length; i++) {
    //if the enemy exists
    if (ePos[i] != null) {
      //update enemy velocity
      eVel[i] = aim(ePos[i], tPos, eVel[i], eneAimRate);
      ePos[i].add(eVel[i]);
      image(enemy01, ePos[i].x, ePos[i].y, enemy01Width, enemy01Height);

      /*
      //not working 
       pushMatrix();  //start of matrix transformations
       translate(ePos[i].x, ePos[i].y);  //moves the origin to the turret position
       rotate(eVel[i].heading() + HALF_PI);  //rotates the coordinate system by tDirection degrees
       image(enemy01, ePos[i].x, ePos[i].y, enemy01Width * 1.5, enemy01Height * 1.5);
       popMatrix();  //undo all the transformations
       */
    }  //end of drawing enemy
  }  //end of the ePos


  //<Drawing starship and turret>
  image(shipS, sPos.x, sPos.y, sWidth * 1.5, sHeight * 1.5);  //displaying the player ship image 

  //<Moving ship>
  if (keyPressed) {
  } 
  sPos.add(velocity);
  if (sPos.x >= width) {
    sPos.x = width;
  } else if (sPos.x <= 0) {
    sPos.x = 0;
  }  //limitation of x direction

  if (sPos.y >= height) {
    sPos.y = height;
  } else if (sPos.y <= 0) {
    sPos.y = 0;
  }  //limitation of y direction

  tPos = new PVector (sPos.x, sPos.y);  //making the turrert position follows the ship position

  //<Ship fire>
  tDir = PVector.sub(mouse, tPos);
  tDir.normalize();
  tDir.mult(tSize);  //?
  if (missilePos != null) {//if the bullet exist 
    missilePos.add(missileVel); //moves the bullet
    if (PVector.dist(tPos, missilePos) > width) {//if it is no longer on the screen     
      missilePos = null;//recycle this bullet
    }
  }  
  for (int i = 0; i < missilePoss.length; i++) {
    if (missilePoss[i] != null) {
      missilePoss[i].add(missileVels[i]); 
      if (PVector.dist(tPos, missilePoss[i]) > width) {
        missilePoss[i] = null;
      }
    }
  }

  //draw the missile when fire
  if (missilePos != null) {
    fill(255, 255, 0);
    pushMatrix();  //start of matrix transformations
    translate(missilePos.x, missilePos.y);  //moves the origin to the turret position
    rotate(missileVel.heading() + HALF_PI);  //rotates the coordinate system by missile direction
    image(missileB, 0, 0, missileWidth * 0.8, missileHeight * 0.8);  //drawing missile fired
    popMatrix();  //undo all the transformations
  } 

  //rotate the turret
  pushMatrix();  //start of matrix transformations
  translate(tPos.x, tPos.y);  //moves the origin to the turret position
  rotate(tDir.heading() + HALF_PI);  //rotates the coordinate system by tDirection degrees
  image(missileT, 0, 0, missileTWidth * 1.5, missileTHeight * 1.5);  //drawing missile turret
  image(missileB, 0, 0, missileWidth * 0.8, missileHeight * 0.8);  //drawing missile on the turret
  popMatrix();  //undo all the transformations 

  //<Gamelevel>
  if (score >= 100) {
    gameLevel += 1;
  }
}  //end of the game() function

void gameOver() {  //loading gameover scene

  if (shield <= 0) {
    gameState = 0;
    gameLevel = 1;
    shield = 200;
    score = 0;
  }
}  //end of gameover function

void draw() {  //running all functions

  if (gameState == 0) {
    preGame();
  } else if (gameState == 1) {
    game();
  } else if (gameState == 2) {
    gameOver();
  }
}  //end of the main draw function
