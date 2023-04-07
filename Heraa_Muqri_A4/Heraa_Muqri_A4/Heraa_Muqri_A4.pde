/**************************
 * Heraa Muqri             *
 *                         *
 * Heraa_Muqri_A4.pde      *
 *                         *
 * ICS 3U1 - Assignment 4  *
 *                         *
 *Space Invaders Assignment*
 * A program that runs a   *
 * pong game using various *
 * methods, loops, and if  *
 * statements.             *
 *                         *
 * December 18, 2020        *
 **************************/

int gameState = 1; 
PFont font, font2, font3;
int score = 0;
int timer = 200;
PImage alien, tank, spaceship;
// Alien Variables.
int numberOfRows = 3;
int numberOfColumns = 7;
int [][] alienXPositions = new int [numberOfRows][numberOfColumns];
int [][] alienYPositions = new int [numberOfRows][numberOfColumns];
//boolean pinkAlien1 = true, pinkAlien2 = true, pinkAlien3 = true, pinkAlien4 = true, pinkAlien5 = true, pinkAlien6 = true, pinkAlien7 = true;
//boolean blueAlien1 = true, blueAlien2 = true, blueAlien3 = true, blueAlien4 = true, blueAlien5 = true, blueAlien6 = true, blueAlien7 = true;
//boolean yellowAlien1 = true, yellowAlien2 = true, yellowAlien3 = true, yellowAlien4 = true, yellowAlien5 = true, yellowAlien6 = true, yellowAlien7 = true;
boolean [] pinkAlienOnScreen = new boolean [7]; // declaring an array and its size
//boolean [] pinkAlienOnScreen = {pinkAlien1, pinkAlien2, pinkAlien3}; // declaring an array and its size
boolean [] blueAlienOnScreen = new boolean [7]; // declaring an array and its size
boolean [] yellowAlienOnScreen = new boolean [7]; // BOOLEAN SWITCH FOR DETERMINING IF YELLOW ALIEN IS ON THE SCREEN OR OFF.
boolean [] blueAlienHit = new boolean [7];
boolean [] yellowAlienHit = new boolean [7];
boolean [] pinkAlienHit = new boolean [7]; // BOOLEAN SWITCH FOR DETERMINING IF PINK ALIEN GOT HIT BY THE LASER.
int stopwatchAlien = 0;
int alienXSpeed = 3;
boolean alienHitRightEdge = false;
// Tank Variables.
int tankXPosition = 300, tankYPosition = 550;
int tankXSpeed = 10;
boolean tankRight = false, tankLeft = false;
// Spaceship Variables.
int spaceshipXPosition = 300, spaceshipYPosition = 65;
int spaceshipXSpeed = 8;
// Laser Variables.
boolean laserOnScreen = false;
int laserX, laserY;
int x1 = 300, y1 = 550, x2 = 300, y2 = 540;

void setup () {
  size (600, 600);
  imageMode (CENTER); //
  font = loadFont ("Impact-48.vlw");
  font2 = loadFont ("LucidaConsole-48.vlw");
  font3 = loadFont ("Bahnschrift-48.vlw");
  setVariables ();
}

