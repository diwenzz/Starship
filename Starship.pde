import g4p_controls.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

/*
5-24-2018
 Starship gmaes
 Verision 1.3 Alpha
 @Diwen Wang
 
 FINISHED:
 - Game state changes
 
 TO_DO: 
 - Boss attack
 - Enemy cancel when been attacked
 - Note
 - Sound effect
 */

//<System Variables>
int gameState = 1;  //starting game state
int gameLevel = 1;  //starting game level
int currentFrame = 0;  //current fame count 
PVector mouse;  //mouse vector
PFont font1;  //font of displaying title
PFont font2;  //font of displaying instruction
int score;  //game score
float ui1Width;  //width of the ui1 image
float ui1Height;  //height of the ui1 image

//<Starship Variables>
PVector sPos;  //ship position in game
PVector sDir;  //ship direction in game (Not used)
PVector velocity;  //ship moving velocity
int shield = 500;  //shield capacity
float sSpd = 20;  //ship moving speed
float sWidth = 96;  //ship image width
float sHeight = 128;  //ship image height
PImage shipS;  //loading the image of player ship from file

//<Turret Variables>
PVector tPos;  //turret position of the ship
PVector tDir;  //turret direction of the ship
PVector missilePos;  //missile bullet position
PVector [] missilePoss;  //**
PVector missileVel;  //missile bullet velocity
PVector [] missileVels;  //**
float missileSpeed = 10;  //missile bullet moving spped
float tSize = 60;  //turret size
float missileTWidth = 30;  //missile turret width
float missileTHeight = 29;  //missile turret height
float missileWidth = 33;  //missile width
float missileHeight = 137;  //missile height
PImage missileT;  //loading the image of missile turret from file
PImage missileB;  //loading the image of missile bullet from file

//<Enemy Variables>
PVector[] ePos;  //enemy positon
PVector[] eVel;  //enemy velocity

PVector bossMissilePosL;  //boss fired missile position
PVector[] bossMissilePossL;  //boss missile position
PVector bossMissileVelL;  //boss fired missile velocity
PVector[] bossMissileVelsL;  //boss missile velocity
PVector bossMissilePosR;  //boss fired missile position
PVector[] bossMissilePossR;  //boss missile position
PVector bossMissileVelR;  //boss fired missile velocity
PVector[] bossMissileVelsR;  //boss missile velocity

PVector bossPos;  //boss position
PVector bossTDirL;  //boss left turret direction
PVector bossTDirR;  //boss right turret direction
float eSpeed = 2;  //enemy speed
float bSpeed = 4;  //boss speed
float enemy01Width = 73;  //enemy01 image width
float enemy01Height = 54;   //enemy01 image height
float bossWidth = 388;  //boss image width
float bossHeight = 505;  //boss image height
float bossShield = 1000;  //boss health
int eneAimRate = 30;  //enemy aimming player rate
int spawnRate = 60;  //enemy spawn rate
int bossMoveRate = 1;  //boss moving rate
int numEne = 5;  //amount of the enemy
int eShield = 100;  //enemy shield amount
PImage enemy01;  //enemy image variables
PImage bossL;  //boss image variables

//<Image>
PImage gameBackground;  //loading game background from file
PImage bgShip;  //loading background ship from file
PImage bgUni;  //loading the background universe from file
PImage gameOverBackground;  //loading gameover background form file
PImage ui1;  //loading ui1 image from file

void setup() {  //basic game set-up

  fullScreen(P3D);
  frameRate(60);  //set fps to 60
  init();
  imageMode(CENTER);  //set image mode to center
}

