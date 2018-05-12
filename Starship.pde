/*
5-11-2018
 Starship gmaes
 @Diwen Wang
 TO_DO: 
 -Switching gamestate
 
 */


//<System Variables>
int gameState = 0;
int gameLevel = 1;
int currentFrame = 0;
PVector mouse; 
PFont font;

//<Starship Variables>
PVector tPos;  //turret position of the ship
PVector tDir;  //turret direction of the ship
PVector sPos;  //ship position in game
PVector sDir;  //ship direction in game (not necesary)
int sSize = 100;  //ship size
int tSize = 20;  //turrent size
int shield = 200;  //shield capacity

//<Enemy Variables>
PVector ePos;  //enemy positon
PVector eVel;  //enemy velocity
int numEne = 1;  //amount of the enemy
float eSpeed = 2;  //
int eneAimRate = 30;
int spawnRate = 60;

//<Loot Variables>


void setup() {  //basic game set-up
  fullScreen();
  init();
  imageMode(CENTER);
}

void init() {  //initialize preload variables
  font = loadFont("HarlowSolid-48.vlw");
  textFont(font, 70);
}

void preGame() {  //loading pregame scene and bgm-->minim

  PImage bgShip = loadImage("background/background1.png");
  PImage bgUni = loadImage("background/backgroundU.png");
  image(bgUni, 0, 0, width * 2, height * 2);  //background image of universe
  image(bgShip, width/2, height/2, 1098, 725);  //background image of ship

  fill(125);
  text("Starship", width/2 + 200, height/2 + 200);  
  text("Press \'ENTER\' to play", width/2 + 200, height/2 + 250, 30);  //text the information of the game 
  text(gameState, width/2 + 200, height/2 + 320);  //text the value of the game state 


  if (keyPressed && key == ENTER) {
    gameState += 1;
  }  //end of the 'if' key pressed
}  //end of the function pregame()

void spawnEnemy() {  //spawning enemy, running when game() is called
}

void mouseClicked() {
}

void game() {  //loading playing state
  boolean gameNotPause = true;  //check if the game was paused

  background (255);
  text(gameState, width/2 + 200, height/2 + 300);
  text(height, width/2, height/2);

  if (gameNotPause) {  //if the game is not paused 

    //spawnEnemy and drawing enemy
    spawnEnemy();

    //drawing starship and turret
    PImage ship = loadImage("starship/starship.png");  //loading the ship of player image
    PImage turret = loadImage("turret/turret.png");  //loading the turret of the ship image
    image(ship, 0, 0, 600, 600);  //displaying the ship
    image(turret, width/2, height/2, 300, 300);   //displaying the turret

    //hit detection


    //gamelevel
  } else if (!gameNotPause) {  //if the game is paused
  }
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
