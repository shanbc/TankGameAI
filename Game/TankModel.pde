import java.util.List;

class Terrain
{
  int type;
  Terrain(int type)
  {
    this.type = type;
  }
}
class TankModelImpl{
  
  int sizeX, sizeY;
  List<Bullet> bulletList;
  Terrain [][] background;
  HashMap<Integer, Tank> enemyTank;
  Tank playerTank;
  int index;

  public TankModelImpl(int sizeX, int sizeY){
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    background = new Terrain[sizeX][sizeY];
    enemyTank = new HashMap<Integer,Tank>();
    playerTank = null;
    background = new Terrain[sizeX][sizeY];
    index = 1;
    bulletList = new ArrayList<Bullet>();
    // For now, set the background all plain
    for(int i = 0; i < sizeX; i ++){
      for(int j = 0; j < sizeY; j++) {
        background[i][j] = new Terrain(0);
        //background[i][j].type = 0;
      }
    }
  }


  public void addPlayerTank(Tank player) {
    this.playerTank = player;
  }

  public int getSizeX() {
    return sizeX;
  }

  public int getSizeY() {
    return sizeY;
  }

  public Terrain[][] getBackground() {
    return this.background;
  }

  public Tank getPlayerTank() {
    return playerTank;
  }

  public void move(int direction) {
    playerTank.move(direction);
  }

  public int isWin() {
    return 0;
  }

  public void playerFire() {
    playerTank.fire();
  }

  public List<Tank> getEnemyTank() {
    ArrayList<Tank> result = new ArrayList<Tank>();
    for(int index: enemyTank.keySet()) {
      result.add(enemyTank.get(index));
    }
    return result;
  }

  public void addEnemyTank(int x, int y) {
    Tank newTank = new Tank(index,x,y,true,0);
    enemyTank.put(index, newTank);
    index += 1;
  }

  public void removeEnemyTank(int index) {
    enemyTank.remove(index);
  }

  public void clearDeadTank() {
    for(int index : enemyTank.keySet()){
      Tank tank = enemyTank.get(index);
      if(!tank.getAlive()){
        enemyTank.remove(index);
      }
    }
  }

  public void addBullet(Tank which) {
    
    Bullet newBullet = new Bullet(which.vel.position.x, which.vel.position.y, which.vel.lastNonZeroVel);
    bulletList.add(newBullet);
    //Bullet newBullet = new Bullet(0,)
  }
  
  public void checkCollision(){
    playerTank.collideWall();
  }
}
