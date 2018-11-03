/**************************************************************
* Filename: a3.pde
* Group 2: Mark Edwards, Tony Morehead and Brayden Birks
* Date: 21/05/2018
* Course: COSC101 - Software Development Studio 1
* Description: Asteroids is a computer arcade game which originated
* in the 1980s. The player guides their ship around the screen using
* the up, down, left and right keys so as to avoid crashing into the
* moving asteroids. Points are gained when the player successfully shoots1
* and destroys an asteroid with the ship's laser by pressing the space bar.
* To gain additional points, try shooting and destroying the UFO which
* appears randomly and flys across the screen. However, avoid your ship being
* hit by the UFO's deadly firepower!
* A player is given three lives at the commencement of each game.
* A life is lost each time the ship crashes into an asteroid or is hit by a UFO.
* The game is over when a player loses three lives.

* Usage: Make sure to run in the Processing environment with the
* external library "Sound" (Author: The Processing Foundation) installed.
* Then press play. Please be aware that the user may need to click the mouse into the game screen.

* Notes: If any third party items are use they need to be credited
* External wav files:
* RobinHood76. (2017). 107613__robinhood76__02156-laser-shot.wav [Sound File] Retrieved from
* https://freesound.org/people/Robinhood76/sounds/107613/. Under Attribution Noncommercial License.
* Ryan Snook. (2017). 250712__aiwha__explosion.wav [Sound File] Retrieved from
* https://freesound.org/people/ryansnook/sounds/110114/. Under Attribution Noncommercial License.
* FlashTrauma. (2017). 389710__suspensiondigital__sci-fi-explosion-3.wav [Sound File] Retrieved from
* https://freesound.org/people/FlashTrauma/sounds/398283/. Under Creative Commons License.
* External Gif:
* Best Animations. (2018). ufo-flying-saucer-animated-gif-image-11.gif [Image] Retrieved from
* http://www.http://bestanimations.com/Sci-Fi/UFOs/UFOs.html. Under Free Use as per home page disclaimer.
* External Font:
* Digital Graphics Labs. (2018). bitwise.ttf [Font] Retrieved from
* https://www.1001freefonts.com/bitwise.font. Under license.txt (located in Bitwise folder).
*************************************************************/
/**************************************************************
* Function: Global Variables

* Parameters: Different variables are declared here that will be used and called throughout the design
* of the program. Instances of Ints, Floats, PVectors, SoundFiles, Images, Fonts, Booleans, ArrayLists,
* PShapes and importation of the processing.sound file can all be found here.

* Nothing is returned here. But each variable can be called for in different functions.

* Desc: This stage of the program is purely for declaring what will be used at different times. They
* are declared in a global way so that all functions may have access to them.

***************************************************************/
import processing.sound.*;
SoundFile laser;
SoundFile explosion;
SoundFile shipExplosion;
PImage[] ufo;
PFont computerFont;
PShape ship;
PShape astroid;
PShape sasteroid;
int astroNums= 5;
int astroNumsSmall= astroNums*2;
int lives = 3;
ArrayList<PVector> astroids = new ArrayList<PVector>(astroNums);
ArrayList<PVector> astroDirect = new ArrayList<PVector>(astroNums);
ArrayList<PVector> astroidsSmall = new ArrayList<PVector>(astroNumsSmall);
ArrayList<PVector> astroDirectSmall = new ArrayList<PVector>(astroNumsSmall);
PVector ufoCoord;
PVector ufoDirect;
int exFrame = 0;
int count= 0;
float speed = 0.02;
float maxSpeed = 4;
float rotation = 0;
PVector shipCoord;
PVector direction;
ArrayList<PVector> shotLocationArray;
ArrayList<Float> shotDirection;
int shotSpeed = 4;
boolean sUP=false,sDOWN=false,sRIGHT=false,sLEFT=false,sSPACE=false,sYES=false;
boolean start;
boolean gameOver;
boolean levelsFinished = false;
boolean ufoAttack = false;
int score = 0;
int lastscore = score;
int highscore = 0;
int level = 0;
int timer = 0;
/**************************************************************
* Function: setup()

* This function, is only run once at the start of the program. Its main focus is to intialise the
* variables to be used throughout the program. Size of the screen, setting the focus to the screen 
* start off. The soundfiles are then named and imported using the SoundFile internal function. The 
* games text font is then named and called using the createFont internal function. A range of different
* PVectors are named and intialised. These PVectors will be used to control direction and positioning
* on items such as the ship, asteroids, UFO and shots. The Arraylists for the shots and their direction
* are intialised here as well, these will be used to add and remove shots in further functions. Finally 
* the images and shapes are first intialised. The UFO uses a PImage and a for loop to give its
* animation. The ship and asteroids are drawn using Processing's PShape function.

***************************************************************/
void setup(){
  size(800,600);
  frame.requestFocus();
  laser = new SoundFile(this, "107613__robinhood76__02156-laser-shot.wav");
  explosion = new SoundFile(this,"250712__aiwha__explosion.wav");
  shipExplosion = new SoundFile(this,"389710__suspensiondigital__sci-fi-explosion-3.wav");
  computerFont = createFont("bitwise.ttf", 32);
  shipCoord = new PVector(width/2, height/2);
  direction = new PVector(0,0);
  shotLocationArray = new ArrayList();
  shotDirection = new ArrayList();
  resetAll();
  ufoCoord = new PVector(0,0);
  ufoDirect = new PVector(2,2);
  ufo = new PImage[20];
  for(int i =1; i<ufo.length; i++){
      String strTemp ="\\data\\"+i+".gif";
      ufo[i-1]=loadImage(strTemp); 
      ufo[i-1].resize(ufo[i-1].width/5,ufo[i-1].height/5);
    }
  ship = createShape();
  ship.beginShape();
  ship.fill(0);
  ship.stroke(255);
  ship.strokeWeight(1);
  ship.vertex(9,0);
  ship.vertex(0,17);
  ship.vertex(9,11);
  ship.vertex(18,17);
  ship.vertex(9,0);
  ship.endShape(CLOSE);
  
  astroid = createShape();
  astroid.beginShape();
  astroid.noFill();
  astroid.strokeWeight(1);
  astroid.stroke(255);
  astroid.vertex(6, 0);
  astroid.vertex(16, 6);
  astroid.vertex(25, 6);
  astroid.vertex(29,21);
  astroid.vertex(5, 29);
  astroid.vertex(0, 20);
  astroid.vertex(0, 10);
  astroid.vertex(6, 0);
  astroid.endShape(CLOSE);
  
  sasteroid = createShape();
  sasteroid.beginShape();
  sasteroid.fill(0);
  sasteroid.stroke(255);
  sasteroid.strokeWeight(1);
  sasteroid.vertex(4,0);
  sasteroid.vertex(12,4);
  sasteroid.vertex(18,4);
  sasteroid.vertex(20,16);
  sasteroid.vertex(4,15);
  sasteroid.vertex(0,13);
  sasteroid.vertex(0,10);
  sasteroid.vertex(4,0);
  sasteroid.endShape(CLOSE);
}//end setUp
/**************************************************************
* Function: drawUfo()

* Parameters: Boolean, Int, Push and Pop Matrix, Translate, PImage, If Statements.

* Returns: The picture of the UFO ready to be drawn to the screen. 

* Desc: This function checks to see if the ufo is attacking, if it is the UFO is drawn and its
* coordiniates are translated to the screen.

***************************************************************/
void drawUfo(int Xframe){
  if(ufoAttack && start == true){
     pushMatrix();
     translate(ufoCoord.x, ufoCoord.y);
     image(ufo[Xframe], 0, 0);
     popMatrix();
     count++;
     if(count%5==0) exFrame++;
     if(exFrame==19) exFrame=0;
  }
}//end drawUfo
/**************************************************************
* Function: moveUfo()

* Parameters: If Statements, Booleans, PVectors.

* Returns: The movement of the UFO.

* Desc: Uses a if statement to move the UFO across the screen in the direction that its
* travelling.

***************************************************************/
void moveUfo(){
  if(ufoAttack && start == true){
      ufoCoord.add(ufoDirect);
    if ((ufoCoord.y<-50)||(ufoCoord.y>height+50)||(ufoCoord.x<-50)||(ufoCoord.x>width+50)){ufoAttack=false;}
  }
}//end moveUfo
/**************************************************************
* Function: ufoAppear()

* Parameters: If Statements, Booleans, PVectors, Ints, Functions.

* Returns: Where and when the UFO appears during the game play.

* Desc: This function has the UFO appear at different times throughout the game.
* A timer is used to determine when and where the UFO appears. If statements are
* used to randomise which direction the the UFO comes in from. Everything is controlled
* by a boolean.

***************************************************************/
void ufoAppear(){
  if(ufoAttack && start == true){
    moveUfo();
    drawUfo(exFrame);
  }
  timer++;
  if ((timer%1000 ==0)&&!ufoAttack && start == true){
    ufoAttack =true;
    if(ufoCoord.x<(width/2)){
      ufoDirect.x = abs(ufoDirect.x);
   }else{
      ufoDirect.x =-abs(ufoDirect.x);
   }
    if(ufoCoord.y<(height/2)){
      ufoDirect.y = abs(ufoDirect.y);
   }else{
      ufoDirect.y =-abs(ufoDirect.y);
   }
    if((int)random(0,2)== 0){
    if((int)random(0,2)== 0){
      ufoCoord.x =0;
      ufoDirect.x=abs(ufoDirect.x);
   }else{
      ufoCoord.x = width-50;
      ufoDirect.x=-abs(ufoDirect.x);
     }
   }else{
    if ((int)random(0,2)== 0){
      ufoCoord.y = 0;
      ufoDirect.y=abs(ufoDirect.y);
   }else{
      ufoCoord.y = height-30;
      ufoDirect.y=-abs(ufoDirect.y);
     }
   }   
  }
}// end ufoAppear()
/**************************************************************
* Function: checkEdgesShip()

* Parameters: Takes the shipCoords x and y and the screen sizes width and height.

* Returns: A smooth transition for the ship flying through the different borders of the screen
* and coming out of the other side.

* Desc: Using two if/ else if Statements, the function checks the location of the ship in comparision
* to the screens border. If the ship breaches any of the borders, it will fly through to the other side
* of the screen in which it is traveling.

***************************************************************/
void checkEdgesShip(){
  if(shipCoord.y < 0) {
      shipCoord.y += height;
    }else if(shipCoord.y > height) {
      shipCoord.y -= height;
    }
    if(shipCoord.x > width) {
      shipCoord.x -= width;
    }else if (shipCoord.x < 0) {
      shipCoord.x += width;
  }
}//end check edges ship
/**************************************************************
* Function: resetAll()

* Parameters: Uses the two different asteroids ArrayLists.

* Returns: If the game restarts or a new level is reached. Current asteroids or UFO are removed
* and then redrawn for the restart.

* Desc: Designed to clear the screen of remaining asteroids or UFO to give the user a brand new
* level or restart to the game without having to continue killing the remaing asteroids 
* from the previous game.

***************************************************************/
void resetAll() {
  for (int i= shotLocationArray.size()-1; i>-1; i--){
    shotLocationArray.remove(i);
    shotDirection.remove(i);
  }
  for (int i=astroids.size()-1; i>-1; i--){
    astroids.remove(i);
    astroDirect.remove(i);
  }
  for (int i =astroidsSmall.size()-1; i>-1; i--){
    astroidsSmall.remove(i);
    astroDirectSmall.remove(i);
  }
  for (int i=0; i<astroNums; i++){
    astroids.add(new PVector());
    astroDirect.add(new PVector());
    astroids.get(i).x=(int)random(0,width);
    astroids.get(i).y=(int)random(0,height);
    astroids.get(i).x=(int)random(0,width);
    astroids.get(i).y=(int)random(0,height);
    astroDirect.get(i).x=(int)random(-5, 5);
    astroDirect.get(i).y=(int)random(-5, 5);
  if (astroDirect.get(i).x == 0 && astroDirect.get(i).y == 0){
       astroDirect.get(i).x =2.5;
       astroDirect.get(i).y =-2.5;
    }
  }
  ufoAttack = false;
}//end reset all
/**************************************************************
* Function: checkEdgesForShot

* Parameters: Boolean True or False.

* Returns: A message as to whether a shot has breached the boundaries of the screen.

* Desc: Desgined to let the program know if shots have reached the boundaries. It will
* be called at a later date to help remove shots that have not hit a target and continue
* to move after their main function is finished.

***************************************************************/
boolean checkEdgesForShot(float x, float y){
  if (y < 10 || y > height || x < 10 || x > width) {
      return true;
  }
      return false;
}//end check edges shot
/**************************************************************
* Function: moveShip()

* Parameters: Utilises If Statements and math functions to move the ship depending on which
* key has been pressed. 

* Returns: The users control of the ship during the game play.

* Desc: The first two if statements control the rotation of the ship. Ensuring a fluent spin 
* in the particular direction desired at a given time in the game. checkEdgesShip is called to
* help allow the user to move fluently around and through the screen in game play. If statements are
* then used to give the keys used speed and direction, by calling on the PVectors of the shipCoords and
* shipDirec. If the up key is moved the ship will move forward in the direction its facing. The opposite
* is true if the down key is pressed. The left and right arrown keys are used to give the ship its 
* direction and will help face the ship in the users desired direction.

***************************************************************/
void moveShip(){
  if(rotation>TWO_PI) rotation = 0;
  if(rotation<0) rotation = TWO_PI;
  checkEdgesShip(); // keeps ship in window
  if(sUP){
    direction.x +=cos(rotation+radians(270))*0.04;
    direction.y +=sin(rotation+radians(270))*0.04;
    shipCoord.add(direction);
  }
  if(sDOWN){
    direction.x -=cos(rotation+radians(270))*0.04;
    direction.y -=sin(rotation+radians(270))*0.04;
    shipCoord.add(direction);
  }
  direction.x*=0.98;
  direction.y*=0.98;
  shipCoord.add(direction);
  
  if(sRIGHT){
   rotation+=0.08;
  }
  if(sLEFT){
    rotation-=0.08;
  }
}//end move ship
/**************************************************************
* Function: addShot()

* Parameters: None ( checks to see if a player if alive and if the space bar has been pressed,
* while using the shipCoord and shipDirection as its starting point.

* Returns: A point fired in the direction the ship is facing at that current instance and from
  the ships current x and y location.

* Desc: Each time the user presses the space bar in game play. A shot is added to the shotLocationArray
  to aid in the collision detection of the asteroids. A soundFile is implemented to give the effect of 
   a laser being fired.

***************************************************************/
void addShot(){
  if(lives > 0 && sSPACE==true){
    sSPACE=false;
    shotLocationArray.add(new PVector(shipCoord.x, shipCoord.y));
    shotDirection.add(rotation);
    laser.play();
  }
}//end addShot
/**************************************************************
* Function: moveShots()

* Parameters: Uses ArrayLists, Booleans, Floats and a if/else statement.

* Returns: The drawing and movement of the shot from the ship.

* Desc: This function is designed to loop through different ArrayLists already
* defined in the program. On each iteration it draws a point to its current x and y coordinate
* while moving it forward in its current direction. The function uses a the checkEdgesForShot
* function to determine if its still on the screen. If the point is still on the screen it
* updates the location. If the point has moved off the screen it removes the shot from the arrayList.

***************************************************************/
void moveShots(){ //<>//
  for(int i=0;i<shotLocationArray.size();i++){
      stroke(255); //<>//
      strokeWeight(3); //<>//
      point(shotLocationArray.get(i).x,shotLocationArray.get(i).y);
      float x = shotLocationArray.get(i).x+cos(shotDirection.get(i)+radians(270))*2;
      float y = shotLocationArray.get(i).y+sin(shotDirection.get(i)+radians(270))*2;
      if (!checkEdgesForShot(x, y)) {
        shotLocationArray.set(i, new PVector(x,y));
      }
      else {
        shotDirection.remove(i);//remove direction
        shotLocationArray.remove(i--);
      } 
  }
}// end moveShots
/**************************************************************
* Function: drawAstroids()

* Parameters: Use If Statements, For Loops, ArrayLists, Booleans and Pshapes.

* Returns: Drawing of the Asteroids to the screen.

* Desc: This function uses a if statement to check that two parameters have been met
* firstly that the game is in start mode and secondly if there are still lives available
* for the player to continue the game with. IF these conditions are met, the function uses
* a for lopp to loop through the different Array lists, find out how large and their current
* x & y locations before drawing them to the players screen. Two for loops are used. One for the
* larger astroids, the second is for the smaller sized astroids.

***************************************************************/
void drawAstroids(){
  if (start == true && lives > 0){
    for (int i = 0; i<astroids.size(); i++){
        astroDirect.get(i).limit(1);
        astroids.get(i).add(astroDirect.get(i));
        if(astroids.get(i).x > width) astroids.get(i).x = 0-astroid.width;
        if(astroids.get(i).x < 0 - astroid.width) astroids.get(i).x = width;
        if(astroids.get(i).y > height) astroids.get(i).y = 0-astroid.height;
        if(astroids.get(i).y < 0 - astroid.height) astroids.get(i).y = height;
        shape(astroid, astroids.get(i).x, astroids.get(i).y);
    }
   for (int i = 0; i<astroidsSmall.size(); i++){
        astroDirectSmall.get(i).limit(1);
        astroidsSmall.get(i).add(astroDirectSmall.get(i));
        if(astroidsSmall.get(i).x > width) astroidsSmall.get(i).x = 0-astroid.width/2;
        if(astroidsSmall.get(i).x < 0 - astroid.width/2) astroidsSmall.get(i).x = width;
        if(astroidsSmall.get(i).y > height) astroidsSmall.get(i).y = 0-astroid.height/2;
        if(astroidsSmall.get(i).y < 0 - astroid.height/2) astroidsSmall.get(i).y = height;
        shape(sasteroid, astroidsSmall.get(i).x, astroidsSmall.get(i).y,astroid.width/2,astroid.height/2);
    }
  }
}//end drawAsteroids
/**************************************************************
* Function: shotCollisionDetection()

* Parameters: For Loops, If Statements, ArrayLists, Sounds and Ints are utilised.

* Returns: Removal of shots and asteroids for collisions between the two. A soundFile
* to help the effect of the of the collision. It then also adds smaller asteroids to 
* their respective Arraylists to be drawn from the drawAstroid() function.

* Desc: This function is designed to detect collisions between the shot from the ship
* and the asteroid. It works by looping through Arraylists checking coordinates of shots
* and asteroids to see if they collide. If a collision is detected, the shot and the astroid
* is removed from their ArrayList, a soundfile is play to signify the event, the score is
* updated, smaller asteroids added to their list to be drawn if a large asteroid is hit. If a
* smaller asteroid is hit the process is repeated but nothing new is added to any of the ArrayLists.

***************************************************************/
void shotCollisionDetection(){
 for (int i = 0; i<astroids.size(); i++){
    for(int j = 0; j< shotLocationArray.size(); j++){
      if(shotLocationArray.get(j).x >= astroids.get(i).x &&
          shotLocationArray.get(j).x <= (astroids.get(i).x + astroid.width) &&
          shotLocationArray.get(j).y >= astroids.get(i).y &&
          shotLocationArray.get(j).y <= (astroids.get(i).y + astroid.height)){
          explosion.play();
          shotDirection.remove(j);
          shotLocationArray.remove(j);
          score +=100;
          astroidsSmall.add(new PVector(astroids.get(i).x,astroids.get(i).y));
          astroidsSmall.add(new PVector(astroids.get(i).x,astroids.get(i).y));
          astroDirectSmall.add(new PVector(random(-2.5,2.5),random(-2.5,2.5)));
          astroDirectSmall.add(new PVector(random(-2.5,2.5),random(-2.5,2.5)));
          astroids.remove(i);//laser hits rock, remove rock`
          astroDirect.remove(i);
          if (astroids.size()>=0) return;
      }
    }
 }
 for (int i = 0; i<astroidsSmall.size(); i++){
    for(int j = 0; j< shotLocationArray.size(); j++){
      if(shotLocationArray.get(j).x >= astroidsSmall.get(i).x &&
          shotLocationArray.get(j).x <= (astroidsSmall.get(i).x + astroid.width) &&
          (shotLocationArray.get(j).y) >= astroidsSmall.get(i).y &&
          shotLocationArray.get(j).y <= (astroidsSmall.get(i).y + astroid.height)){
          explosion.play();
          shotDirection.remove(j);
          shotLocationArray.remove(j);
          score +=100;
          astroidsSmall.remove(i);//laser hits rock, remove rock`
          astroDirectSmall.remove(i);
          if (astroids.size()>=0) return;
      }
    }
  }
  for (int k =0; k<shotLocationArray.size(); k++){
      if(shotLocationArray.get(k).x >= ufoCoord.x &&
          shotLocationArray.get(k).x <= (ufoCoord.x + 80) &&
          (shotLocationArray.get(k).y) >= ufoCoord.y &&
          shotLocationArray.get(k).y <= (ufoCoord.y + 40) && ufoAttack){
          explosion.play();
          shotDirection.remove(k);
          shotLocationArray.remove(k);
          score +=2000;
          ufoAttack = false;
     }
  }
}//end shotCollisionDetection
/**************************************************************
* Function: shipCollisonDetection()

* Parameters: For Loops, If Statements, ArrayLists, Sounds and Ints are utilised.

* Returns: Removal of the ship for collisions between the ship, ufo and asteroids. 
* A soundFile to help the effect of the of the collision. A player life is removed
* on collision.

* Desc: Much the same as the collision detection system between the shots and asteroids
* this function works on looping through the arraylists of the astroids checking their
* current locations on the screen against that of the ship. If a collison is detected 
* between the ship and the asteroid a soundFile is play to signify the event and the
* ship is removed from the screen. Should a collision be present for the last of the
* players lives. A boolean is triggered to signal the end of the game and the program
* then moves to a new function to be utilised. The collision takes place between the
* UFO and Ship by checking their coordinates during the game play. The same process occurs
* of a soundfile and removal of a player life from the game play.

***************************************************************/
void shipCollisionDetection(){
 for (int k=0; k<astroids.size(); k++){
    if(astroids.get(k).x+30 >= (shipCoord.x-9) && astroids.get(k).x <= (shipCoord.x+9)
       && astroids.get(k).y+30 >= (shipCoord.y-9) && astroids.get(k).y <= (shipCoord.y +9) && lives > 0){
        shipExplosion.play();
        lives--;
        shipCoord.x = width/2 - ship.width/2;
        shipCoord.y = height/2 - ship.height/2;
        astroids.get(k).x = random(width);
        astroids.get(k).y = random(height);
        return;
    }
  }
 for (int k=0; k<astroidsSmall.size(); k++){
    if(astroidsSmall.get(k).x+30 >= (shipCoord.x-9) && astroidsSmall.get(k).x <= (shipCoord.x+9)
       && astroidsSmall.get(k).y+30 >= (shipCoord.y-9) && astroidsSmall.get(k).y <= (shipCoord.y +9) && lives > 0){
        shipExplosion.play();
        lives--;
        shipCoord.x = width/2 - ship.width/2;
        shipCoord.y = height/2 - ship.height/2;
        astroidsSmall.get(k).x = random(width);
        astroidsSmall.get(k).y = random(height);
        return;
    }
  }
  if(shipCoord.x >= ufoCoord.x && shipCoord.x <= (ufoCoord.x + 80) &&
      shipCoord.y >= ufoCoord.y && shipCoord.y <= (ufoCoord.y + 40) && (ufoAttack)){
        shipExplosion.play();
        lives--;
        shipCoord.x = width/2 - ship.width/2;
        shipCoord.y = height/2 - ship.height/2;
      }
}//end collisionDetection
/**************************************************************
* Function: score()

* Parameters: Text, Font, If Statements and Ints.

* Returns: Players game score and high score to the screen.

* Desc: A simple function that allows a player to know what their current
* game score is from shot collisions with a asteroid. If a player reaches
* multiples of 2000 points a new life is awarded to the player. If a highscore
* is beaten from a previous game it is recorded on the screen. Unfortunately this
* score is not saved should a player close the program and start again.

***************************************************************/
void score(){
  textFont(computerFont, 32);
  fill(255);
  textSize(30);
  text("Score: " + score, 0, 30);
  if((score!=0)&&(score % 2000 == 0)&&(lastscore!=score)){
    lastscore=score;
    lives+=1;
  }
  textFont(computerFont, 32);
  fill(255);
  textSize(30);
  text("High Score: " + highscore,300,30);
  if (score>highscore){
    highscore = score;
  }
}//end score
/**************************************************************
* Function: startGame()

* Parameters: Booleans, Text, Font, Ints and If Statements.

* Returns: The initial starting screen as a jump off point into the game.

* Desc: This function welcomes the player to the game and invites them to start.
* When a player triggers the start of the game the boolean is triggered to allow
* other functions within the program to start drawing the ships etc to the screen.

***************************************************************/
void startGame(){
  if (start == false && lives == 3){
    fill(255);
    textSize(50);
    text("Welcome to Asteroids", 150, 250);
    text("Press the Space Bar to begin", 50,350);
    if (sSPACE==true){
       start = true;
       sSPACE=false;
       resetAll();
       astroNums = 5;
       level = 0;
       score = 0;
       levelsFinished =false;
    }
  }
}//end startGame
/**************************************************************
* Function: endGame()

* Parameters: Booleans, Text, Font, Ints and If Statements.

* Returns: The end game screens for either game over or you won. Depending on player success.

* Desc: Works exactly the same as the start() function, except it is designed to test for
* the player winning or losing the game. If a player loses all of their lives then the boolean
* is triggered to present a GAME OVER screen with the option to play again. If a player successfully
* defeats all of the leves a YOU WON screen is then triggered through the use of a boolean, and the 
* option to play again is presented.

***************************************************************/
void endGame(){
  if (start == true && lives == 0){
    fill(255);
    textSize(50);
    text("GAME OVER", 250, 250);
    text("Press Y", 300,300);
    text("To Play Again", 225,350);
    if(sYES) {
      start = false;
      lives = 3;
      level = 0;
      score = 0;
      resetAll();
      astroNums = 5;
      sYES=false;
    } 
  }
  if(levelsFinished== true && start == true){
          fill(255);
          textSize(50);
          text("You Won!!",280, 250);
          text("Press Y", 300,300);
          text("To Play Again", 225,350);
    if(sYES){
      start =false;
      levelsFinished = false;
      lives = 3;
      level = 0;
      score = 0;
      resetAll();
      astroNums = 5;
      sYES =false;
    }
  }
}//end endGame
/**************************************************************
* Function: levels()

* Parameters: ArrayLists, Text, Font, If Statements, and Booleans.

* Returns: A message to signal to a player they have successfully completed that
* level. 

* Desc: Tests to see if all of the current asteroids have been destroyed. If they have
* a message is sent to the players screen letting them know that they have completed
* that level with the option to continue onto the next one in their own time. If a 
* player accepts to move on. Asteroid numbers are increased, and the game is reset to 
* the new level using the resetAll funtion.

***************************************************************/
void levels() {
  if (astroids.size() == 0 && astroidsSmall.size() ==0 && levelsFinished == false){
      fill(255);
      textSize(50);
      String title="Level " + (astroNums-4);
      text(title, (width-textWidth(title))/2, 250);
      title="Completed";
      textSize(25);
      text(title, (width-textWidth(title))/2,300);
      title="Press Y To Continue";
      text(title, (width-textWidth(title))/2,350);
  if (level ==3){
       levelsFinished=true;
          }
  if(sYES) {
      level++;
      resetAll();
      astroNums++;
      sYES=false;
    }
  }
}// end levels
/**************************************************************
* Function: drawShip()

* Parameters: PShape, Booleans, Push and Pop Matrix, Translate.

* Returns: The players ship to the screen ready for game play.

* Desc: The function first checks to see if the player if alive and if
* the game has started. The function then draws the ship and calls in the
* shipCoord.x and .y from the previously initialised PVector. Allowing the
* player to move the ship around the screen with the moveShip function.

***************************************************************/
void drawShip(){
  if(lives>0 && start == true){
  pushMatrix();
  translate(shipCoord.x, shipCoord.y);
  rotate(rotation);
  shape(ship, -ship.width/2, -ship.height/2);
  popMatrix();
  moveShip();
  }
}//end drawShip
/**************************************************************
* Function: playerLives()

* Parameters: For Loop, PShape.

* Returns: A visual aid for the player, to see how many lives they have left in the game.

* Desc: The for loop places a shape of the ship on the top left hand corner
* of the screen, in accordance with the amount of lives that the player currently has.
* If a player loses a life a shape is removed, as well as in the instance should the player
* be awarded another life, a new shape is drawn to the screen.

***************************************************************/
void playerLives(){
   for(int i =1; i<=lives;i++){
     shape(ship,(i-1)*20,40);
   }
}// end playerLives
/**************************************************************
* Function: draw()

* Parameters: All of the previously outlined functions.

* Returns: The complete game being drawn to the screen.

* Desc: Draw is used to contiously draw the current state of the game. All of
* the functions are added here. The function checks through all of the conditions
* and draws them to the screen as per their requirements outlined earlier. Essentially,
* the main method to bring the game to life.

***************************************************************/
void draw(){
  background(0);
  playerLives();
  startGame();
  score();
  drawShip();
  drawAstroids();
  moveShip();
  moveShots();
  addShot();
  shotCollisionDetection();
  shipCollisionDetection();
  levels();
  endGame();
  ufoAppear();
}//end draw
/**************************************************************
* Function: keyPressed()

* Parameters: If statements, Booleans and keyCodes.

* Returns: Instructions sent to the game based on the users input.

* Desc: keyPressed checks to see which key has been pressed. It then
* triggers instructions sent to the functions that require those instructions
* for example if the UP arrow is pushed the ship will move forward, if the space bar
* is pressed depending on which screen the game will either start or fire a shot from
* the ship and so on. The keypressed essentially toggles booleans allowing the program
* to know what the user wants it to do.

***************************************************************/
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      sUP=true;
    }
    if (keyCode == DOWN) {
      sDOWN=true;
    } 
    if (keyCode == RIGHT) {
      sRIGHT=true;
    }
    if (keyCode == LEFT) {
      sLEFT=true;
    }
  }
  if (key == ' ') {
    sSPACE=true;
  }
  if (key == 'Y' || key == 'y'){
     sYES=true;
  }
}//end keyPressed
/**************************************************************
* Function: keyReleased()

* Parameters: If statements, Booleans and keyCodes.

* Returns: The boolean of the key being released to its false position.

* Desc: When a key is pressed the game switches to perform the task that 
* the particular key is coded to. When the key is released this function
* resets the key to its "off" or false setting. Allowing for instructions
* to be given accurately on the next key being pressed.

***************************************************************/
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      sUP=false;
    }
    if (keyCode == DOWN) {
      sDOWN=false;
    }
    if (keyCode == RIGHT) {
      sRIGHT=false;
    }
    if (keyCode == LEFT) {
      sLEFT=false;
    }
  }
  if (key==' ') {
    sSPACE=false;
  }
  if (key=='Y' || key=='y') {
    sYES=false;
  }
}//end keyReleased //<>//
