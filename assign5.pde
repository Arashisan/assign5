int backgroundX, background1X, background2X;
int hpW;
int enemyXSet, enemyWave;
int fighterX, fighterY, speed;  
int treasureX, treasureY;
int gameState = 0;
int numFrames = 5;
int enemyCount = 8;
int shootCount = 5;
int score = 0;
final int GAME_START=0, GAME_RUN=1, GAME_OVER=2;
boolean upPressed, downPressed, leftPressed, rightPressed;
PImage background1, background2, start1, start2, end1, end2;
PImage enemy, fighter, hpImg, treasure, shoot;
PImage [] flames = new PImage[numFrames];
int[] currentFrame = new int [enemyCount];
int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];
int[] flameX = new int[enemyCount];
int[] flameY = new int[enemyCount];
int[] shootX = new int[shootCount];
int[] shootY = new int[shootCount];
float[] distance = new float[enemyCount];
PFont f;
void setup () {
  size(640, 480);
    //loadImage
    background1=  loadImage("img/bg1.png");
    background2=  loadImage("img/bg2.png");
    enemy      =  loadImage("img/enemy.png");
    fighter    =  loadImage("img/fighter.png");
    hpImg      =  loadImage("img/hp.png");
    treasure   =  loadImage("img/treasure.png");
    start1     =  loadImage("img/start1.png");
    start2     =  loadImage("img/start2.png");
    end1       =  loadImage("img/end1.png");
    end2       =  loadImage("img/end2.png");
    for (int i=0; i<numFrames; i++){
      flames[i] = loadImage("img/flame" + (i+1) + ".png");
    }
    shoot      =  loadImage("img/shoot.png");
    
    //init variables
    backgroundX = 0;
    hpW         = 40;
    fighterX    = 550;
    fighterY    = 240;
    hpW         = 40;
    treasureX   = floor(random(20,501));
    treasureY   = floor(random(60,401));
    enemyXSet   = -80;
    enemyWave   = 0;
    speed       = 5;
    upPressed = downPressed = leftPressed = downPressed = false;
    for(int i=0; i<5; i++){
      shootX[i]  = -1;
      shootY[i]  = -1;
    }
    for (int i = 0; i < enemyCount; i++){
      flameX[i] = -1;
      flameY[i] = -1;
    }
    addEnemy(enemyWave);
    f = createFont("Arial",12); // setFont
}

void draw()
{
    
    //background(0);
    switch (gameState){
      case GAME_START:
        showStart();
        break;      
      case GAME_RUN:
        //background
        drawBackground();
        
        //hpvolume
        if(hpW <= 0){
          hpW = 0;
          gameState = GAME_OVER;
        }
        stroke(255,0,0);
        fill(255,0,0);
        rect(20,20,hpW,20);
        
        //hpImg
        image(hpImg,15,15);
        
        //treasure
        drawTreasure();
        
        //Bullet
        shootBullet();
        int [] Num = new int[enemyCount];
        //int Num;
        for (int i=0; i<shootCount; i++){
          if(shootX[i] != -1 || shootY[i] != -1){
            Num[i] = closestEnemy(shootX[i],shootY[i]);
            if(Num[i] != -1)
            {
                if(shootY[i] < enemyY[Num[i]]){
                  shootY[i]+= 0.5;
                }
                else if(enemyY[Num[i]] < shootY[i]){
                  shootY[i]-= 0.5;
                }
              
            }
          }
        }
        
        //check enemy destory or collide and show flames
        for(int i = 0; i < 8; i++){
            //enemydestory
            checkEnemyDestoried(i);
            //enemy collide
            checkEnemyCollided(i);
            showFlame(i);
        }
        //fighter
        fighterMove();
         
        //enemy
        enemyXSet+=5;
        for (int i = 0; i < enemyCount; ++i) {
            if (enemyX[i] != -1 || enemyY[i] != -1) {
                image(enemy, enemyX[i], enemyY[i]);
                enemyX[i]+=5;
                
                if(enemyX[i] > 640){
                  enemyX[i] = -1;
                  enemyY[i] = -1;
                }
            }
        }
        //change enemy wave
        if(enemyXSet > 1000){
            enemyXSet = -80;
            enemyWave++;
            enemyWave %= 3;
            addEnemy(enemyWave);
        }
        //if enemy all clear
        //resetenemy();
        showScore(score);
        break;
     case GAME_OVER:
       showGameOver();
       break;       
    }
}

