TankModelImpl model;

void settings()
{
  size(400,400);
  Tank player = new Tank(-1,180,220,true,0);
  model = new TankModelImpl(10,10);
  model.addEnemyTank(20,20);
  model.addEnemyTank(140,20);
  model.addEnemyTank(220,20);
  model.addPlayerTank(player);
}

void draw()
{
  background(0);
  Terrain[][] background = model.getBackground();
  int sizeX = model.getSizeX();
  int sizeY = model.getSizeY();
  
  for(int i = 0; i < sizeX; i ++)
  {
    for(int j = 0; j < sizeY; j ++)
    {
      Terrain thisCell = background[i][j];
      if(thisCell.type == 0)
      {
        fill(0,255,0);
        //stroke(255, 0, 0);
        rect(i*40,j*40,40,40);
      }
    }
  }
  for(Tank temp : model.getEnemyTank()){
   drawTank(temp);
  }
  drawTank(model.getPlayerTank());
  model.getPlayerTank().vel.next(new PVector(mouseX, mouseY));
  drawBullet();
  if(keyPressed && keyCode == 37)
  {
    model.move(3);
    model.checkCollision();
  }
  else if(keyPressed && keyCode == 38)
  {
    model.move(1);
    model.checkCollision();
  }
  else if(keyPressed && keyCode == 39)
  {
    model.move(4);
    model.checkCollision();
  }
  else if(keyPressed && keyCode == 40)
  {
    model.move(2);
    model.checkCollision();
  }
  else
  {
    model.move(0);
  }
  
  for(int i = 0; i < model.bulletList.size(); i ++)
  {
    Bullet temp = model.bulletList.get(i);
    temp.update();
    if(!temp.active)
    {
      model.bulletList.remove(i);
    }
  }
}

void drawBullet()
{
  List<Bullet> bl = model.bulletList;
  for(Bullet temp : bl)
  {
    fill(0,0,0);
    ellipse(temp.x, temp.y, 5, 5);
  }
  
}
void drawTank(Tank tank)
{
  float x = tank.getX();
  float y = tank.getY();
  //stroke(0,255,255);
  fill(204, 102, 0);
  ellipse(x, y, 40, 40);
  pushMatrix();
  translate(x, y);
  rotate(tank.vel.angle);
  line(0, 0, 20, 0);
  popMatrix();
}

void mouseClicked()
{
  model.addBullet(model.getPlayerTank());
}
