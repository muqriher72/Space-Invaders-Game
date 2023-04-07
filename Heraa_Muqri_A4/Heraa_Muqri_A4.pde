/**************************
 * Heraa Muqri             *
 *                         *
 * Heraa_Muqri_A4.pde      *
 *                         *
 * ICS 3U1 - Assignment 4  *
 *                         *
 *Space Invaders Assignment*
 * A program that runs a   *
 * space invaders game     *
 * using various methods,  *
 * loops, if statements,   *
 * and different arrays.   *
 *                         *
 * January 6, 2020         *
 **************************/
// General Variables.
int gameState = 1; 
PFont font, font2, font3;
int score = 0;
int easyLevelLives = 3;
int hardLevelLives = 1;
int level = 0;
PImage[] alien = new PImage[3];
PImage tank, spaceship;
boolean gameOver = false;

// Alien Variables.
int numberOfRows = 3;
int numberOfColumns = 7;
int [][] alienXPositions = new int [numberOfRows][numberOfColumns];
int [][] alienYPositions = new int [numberOfRows][numberOfColumns];
int[][] alienHealth = new int [numberOfRows][numberOfColumns]; 
int numberOfTimesAliensHit = 0;
int stopwatchAlien = 0; 
int alienXSpeed = 3;
boolean alienHitRightEdge = false;
int movement = 0;

// Tank Variables.
int tankXPosition = 300, tankYPosition = 550;
int tankXSpeed = 10;
boolean tankRight = false, tankLeft = false;

// Tank Laser Variables.
boolean laserOnScreen = false;
int laserX, laserY;

// Spaceship Variables.
int spaceshipXPosition = 300, spaceshipYPosition = 65;
int spaceshipXSpeed = 8;
boolean spaceshipOnScreen = true;

// Spaceship Laser Variables.
int spaceshipLaserX, spaceshipLaserY;
boolean spaceshipLaserOnScreen = false;
boolean spaceShipFiring = false;

void setup () { // runs code inside ONCE.
  size (600, 600);
  imageMode (CENTER); 
  font = loadFont ("Impact-48.vlw");
  font2 = loadFont ("LucidaConsole-48.vlw");
  font3 = loadFont ("Bahnschrift-48.vlw");
  alien[0] = loadImage ("alien1.jpg"); 
  alien[1] = loadImage ("alien2.jpg");
  alien[2] = loadImage ("alien3.jpg");
  setVariables ();
}