void init() {  //initialize preload variables
  //<Background>
  bgUni = loadImage("background/backgroundU.png");  //loading the background universe from file
  bgUni.resize(displayWidth, displayHeight);
  gameBackground = loadImage("background/gamebackground.jpg");
  gameBackground.resize(displayWidth, displayHeight);
  gameOverBackground = loadImage("background/gameover.jpg");
  gameOverBackground.resize(displayWidth, displayHeight);

  //<Font>
  font1 = loadFont("HarlowSolid-48.vlw");
  font2 = loadFont("Corbel-BoldItalic-48.vlw");

  //<Ship>
  velocity = new PVector();  //declearing ship veolicity
  sPos = new PVector (width/2, height/2 + 300);  //declearing ship starting position
  tPos = new PVector (width/2, height/2);  //decleaing turret starting position
  shipS = loadImage("starship/ship_S.png");  //loading the image of player ship from file
  bgShip = loadImage("background/background1.png");  //loading background ship from file
  bgShip.resize(1098, 725);  //resize bgShip size to suitable size

  //<Turret>
  missileVel = new PVector();  //missile velocity
  missilePoss = new PVector[100];  
  missileVels = new PVector[100]; 
  missileT = loadImage("turret/missile/missile01.png");  //loading the image of missile turret from file
  missileB = loadImage("turret/missile/missile01_b.png");  //loading the image of missile bullet from file

  //<Enemy>
  bossPos = new PVector (width/2, 120);
  ePos = new PVector[numEne];  //each enemy position
  eVel = new PVector[numEne];  //each enemy velocity
  bossMissilePossL = new PVector[100];
  bossMissileVelsL = new PVector[100];
  bossMissilePossR = new PVector[100];
  bossMissileVelsR = new PVector[100];
  enemy01 = loadImage("enemy/enemy01.png");  //loading enemy01 image from file
  bossL = loadImage("boss/boss_L.png");  //loading boss_L image from file

  //<UI>
  ui1 = loadImage("UI/ui1.jpg");
  ui1Width = 564;
  ui1Height = 423;
}  //end of ini() function

void preGame() {  //loading pregame scene and bgm-->minim

  image(bgUni, width/2, height/2);  //display background image of universe
  image(bgShip, width/2, height/2);  //display background image of ship

  //text title
  fill(0, 150, 200);  //color blue
  textFont(font1, 100);  //font 1
  text("Starship", width/2 + 200, height/2 + 200);  //text game title
  textFont(font2, 70);  //font 2
  text("PRESS \'ENTER\' TO PLAY", width/2 - 100, height/2 + 350);  //text the information of the game
  startGame();  //start game when enter is clicked
}  //end of the pregame() function