void keyPressed(){
  if(key == CODED){
    switch(keyCode){
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
}

void keyReleased(){
  if(key == ' '){
    for(int i = 0; i < 5;i++){
      if(shootY[i] == -1){
        shootX[i] = fighterX+fighter.width/5;
        shootY[i] = fighterY+fighter.height/4;
        break;
      }
    }
  }
  if(key == CODED){
    switch(keyCode){
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  }
}

void showStart()
{
 if(mouseY > 375 && mouseY < 420 && mouseX > 200 && mouseX < 450){
   //click
   if(mousePressed){
      gameState = GAME_RUN;
   }
   //hover
   else
     image(start1,0,0);
   }
 else
   image(start2,0,0);
}

void showGameOver()
{
  if(mouseY >305 && mouseY < 350 && mouseX > 205 && mouseX < 440){
    //click
    if(mousePressed){
      fighterX = 550;
      fighterY = 240;
      treasureX = floor(random(20,501));
      treasureY = floor(random(60,401));
      hpW = 40;
      enemyWave = 0;
      addEnemy(enemyWave);
      enemyXSet = 0;
      score = 0;
      for (int i = 0; i < 8; i++){
          flameX[i] = flameY[i] = -1;
          currentFrame[i] = 0;
      }
      for (int j = 0; j < 5; j++){
        shootX[j]  = -1;
        shootY[j]  = -1;
      }
      gameState = GAME_RUN;
    }
    //hover
    else
      image(end1,0,0);
  }
  else
    image(end2,0,0);
  
}

void shootBullet()
{
  for ( int i=0; i<5; i++){
    if(shootX[i] != -1 || shootY[i] != -1){
      image(shoot, shootX[i], shootY[i]);
      shootX[i]-=6;
    }
    if(shootX[i] < -31)
      shootX[i] = shootY[i] = -1;
    }
}

void drawBackground()
{
   image(background2,background2X,0);
   image(background1,background1X,0);
   background2X = backgroundX + 640;
   background1X = backgroundX;
   backgroundX += 2;
   background2X = (background2X %= 1280) - 640;
   background1X = (background1X %= 1280) - 640;
}

void fighterMove()
{
  if(upPressed)
    fighterY -= speed;
  if(downPressed)
    fighterY += speed;
  if(leftPressed)
    fighterX -= speed;
  if(rightPressed)
    fighterX += speed;
    //Boundary detection
    if(fighterX<0)
      fighterX = 0;
    if(fighterX > 590)
      fighterX = 590;
    if(fighterY < 0)
      fighterY = 0;
    if(fighterY > 430)
      fighterY = 430;
  image(fighter,fighterX,fighterY);
}

// 0 - straight, 1-slope, 2-dimond
void addEnemy(int type)
{  
  for (int i = 0; i < enemyCount; ++i) {
    enemyX[i] = -1;
    enemyY[i] = -1;
  }
  switch (type) {
    case 0:
      addStraightEnemy();
      break;
    case 1:
      addSlopeEnemy();
      break;
    case 2:
      addDiamondEnemy();
      break;
  }
}

void addStraightEnemy()
{
  float t = random(height - enemy.height);
  int h = int(t);
  for (int i = 0; i < 5; ++i) {

    enemyX[i] = (i+1)*-80;
    enemyY[i] = h;
  }
}
void addSlopeEnemy()
{
  float t = random(height - enemy.height * 5);
  int h = int(t);
  for (int i = 0; i < 5; ++i) {

    enemyX[i] = (i+1)*-80;
    enemyY[i] = h + i * 40;
  }
}
void addDiamondEnemy()
{
  float t = random( enemy.height * 3 ,height - enemy.height * 3);
  int h = int(t);
  int x_axis = 1;
  for (int i = 0; i < 8; ++i) {
    if (i == 0 || i == 7) {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h;
      x_axis++;
    }
    else if (i == 1 || i == 5){
      enemyX[i] = x_axis*-80;
      enemyY[i] = h + 1 * 40;
      enemyX[i+1] = x_axis*-80;
      enemyY[i+1] = h - 1 * 40;
      i++;
      x_axis++;      
    }
    else {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h + 2 * 40;
      enemyX[i+1] = x_axis*-80;
      enemyY[i+1] = h - 2 * 40;
      i++;
      x_axis++;
    }
  }
}

void checkEnemyDestoried(int i) //if bullet hit enemy
{
  for(int j = 0; j < 5; j++){
      if(shootX[j] != -1 || shootY[j] != -1){
        if(enemyX[i] != -1 || enemyY[i] !=-1){
          if(isHit(shootX[j],shootY[j],shoot.width,shoot.height,enemyX[i],enemyY[i],enemy.width,enemy.height)){
            shootX[j] = shootY[j] = -1;
            score+=20;
            if(flameX[i] == -1 || flameY[i] == -1){
              flameX[i] = enemyX[i];
              flameY[i] = enemyY[i];
            }
            enemyX[i] = enemyY[i] = -1;
          }
        }
      }
  }
}

void checkEnemyCollided(int i) //if bullet collide with fighter
{
  if(enemyY[i] != -1){
    if(isHit(fighterX,fighterY,fighter.width,fighter.height,enemyX[i],enemyY[i],enemy.width,enemy.height)){
      flameX[i] = enemyX[i];
      flameY[i] = enemyY[i];
      enemyX[i] = enemyY[i] = -1;
      if(hpW < 40)
        hpW -= hpW;
      else  
        hpW -= 40;
    }
  }
}

void drawTreasure() //if fighter eat treasure
{
  if(isHit(fighterX,fighterY,fighter.width,fighter.height,treasureX,treasureY,treasure.width,treasure.height)){
     treasureX = floor(random(20,501));
     treasureY = floor(random(60,401));
     if(hpW >= 200){
       hpW = 200;
     }
     else
       hpW+=20;
     }
  image(treasure,treasureX,treasureY);
}

void showFlame(int i) 
{
  if(flameX[i]!=-1||flameY[i]!=-1){
    image(flames[currentFrame[i]],flameX[i],flameY[i]);
    if(frameCount % (60/10) == 0){
      currentFrame[i]++;
      if(currentFrame[i] == numFrames){
        flameX[i] = flameY[i] = -1;
        currentFrame[i] = 0;
      }
    }
  }
}

void showScore(int i)
{
  textFont(f,26);
  textAlign(LEFT);
  fill(255);
  text("Score:"+i,10,460);
}

//void resetenemy()
//{
//  for (int j = 0,k = 0; j < enemyCount; j++)
//    {
//       if(enemyX[j] == -1 && enemyY[j] == -1)
//         k++;
//       if(k == 8){
//         enemyWave++;
//         enemyWave %= 3;
//         k=0;
//         addEnemy(enemyWave);
//       }
//    }
//}

boolean isHit(int ax,int ay,int aw,int ah,int bx,int by,int bw,int bh)
{
  if(ax-bx <= bw && ay-by <= bh && 
     bx-ax <= aw && by-ay <= ah){
       return true;
     }
  else
    return false;
}

int closestEnemy(int x, int y)
{
 for (int i = 0; i < enemyCount;i++)
 {
   if(enemyX[i] != -1 || enemyY[i] != -1){ 
     
     if(x > enemyX[i]){
       distance[i] = dist(x,y,enemyX[i],enemyY[i]);
       for(int j = i; j < enemyCount-1 ; j++){
         if(distance[j]<distance[j+1]){
           return j;
         }
       }
     }
     else if(x < enemyX[i])
       return -1;
   }
 }
 return -1;
}