void draw () { // runs code inside in a LOOP.
  if (gameState == 1) { // welcome screen
    welcomeScreen ();
  } else if (gameState == 2) { // instruction screen 1
    instructionsScreenOne ();
  } else if (gameState == 3) { // instruction screen 2
    instructionsScreenTwo ();
  } else if (gameState == 4) { // game level screen
    gameLevelScreen ();
  } else if (gameState == 5) { // game screen
    drawSpaceship ();
    moveSpaceship ();
    checkSpaceshipHitEdgeAndSpaceshipLaserSetup (); // method to kee the spaceship on the screen and setup the laser it shoots under a specific condition.
    checkTankLaserHitSpaceship ();
    livesDisplay ();
    drawAliensAndCheckCollision (); // method to draw the aliens, keep them on the screen, make them move down the screen and check if the laser hit them.
    moveAliens (); // method to move the aliens horizontally and vertically
    moveLaser ();
    tank (tankXPosition, tankYPosition); // method to draw the green tank.
    moveTank ();
    checkTankHitEdge ();
    checkSpaceshipLaserHitTank (); // method to check if the laser shot by the spaceship hit the green tank.
    scoreDisplay ();
  } else if (gameState == 6) { // Game Over Screen 1 displayed when player LOSES.
    background (#000000);
    text ("G A M E  O V E R", 215, 250);
    text ("YOU LOST!", 235, 300);
    text ("PRESS the backspace key to restart the game!", 50, 350);
    gameOver = true;
    noLoop (); // stops the draw loop from executing the code inside of it.
  } else if (gameState == 7) { // Game Over Screen 2 displayed when player WINS.
    background (#000000);
    text ("G A M E  O V E R", 215, 250);
    text ("YOU WON!", 235, 300);
    text ("PRESS the backspace key to restart the game!", 50, 350);
    gameOver = true;
    noLoop (); // stops the draw loop from executing the code inside of it.
  }
}

void setVariables () { // method that sets the variables/ boolean switches to their initial values or states.
  for (int rows = 0; rows < alienXPositions.length; rows++) { // loop for the rows of the aliens which starts at 0, increases by 1 and runs 3 times.
    for (int columns = 0; columns < alienYPositions[0].length; columns++) { // loop for the columns of the aliens which starts at 0, increases by 1 and runs 7 times.
      alienXPositions[rows][columns] = 100 + 50*columns;
      alienYPositions[rows][columns] = 100 + 50*rows;
      alienHealth [0][columns] = 3; // alien health set to 3 for BLUE ALIENS.
      alienHealth [1][columns] = 2; // alien health set to 2 for PINK ALIENS.
      alienHealth [2][columns] = 1; // alien health set to 1 for YELLOW ALIENS.
    }
  }
  score = 0;
  easyLevelLives = 3;
  hardLevelLives = 1;
  numberOfTimesAliensHit = 0; // variable to store the number of times all aliens have been hit in total.
  livesDisplay ();
  laserOnScreen = false;
  spaceshipOnScreen = true;
  gameOver = false;
  movement = 0; // variable to store the number of times the aliens have shifted positions.
  spaceShipFiring = false;
}

void welcomeScreen () { // draws the welcome screen.
  background (#000000);
  fill (#ffffff);
  textFont (font, 90);
  text ("S P A C E", 150, 200);
  text ("I N V A D E R S", 45, 365);
  textFont (font3, 25);
  text ("PRESS the spacebar to load the instructions!", 50, 550);
}

void instructionsScreenOne () { // draws the FIRST instructions screen.
  background (#000000);
  textFont (font, 50);
  text ("INSTRUCTIONS", 165, 85);
  textFont (font2, 20);
  text ("Use the right and left keys to move the tank.", 30, 150);
  text ("Use the up arrow key to shoot the aliens.", 55, 200);
  text ("The BLUE aliens are worth 30 points!", 80, 260);
  text ("The BLUE aliens need to be shot 3 times to die.", 25, 285);
  text ("The PINK aliens are worth 20 points!", 80, 340);
  text ("The PINK need to be shot 2 times to die.", 80, 365);
  text ("The YELLOW aliens are worth 10 points!", 65, 415);
  text ("The YELLOW need to be shot 1 time to die.", 65, 440);
  text ("The SPACESHIP is randomly worth 50 - 100 points!", 15, 490);
  textFont (font3, 25);
  text ("PRESS the enter key to load more instructions!", 35, 550);
}

void instructionsScreenTwo () { // draws the SECOND instructions screen.
  background (#000000);
  textFont (font, 50);
  text ("INSTRUCTIONS", 165, 85);
  textFont (font2, 20);
  text ("In Easy Level, the tank has 3 lives.", 85, 150);
  text ("In Hard Level, the tank has 1 life.", 85, 220);
  text ("The spaceship shoots lasers towards the tank.", 25, 290);
  text ("If tank has 0 lives left, then GAME OVER.", 55, 360);
  text ("The OBJECTIVE of the game is to shoot the aliens", 10, 430);
  text ("and spaceship BEFORE they reach the tank or", 40, 465);
  text ("else GAME OVER.", 220, 500); 
  textFont (font3, 25);
  text ("PRESS the K key to load the game!", 100, 550);
}

void gameLevelScreen () { // draws the game level selection screen.
  background (#000000);
  textFont (font, 50);
  text ("CHOOSE A LEVEL", 145, 85);
  textFont (font, 35);
  text ("Easy Mode", 215, 200);
  textFont (font3, 25);
  text ("PRESS '1' for EASY mode.", 160, 300);
  textFont (font, 35);
  text ("Hard Mode", 215, 425);
  textFont (font3, 25);
  text ("PRESS '2' for HARD mode.", 160, 525);
}

void drawAliensAndCheckCollision () { // method to draw the aliens, keep them on the screen, make them move down the screen and check if the laser hit them.
  for (int rows = 0; rows < alienXPositions.length; rows++) { // for loop with the rows counter that starts at 0 and goes upto 2.
    for (int columns = 0; columns < alienYPositions[0].length; columns++) { // for loop with the columns counter that starts at 0 and goes upto 8.
      // DUMMY VARIABLES TO REPRESENT THE RIGHT AND LEFT SIDES OF EACH ALIEN.
      int alienRight = alienXPositions [rows][columns] + 20; 
      int alienLeft = alienXPositions [rows][columns] - 23; 
      if (alienHealth [rows][columns] > 0) { // draws the aliens if the aliens are still alive/have health greater than 0.
        image (alien[rows], alienXPositions [rows][columns], alienYPositions[rows][columns]); //
      }
      if (alienRight > width) {
        alienHitRightEdge = true;
      } else if (alienLeft < 15) {
        alienXSpeed = abs (alienXSpeed); // CHANGES THE DIRECTION OF THE ALIENS TO RIGHT IF THEY REACH THE LEFT EDGE.
      }
      checkLaserHitAlienAndGameOverConditions (rows, columns);
    }
  }
  if (alienHitRightEdge) { // METHOD TO CHANGE THE DIRECTION OF THE ALIENS TO LEFT IF THEY REACH THE RIGHT EDGE.
    for (int rows = 0; rows < alienXPositions.length; rows++) {
      for (int columns = 0; columns < alienYPositions[0].length; columns++) {
        alienYPositions [rows][columns] += 15; // MAKES ALIENS MOVE DOWN VERTICALLY BY 5 PIXELS.
        alienXPositions [rows][columns] -= 15; // MAKES THE ALIENS MOVE A LITTLE TO THE RIGHT AFTER THEY REACH THE RIGHT EDGE TO PREVENT COLLISIONS FROM BEING REGISTERED.
        alienXSpeed = -abs (alienXSpeed); // CHANGES THE DIRECTION OF THE ALIENS TO LEFT IF THEY REACH THE RIGHT EDGE.
      }
    }
    alienHitRightEdge = false;
  }
}

void moveAliens () { // method to move the aliens horizontally (x position) EVERY HALF A SECOND using millis function.
  if (millis() - stopwatchAlien > 500) { // IF HALF A SECOND HAS PASSED SINCE THE PROGRAM BEGAN ON THE GAME SCREEN PAGE, set the value of stopwatchAlien to 0 AGAIN IN A CYCLE.
    stopwatchAlien = millis();
    for (int columns = 0; columns < alienXPositions[0].length; columns++) {
      for (int rows = 0; rows < alienYPositions.length; rows++) {
        if (level == 1) { // moves the aliens horizontally by a speed of 8 FOR EASY LEVEL.
          alienXPositions [rows][columns] += alienXSpeed*8;
        } else if (level == 2) { // moves the aliens horizontally by a speed of 12 FOR HARD LEVEL.
          alienXPositions [rows][columns] += alienXSpeed*12;
        }
      }
    }
    movement++; // increases the value stored inside the movement variable with every change in position of the alien.
  }
}

void checkLaserHitAlienAndGameOverConditions (int rows, int columns) { // method to check if the laser hit a specific alien and increase the score appropriately AND determine if the game is over.
  // The following variables are DUMMY variables to represent different
  // sides of the aliens and the laser.
  int alienBottom = alienYPositions [rows][columns] + 25;
  int alienTop = alienYPositions [rows][columns] - 25;
  int alienRight = alienXPositions [rows][columns] + 25;
  int alienLeft = alienXPositions [rows][columns] - 25;
  int laserTop = laserY - 5;
  int laserBottom = laserY;
  int laserSides = laserX;
  if (laserOnScreen == true && alienHealth [rows][columns] > 0) { // could laserOnScreen be an issue?
    if (laserTop < alienBottom && laserSides > alienLeft && laserSides < alienRight && laserBottom > alienTop) { //
      alienHealth [rows][columns]-- ;
      if (alienHealth [rows][columns] == 0) {
        if (rows == 0) {
          score += 30;
        } else if (rows == 1) {
          score += 20;
        } else if (rows == 2) {
          score += 10;
        }
      }
      laserOnScreen = false;
      numberOfTimesAliensHit++ ;
    }
  }
  if (gameOver == false) {
    if (alienYPositions [rows][columns] >= 500 || easyLevelLives == 0 || hardLevelLives == 0) { // LOSE CONDITION: IF alien(s) reach the tank.
      gameState = 6;
    } else if (numberOfTimesAliensHit == 42 && spaceshipOnScreen == false) { // WIN CONDITION: IF all aliens are killed and the spaceship is killed.
      gameState = 7;
    }
  }
}

void drawSpaceship () { // method to draw the spaceship IF it is on the screen and has not been shot by the player using the tank's laser.
  background (#000000);
  if (spaceshipOnScreen == true) {
    spaceship = loadImage ("spaceship.jpg");
    image (spaceship, spaceshipXPosition, spaceshipYPosition);
  }
}

void moveSpaceship () { // method to move the spaceship horizontally (x position) DEPENDING ON THE LEVEL.
  if (level == 2) { // moves the spaceship by a speed of 16 ((spaceshipXSpeed)8*2) FOR HARD LEVEL ONLY.
    spaceshipXPosition += spaceshipXSpeed*2;
  } else if (level == 1) {
    spaceshipXPosition += spaceshipXSpeed;
  }
}

void checkSpaceshipHitEdgeAndSpaceshipLaserSetup () { // method to keep the spaceship on the screen using dummy variables, if statements and set up the spaceship's laser under the appropriate conditions.
  // DUMMY VARIABLES FOR THE SPACESHIP.
  int spaceshipRight = spaceshipXPosition + 12;
  int spaceshipLeft = spaceshipXPosition - 10;
  if (spaceshipRight > width) {
    spaceshipXSpeed = -abs (spaceshipXSpeed);
  }
  if (spaceshipLeft < 20) {
    spaceshipXSpeed = abs (spaceshipXSpeed);
  }
  if (movement > 9) { // executes code to setup the laser shot by the IF the aliens have moved 9 times.
    spaceshipLaserSetup();
  }
  if (spaceShipFiring) { // draws and moves the laser if the condition is met.
    spaceshipShootLaser ();
  }
}

void spaceshipLaserSetup() { // method to setup the starting positions of the laser and a movement timer to count the aliens movements.
  spaceshipLaserY = spaceshipYPosition;
  spaceshipLaserX = spaceshipXPosition;
  spaceShipFiring = true;
  movement = 0;
}

void spaceshipShootLaser () { // method for the spaceship to draw and shoot a laser that moves vertically.
  if (spaceshipOnScreen == true) {
    line (spaceshipLaserX, spaceshipLaserY, spaceshipLaserX, spaceshipLaserY - 15);
    spaceshipLaserY += 15;
    spaceshipLaserOnScreen = true;
  }
}

void checkTankLaserHitSpaceship () { // method to check and remove spaceship IF hit by a laser from the tank.
  // The following variables are dummy variables 
  // used to represent the different sides of the spaceship and the laser shot by the tank.
  int spaceshipRight = spaceshipXPosition + 25;
  int spaceshipLeft = spaceshipXPosition - 25;
  int spaceshipBottom = spaceshipYPosition + 23;
  int spaceshipTop = spaceshipYPosition - 23;
  int laserTop = laserY - 15;
  int laserBottom = laserY;
  int laserSides = laserX;
  if (laserOnScreen == true && spaceshipOnScreen == true && laserSides > spaceshipLeft && laserSides < spaceshipRight && laserTop < spaceshipBottom && laserBottom < spaceshipTop) {
    spaceshipOnScreen = false;
    score += (int)random(50) + 50; // increases the value stored inside the score variable by a adding a random number from 50 -100.
  }
}

void tank (int xPosition, int yPosition) { // method to draw the tank.
  tank = loadImage ("tank.png");
  image (tank, xPosition, yPosition);
}

void moveTank () { // method to move the tank horizontally (x position) using right and left keys.
  if (tankRight) {
    tankXPosition += tankXSpeed;
  }
  if (tankLeft) {
    tankXPosition -= tankXSpeed;
  }
}

void checkTankHitEdge () { // method to keep the tank on the screen.
  // The following are DUMMY VARIABLES to represent the right and left sides of the tank.
  int tankRightSide = tankXPosition + 30;
  int tankLeftSide = tankXPosition - 30;
  if (tankRightSide > width) {
    tankXPosition = 570;
  } else if (tankLeftSide < 0) {
    tankXPosition = 30;
  }
}

void checkSpaceshipLaserHitTank () { // method to check if the laser shot by the spaceship hit the tank and decrease its live(s) appropriately.
  // The following DUMMY VARIABLES to represent the sides of the laser shot by the spaceship and the tank.
  int laserBottom = spaceshipLaserY;
  int laserTop = spaceshipLaserY - 15;
  int laserSides = spaceshipLaserX;
  int tankRightSide = tankXPosition + 30;
  int tankLeftSide = tankXPosition - 30;
  int tankTop = tankYPosition - 23;
  int tankBottom = tankYPosition + 23;
  if (spaceshipLaserOnScreen == true && laserBottom > tankTop && laserSides > tankLeftSide && laserSides < tankRightSide && laserTop < tankBottom) {
    if (level == 1) {
      easyLevelLives --;
    }
    if (level == 2) {
      hardLevelLives --;
    }
    spaceshipLaserOnScreen = false;
    spaceShipFiring = false;
  }
}

void scoreDisplay () { // method to display the player's score.
  text ("SCORE: " + score, 100, 30);
}

void livesDisplay () { // method to display the number of lives the player/tank has depending on the level chosen.
  if (level == 1) {
    text ("LIVE(S): " + easyLevelLives, 350, 30);
  }
  if (level == 2) {
    text ("LIVE(S): " + hardLevelLives, 350, 30);
  }
}

void drawLaser () { // method to draw a laser that is SHOT BY THE PLAYER/TANK on the screen.
  strokeWeight (10);
  stroke (#ff0000);
  line (laserX, laserY, laserX, laserY - 15);
}

void moveLaser () { // method to SHOOT/move the laser that is SHOT BY THE PLAYER/TANK on the screen.
  if (laserOnScreen) {
    drawLaser();
    laserY -= 15;
  }
  if (laserY < 0) { 
    laserOnScreen = false;
  }
}

void keyPressed () { // runs code inside IF A SPECIFIC KEY IS PRESSED.
  if (gameState == 1) { // WELCOME SCREEN
    if (keyCode == 32) { // SPACEBAR KEY TO LAUNCH INSTRUCTIONS 1 SCREEN.
      gameState = 2;
    }
  } else if (gameState == 2) { // INSTRUCTIONS 1 SCREEN. 
    if (keyCode == 10) { // ENTER KEY TO LOAD INSTRUCTIONS 2 SCREEN.
      gameState = 3;
    }
  } else if (gameState == 3) { // INSTRUCTIONS 2 SCREEN.
    if (keyCode == 75) { // ENTER KEY TO LOAD GAME LEVEL SELECTION SCREEN.
      gameState = 4;
    }
  } else if (gameState == 4) { // GAME LEVEL SELECTION SCREEN.
    if (keyCode == 49) { // '1' KEY TO SET GAME LEVEL TO EASY
      level = 1;
      gameState = 5;
    } else if (keyCode == 50) { // '2' KEY TO SET GAME LEVEL TO HARD
      level = 2;
      gameState = 5;
    }
  } else if (gameState == 5) { // GAME SCREEN
    if (keyCode == 39) { // move the tank to the right if RIGHT arrow KEY is pressed.  
      tankRight = true;
    } 
    if (keyCode == 37) { // move the tank to the left if LEFT arrow KEY is pressed. 
      tankLeft = true;
    }
    if (keyCode == 38 && laserOnScreen == false) { // move the laser if UP KEY is pressed and laser is NOT on screen. 
      laserOnScreen = true;
      laserX = tankXPosition; // sets the initial X position of the laser to that of the tank.
      laserY = tankYPosition; // sets the initial Y position of the laser to that of the tank.
    }
  } else if (gameState == 6 || gameState == 7) {
    if (gameOver == true && keyCode == 8) { // allows player to restart the game if game is over and BACKSPACE key is pressed.
      gameState = 2;
      setVariables (); // resets all variables.
      loop (); // allows draw to start executing the code inside of it again.
    }
  }
}

void keyReleased () { // runs code inside IF A SPECIFIC KEY IS RELEASED.
  if (keyCode == 39) { // stops the tank from moving to the right if RIGHT KEY is released.
    tankRight = false;
  } 
  if (keyCode == 37) { // stops the tank from moving to the left if LEFT KEY is released.
    tankLeft = false;
  }
}