void spawnBoss() {

  //<Variables>
  PVector bossLeftTurret = new PVector (bossPos.x - bossWidth * 15/112, bossPos.y - bossHeight/11);  //left turret x position variables
  PVector bossRightTurret = new PVector (bossPos.x + bossWidth * 15/112, bossPos.y - bossHeight/11);  //right turret x position variables
  //float bossMissileTurretY = bossPos.y - bossHeight/11;  //turret y position variables

  fill(0, 120, 120);
  image(bossL, bossPos.x, bossPos.y, bossWidth * 0.5, bossHeight * 0.5);  //loading boss image
  //ellipse(bossRightTurretX, bossMissileTurretY, 20, 20);
  //ellipse(bossLeftTurretX, bossMissileTurretY, 20, 20);

  //<Boss aimming player and fire>
  //Boss firing variables
  bossTDirL = PVector.sub(bossLeftTurret, tPos);
  bossTDirR = PVector.sub(bossRightTurret, tPos);
  bossTDirL.normalize();  //normalize left
  bossTDirR.normalize();  //normalize right
  bossTDirL.mult(tSize);  //scale left
  bossTDirR.mult(tSize);  //scale right
  //<Left Turret>
  if (bossMissilePosL != null) {//if the missile exist 
    bossMissilePosL.add(bossMissileVelL); //moves the bullet
    if (PVector.dist(bossLeftTurret, bossMissilePosL) > width) {//check if it is no longer on the screen    
      bossMissilePosL = null;//recycle this bullet
    }
  }  
  for (int i = 0; i < bossMissilePossL.length; i++) {
    if (bossMissilePossL[i] != null) {
      bossMissilePossL[i].add(bossMissileVelsL[i]); 
      if (PVector.dist(bossMissilePosL, bossMissilePossL[i]) > width) {
        bossMissilePossL[i] = null;
      }
    }
  }
  //draw the left boss missile when fire
  if (bossMissilePosL != null) {
    pushMatrix();  //start of matrix transformations
    translate(bossMissilePosL.x, bossMissilePosL.y);  //moves the origin to the turret position
    rotate(missileVel.heading() + HALF_PI);  //rotates the coordinate system by missile direction
    image(missileB, 0, 0, missileWidth * 0.8, missileHeight * 0.8);  //drawing missile fired
    popMatrix();  //undo all the transformations
  } 
  //rotate the boss left turret
  pushMatrix();  //start of matrix transformations
  translate(bossLeftTurret.x, bossLeftTurret.y);  //moves the origin to the turret position
  rotate(bossTDirL.heading() - HALF_PI);  //rotates the coordinate system by tDirection degrees
  image(missileT, 0, 0, missileTWidth * 1.5, missileTHeight * 1.5);  //drawing left missile turret
  image(missileB, 0, 0, missileWidth * 0.8, missileHeight * 0.8);  //drawing left missile on the turret
  popMatrix();  //undo all the transformations 

  //<Right Turret>
  if (bossMissilePosR != null) {//if the right missile exist 
    bossMissilePosR.add(bossMissileVelR); //moves the right boss missile 
    if (PVector.dist(bossRightTurret, bossMissilePosR) > width) {//check if it is no longer on the screen    
      bossMissilePosR = null;//recycle this bullet
    }
  }  
  for (int i = 0; i < bossMissilePossR.length; i++) {
    if (bossMissilePossR[i] != null) {
      bossMissilePossR[i].add(bossMissileVelsR[i]); 
      if (PVector.dist(bossMissilePosR, bossMissilePossR[i]) > width) {
        bossMissilePossR[i] = null;
      }
    }
  }

  //draw the right missile when fire
  if (bossMissilePosR != null) {
    pushMatrix();  //start of matrix transformations
    translate(bossMissilePosR.x, bossMissilePosR.y);  //moves the origin to the turret position
    rotate(missileVel.heading() + HALF_PI);  //rotates the coordinate system by missile direction
    image(missileB, 0, 0, missileWidth * 0.8, missileHeight * 0.8);  //drawing right missile when fired
    popMatrix();  //undo all the transformations
  } 

  //rotate the turret
  pushMatrix();  //start of matrix transformations
  translate(bossRightTurret.x, bossRightTurret.y);  //moves the origin to the turret position
  rotate(bossTDirR.heading() - HALF_PI);  //rotates the coordinate system by tDirection degrees
  image(missileT, 0, 0, missileTWidth * 1.5, missileTHeight * 1.5);  //drawing right missile turret
  image(missileB, 0, 0, missileWidth * 0.8, missileHeight * 0.8);  //drawing right missile on the right turret
  popMatrix();  //undo all the transformations

  //<Boss Turret Fire> <<<----------------------------------------UNDER TESTING------------------------------------------------->>>
  //if the left missile is null then it is available to be fired again
  if (bossMissilePosL == null) {
    bossMissilePosL = new PVector(bossLeftTurret.x, bossLeftTurret.y);//setting the bullets initial position to the turret position
    bossMissileVelL.set(bossTDirL);//get the direction the bullet should travel
    bossMissileVelL.normalize();//set the velocity to one so we can scale it
    bossMissileVelL.mult(missileSpeed);
    bossMissilePosL.add(bossTDirL);//makes the bullet starting position the end of the barrel
  }

  for (int i = 0; i < bossMissilePossL.length; i++) {
    if (bossMissilePossL[i] == null) {
      bossMissilePossL[i] = new PVector(bossLeftTurret.x, bossLeftTurret.y);
      bossMissileVelsL[i]= new PVector(bossTDirL.x, bossTDirL.y);
      bossMissileVelsL[i].normalize();
      bossMissileVelsL[i].mult(missileSpeed);
      return; //<==return this
    }
  }
}