void draw () {
  if (gameState == 1) {
    welcomeScreen ();
  } else if (gameState == 2) {
    instructionsScreen ();
  } else if (gameState == 3) {
    background (#000000);
    spaceship ();
    moveSpaceship ();
    checkSpaceshipHitEdge ();
    drawAliensAndCheckCollision ();
    moveAliens ();
    moveLaser ();
    for (int columns = 0; columns < alienXPositions[0].length; columns++) {
      for (int rows = 0; rows < alienYPositions.length; rows++) {
        checkLaserHitAlien (rows, columns);
      }
    }
    tank (tankXPosition, tankYPosition);
    moveTank ();
    checkTankHitEdge ();
    scoreDisplay ();
    timerDisplay ();
    //endGameScreen ();
  }
}

void welcomeScreen () {
  background (#000000);
  fill (#ffffff);
  textFont (font, 90);
  text ("S P A C E", 150, 200);
  text ("I N V A D E R S", 45, 365);
  textFont (font3, 25);
  text ("PRESS the spacebar to load the instructions!", 50, 550);
}

void instructionsScreen () {
  background (#000000);
  textFont (font, 50);
  text ("INSTRUCTIONS", 165, 85);
  textFont (font2, 20);
  text ("Use the right and left keys to move the tank.", 30, 125);
  text ("Use the up arrow key to shoot the aliens.", 25, 175);
  text ("The BLUE aliens are worth 10 points!", 25, 225);
  text ("The PINK aliens are worth 20 points!", 25, 275);
  text ("The YELLOW aliens are worth 30 points!", 25, 325);
  text ("The SPACESHIP is worth a random number of points!", 20, 375);
  text ("The OBJECTIVE of the game is to shoot the aliens", 5, 425);
  text ("and spaceship BEFORE they reach the tank or else GAME OVER.", 5, 450);
  textFont (font3, 25);
  text ("PRESS the enter key to load the game!", 85, 550);
}

void setVariables () {
  for (int rows = 0; rows < alienXPositions.length; rows++) {
    for (int columns = 0; columns < alienYPositions[0].length; columns++) {
      alienXPositions[rows][columns] = 100 + 50*columns;
      alienYPositions[rows][columns] = 100 + 50*rows;
      blueAlienOnScreen [columns] = true; // sets all the boolean switches for all the BLUE ALIENS to TRUE.
      pinkAlienOnScreen [columns] = true; // sets all the boolean switches for all the PINK ALIENS to TRUE.
      yellowAlienOnScreen [columns] = true; // sets all the boolean switches for all the YELLOW ALIENS to TRUE.
    }
  }
}

void drawAliensAndCheckCollision () {
  //if (pinkAlien1 == true || pinkAlien2 == true || pinkAlien3 == true || pinkAlien4 == true || pinkAlien5 == true || pinkAlien6 == true || pinkAlien7 == true || blueAlien1 == true || blueAlien2 == true || blueAlien3 == true || blueAlien4 == true || blueAlien5 == true || blueAlien6 == true || blueAlien7 == true || yellowAlien1 == true || yellowAlien2 == true || yellowAlien3 == true || yellowAlien4 == true || yellowAlien5 == true || yellowAlien6 == true || yellowAlien7 == true) {
  for (int rows = 0; rows < alienXPositions.length; rows++) {
    for (int columns = 0; columns < alienYPositions[0].length; columns++) {
      int alienRight = alienXPositions [rows][columns] + 15; // dummy variable to act as the right side of all aliens.
      int alienLeft = alienXPositions [rows][columns] - 15; // dummy variable to act as the left side of all aliens.
      alien = loadImage ("alien1.jpg"); 
      //image (alien, alienXPositions [0][columns], alienYPositions[0][0]);
      if (blueAlienOnScreen [columns] == true) {
        image (alien, alienXPositions [0][columns], alienYPositions[0][0]); // THIS IS THE SAME AS image (alien, alienXPositions [1][columns], alienYPositions[rows][0]);.
      }
      if (alienYPositions [rows][columns] == alienYPositions [1][columns]) { // CHANGE THIS CONDITION AND ADD IN BOOLEAN EXP.
        alien = loadImage ("alien2.jpg");
        //image (alien, alienXPositions [1][columns], alienYPositions[1][0]); // THIS IS THE SAME AS image (alien, alienXPositions [1][columns], alienYPositions[rows][0]);.
        if (pinkAlienOnScreen [columns] == true) {
          image (alien, alienXPositions [1][columns], alienYPositions[1][0]); // THIS IS THE SAME AS image (alien, alienXPositions [1][columns], alienYPositions[rows][0]);.
        }
        //if (blueAlienOnScreen [1] == true) {

        //}
        //if (blueAlienOnScreen [2] == true) {

        //}
      } else if (alienYPositions [rows][columns] == alienYPositions [2][columns]) {
        alien = loadImage ("alien3.jpg");
        //image (alien, alienXPositions [2][columns], alienYPositions[rows][0]);
        if (yellowAlienOnScreen [columns] == true) {
          image (alien, alienXPositions [2][columns], alienYPositions[rows][0]); // THIS IS THE SAME AS image (alien, alienXPositions [1][columns], alienYPositions[rows][0]);.
        }
      }
      if (alienRight > width) {
        alienHitRightEdge = true;
      } else if (alienLeft < 15) {
        alienXSpeed = abs (alienXSpeed); // CHANGES THE DIRECTION OF THE ALIENS TO RIGHT IF THEY REACH THE LEFT EDGE.
      }
    }
  } 
  if (alienHitRightEdge) {
    for (int rows = 0; rows < alienXPositions.length; rows++) {
      for (int columns = 0; columns < alienYPositions[0].length; columns++) {
        alienYPositions [rows][0] += 10; // MAKES ALIENS MOVE DOWN 25 PIXELS
        alienXPositions [rows][columns] -= 10; // MAKES THE ALIENS MOVE A LITTLE TO THE RIGHT AFTER THEY REACH THE EDGE AND DROP DOWN
        alienXSpeed = -abs (alienXSpeed); // CHANGES THE DIRECTION OF THE ALIENS TO LEFT IF THEY REACH THE RIGHT EDGE
      }
    }
    alienHitRightEdge = false;
  }
  // }
}

void moveAliens () { // 
  if (millis() - stopwatchAlien > 500) { // IF ONE MILLISECOND HAS PASSED SINCE THE PROGRAM BEGAN ON THE GAME SCREEN PAGE, SET THE TIMER TO 1 MILLISECOND.
    stopwatchAlien = millis();
    for (int columns = 0; columns < alienXPositions[0].length; columns++) {
      for (int rows = 0; rows < alienYPositions.length; rows++) {
        alienXPositions [rows][columns] += alienXSpeed*10;
      }
    }
  }
}

void checkLaserHitAlien (int rows, int columns) { // CHANGE alienIDNumber1 and 2 TO --> rows and columns and call the method inside a for loop.
  int alienBottom = alienYPositions [rows][columns] - 15;
  int alienTop = alienYPositions [rows][columns] + 15;
  int alienRight = alienXPositions [rows][columns] + 15;
  int alienLeft = alienXPositions [rows][columns] - 15;
  int laserTop = laserY - 15;
  int laserBottom = laserY;
  int laserSides = laserX;
  if (laserOnScreen) {
    if (laserTop > alienBottom && laserSides > alienLeft && laserSides < alienRight) { // 
      if (alienYPositions [rows][columns] == alienYPositions[0][0] && alienXPositions [rows][columns] == alienXPositions[0][0]) {
        //blueAlienHit [1] = true;
        //blueAlienOnScreen [1] = false;
        blueAlienOnScreen [columns] = false;
      }
      if (alienYPositions [rows][columns] == alienYPositions[0][0] && alienXPositions [rows][columns] == alienXPositions[0][0]) {
        //pinkAlienHit [1] = true;
        //pinkAlienOnScreen [1] = false;
        pinkAlienOnScreen [columns] = false;
      }
      if (alienYPositions [rows][columns] == alienYPositions[0][0] && alienXPositions [rows][columns] == alienXPositions[0][0]) {
        //yellowAlienHit [1] = true;
        //yellowAlienOnScreen [1] = false;
        yellowAlienOnScreen [columns] = false;
      }
    }
    score++ ;
  }
}

void spaceship () {
  spaceship = loadImage ("spaceship.jpg");
  image (spaceship, spaceshipXPosition, spaceshipYPosition);
}

void moveSpaceship () {
  spaceshipXPosition += spaceshipXSpeed;
}

void checkSpaceshipHitEdge () {
  int spaceshipRight = spaceshipXPosition + 10;
  int spaceshipLeft = spaceshipXPosition - 10;
  if (spaceshipRight > width) {
    spaceshipXSpeed = -abs (spaceshipXSpeed);
  }
  if (spaceshipLeft < 20) {
    spaceshipXSpeed = abs (spaceshipXSpeed);
  }
}

void tank (int xPosition, int yPosition) {
  tank = loadImage ("tank.png");
  image (tank, xPosition, yPosition);
}

void moveTank () {
  if (tankRight) {
    tankXPosition += tankXSpeed;
  }
  if (tankLeft) {
    tankXPosition -= tankXSpeed;
  }
}

void checkTankHitEdge () {
  int tankRightSide = tankXPosition + 30;
  int tankLeftSide = tankXPosition - 30;
  if (tankRightSide > width) {
    tankXPosition = 570;
  } else if (tankLeftSide < 0) {
    tankXPosition = 30;
  }
}

void scoreDisplay () {
  text ("SCORE: " + score, 250, 30);
}

void timerDisplay () {
  textSize (20);
  text ("T I M E R: " + (timer - millis ()/1000), 155, 50);
}

void drawLaser () {
  strokeWeight (10);
  stroke (#ff0000);
  line(laserX, laserY, laserX, laserY - 15);
}

void moveLaser () {
  if (laserOnScreen) {
    drawLaser();
    laserY -= 15;
  }
  if (laserY < 0) {
    laserOnScreen = false;
  }
}

void gameLevelScreen () {
  background (#000000);
  text ("CHOOSE A LEVEL", 185, 150);
  text ("Easy Mode A LEVEL", 185, 150);
  text ("PRESS '1' for easy mode.", 185, 150);
  text ("Hard Mode", 185, 150);
  text ("PRESS '2' for hard mode.", 185, 150);
}

void winCondition () {
}
/*
void endGameScreen () {
 background (#000000);
 if (alienYPosition [2] >= 500 || alienYPosition [1] >= 450 || alienYPosition [0] >= 400) {
 text ("G A M E  O V E R", 250, 300);
 text ("THE ALIENS HAVE INVADED YOU!", 250, 300);
 text ("PRESS the enter key to restart the game!", 300, 300);
 }
 }
 */

void keyPressed () {
  if (gameState == 1) {
    if (keyCode == 32) { // SPACEBAR KEY TO LAUNCH INSTRUCTIONS SCREEN
      gameState = 2;
    }
  } else if (gameState == 2) {
    if (keyCode == 10) { // ENTER KEY TO LOAD GAME SCREEN
      gameState = 3;
    }
  } else if (gameState == 3) {
    if (keyCode == 39) { // move the tank to the right if RIGHT KEY is pressed.  
      tankRight = true;
    } 
    if (keyCode == 37) { // move the tank to the left if LEFT KEY is pressed. 
      tankLeft = true;
    }
    if (keyCode == 38 && laserOnScreen == false) { // move the laser if UP KEYis pressed and laser is NOT on screen. 
      laserOnScreen = true;
      laserX = tankXPosition;
      laserY = tankYPosition;
    }
  }
}

void keyReleased () {
  if (keyCode == 39) { // stops the tank from moving to the right if RIGHT KEY is released.
    tankRight = false;
  } 
  if (keyCode == 37) { // stops the tank from moving to the left if LEFT KEY is released.
    tankLeft = false;
  }
}
