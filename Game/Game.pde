

class Bullet{

  private boolean active = true;
  float x;
  float y;
  PVector velocity;

  static final float BULLET_SPEED = 10;

  public Bullet(){
    active = false;
    x = 0;
    y = 0;
    velocity = new PVector(0,0);
  }

  public Bullet(float x, float y, PVector direction) {
    active = true;
    this.x = x;
    this.y = y;
    this.velocity = direction.setMag(BULLET_SPEED);
  }


  void update(){
    if (!active) {
      return;
    }
    if(x > 400 || y > 400)
    {
      active = false;
    }
    else {
      x += velocity.x;
      y += velocity.y;
    }
  }

  void destroy(Tank tank) {
    if (active) {
      if (this.x == tank.vel.position.x || this.y == tank.vel.position.y) {
        tank.alive = false;
        this.active = false;
      }
    }
  }
  
  

}