void spawnEnemy() {  //spawning enemy, running when game() is called

  spawnBoss();
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

//<Enemy head towarding player>
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
}  // <<<initially game start function, due to bug not working right now>>>

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
      return; //<==return this
    }
  }
}  //end of mouseClicked() function

void game() {  //Playing state

  image(gameBackground, width/2, height/2);
  score = 0;  //set initial score to 0
  mouse = new PVector(mouseX, mouseY);  //declearing mouse vector variables

  //<SpawnEnemy and Drawing Enemy>
  spawnEnemy();
  for (int i = 0; i < ePos.length; i++) {
    //if the enemy exists
    if (ePos[i] != null) {
      //update enemy velocity
      eVel[i] = aim(ePos[i], tPos, eVel[i], eneAimRate);
      ePos[i].add(eVel[i]);
      image(enemy01, ePos[i].x, ePos[i].y, enemy01Width, enemy01Height);

      if (sPos.dist(ePos[i]) < (sWidth + enemy01Width)/2) {
        shield --;  //detect enemy ship hit player
      } 
      /*print(ePos[i].dist(missilePos), displayWidth/2, displayHeight/2);
       if (ePos[i].dist(missilePos) < (missileWidth + enemy01Width)/2) {
       print("Crashed");
       }*/      //    <<<Fix the enemy crashes>>>
    }  //end of drawing enemy
  }  //end of the ePos


  //<Drawing starship and turret>
  image(shipS, sPos.x, sPos.y, sWidth * 1.5, sHeight * 1.5);  //displaying the player ship image 

  //<Moving ship and restriction>
  if (keyPressed) {
  } 
  sPos.add(velocity);
  if (sPos.x >= width - sWidth/2) {
    sPos.x = width - sWidth/2;
  } else if (sPos.x <= 0 + sWidth/2) {
    sPos.x = 0 + sWidth/2;
  }  //limitation of x direction

  if (sPos.y >= height - sHeight/2) {
    sPos.y = height - sWidth/2;
  } else if (sPos.y <= 0 + sHeight/2) {
    sPos.y = 0 + sHeight/2;
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

  //fire cooldown
  textFont(font2, 20);
  text("Fire Cooldown", displayWidth - 140, displayHeight/2 - 60);  //text fire cooldown remind
  ellipse(displayWidth - 80, displayHeight/2, 80, 80);

  //<Hit detection>
  fill(0, 150, 200);
  rect(0, displayHeight/2 - shield/2, 30, shield);  //drawing health bar
  image(ui1, displayWidth - ui1Width/4, displayHeight - ui1Height/4, ui1Width * 0.6, ui1Height * 0.6 );  //drawing ui image

  if (sPos.dist(bossPos) < (sWidth + enemy01Width)/2) {
    shield -= 5;
  }  //boss hit detection

  //<Gamelevel>
  if (score >= 100) {
    gameLevel += 1;
  }

  //<Restart Game>
  if (shield <= 0) {
    gameState = 2;
  }
}  //end of the game() function

void gameOver() {  //loading gameover scene
  image(gameOverBackground, width/2, height/2);
  textFont(font1, 100);  //font 1
  text("Game Over", width/2 + 50, height/2 + 200);  //text game over
  textFont(font2, 70);  //font 2
  text("PRESS \'ENTER\' TO RESTART", width/2 - 200, height/2 + 350);  //text the information to restart the game

  //<Reset Variables>
  shield = 500;
  score = 0;
  gameLevel = 1;
  sPos = new PVector (width/2, height/2 + 300);  //re-declearing ship starting position
  tPos = new PVector (width/2, height/2);  //re-declearing turret starting position
  ePos = new PVector[numEne];  //re-declearing each enemy position
  eVel = new PVector[numEne];  //re-declearing each enemy velocity
  startGame();
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
