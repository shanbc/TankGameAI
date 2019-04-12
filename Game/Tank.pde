import java.util.HashMap;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;

static final int SUCCESS = 0;
static final int FAIL = 1;

class Tank {

  private boolean alive = true; // Check whether tank alive
  public Steering vel; // velocity and position
  public Bullet bullet;
  private int index; // 0: player tank, else ai tank
  public int direction; // 0, 1, 2, 3, 4, 1 up, 2 down, 3 left, 4 right;

  public boolean enemyFire = false;
  public boolean isStop;
  public boolean isSuspend;

  private int hp;
  
  Task btree;
  
  public Tank(int index, int x, int y, boolean alive, int direction) {
    this.index = index;
    this.alive = alive;
    this.direction = direction;
    this.bullet = new Bullet();
    this.vel = new Steering(x, y);
    this.hp = 100;
    
  }

  void setBTree(Task btree) {
    this.btree = btree;
  }

  public float getX() {
    return this.vel.position.x;
  }

  public float getY() {
    return this.vel.position.y;
  }

  public Steering getVelocity() {
    return this.vel;
  }
  
  public float getAngle()
  {
    return this.vel.angle;
  }

  public Boolean getAlive() {
    return this.alive;
  }
  
  public void countHP(){
    if (this.hp < 0) {
      this.alive = false;
    }
  }
  
  public void move(int direction) {
    if (direction == 0) {
      this.vel.move(0);
    } else if (direction == 1) {
      this.vel.move(1);
    } else if (direction == 2) {
      this.vel.move(2);
    } else if (direction == 3) {
      this.vel.move(3);
    } else if (direction == 4) {
      this.vel.move(4);
    }
  }


  // steering behaviors not applied yet
  public void collideTank(Tank tank) {
    // Collision happens by up-down, left-right, still-up, still down, still right, still left


    // Player ai collide
    if (this.index == 0 || tank.index == 0) {
      // Check the direction
      this.collideDirection(tank, 0);
      // Then Compare steering behavior to decide which will bounce away// crash

    }
    // ai ai collide
    else if (this.index != 0 && tank.index != 0) {
      // Check the direction first
      this.collideDirection(tank, 1);

    } else {
      return;
    }

  }

  public void fire() {
    return;
  }

  private void collideDirection(Tank tank, int type) {

    // up - down collide
    if (this.direction == 1 && tank.direction == 2) {
      if (type == 0) {
        this.vel.position.y += 5;
        tank.vel.position.y -= 5;
      } else {
        this.vel.position.y += 2;
        tank.vel.position.y -= 2;
      }

    }
    // down - up collide
    if (this.direction == 2 && tank.direction == 1) {
      if (type == 0) {
        this.vel.position.y -= 5;
        tank.vel.position.y += 5;
      } else {
        this.vel.position.y -= 2;
        tank.vel.position.y += 2;
      }

    }
    // left right
    if (this.direction == 3 && tank.direction == 4) {
      if (type == 0) {
        this.vel.position.x += 5;
        tank.vel.position.x += 5;
      } else {
        this.vel.position.x += 2;
        tank.vel.position.x += 2;
      }
    }
    // right - left
    if (this.direction == 2 && tank.direction == 1) {
      if (type == 0) {
        this.vel.position.x -= 5;
        tank.vel.position.x -= 5;
      } else {
        this.vel.position.x -= 2;
        tank.vel.position.x -= 2;
      }
    }
  }

  public void collideWall() {
    // Assume a 300 * 300 game
    if (this.vel.position.x < 20 || this.vel.position.x > 380 || this.vel.position.y < 20 || this.vel.position.y > 380) {
      if (this.vel.position.x <= 20) {
        this.vel.position.x += 30;
      }
      if (this.vel.position.x >= 380) {
        this.vel.position.x -= 30;
      }
      if (this.vel.position.y < 20) {
        this.vel.position.y += 30;
      }
      if (this.vel.position.y > 380) {
        this.vel.position.y -= 30;
      }
      this.reDirect();
    }
  }

  private void reDirect() {
    if (this.direction == 1) {
      this.direction = 2;
    }
    if (this.direction == 2) {
      this.direction = 1;
    }
    if (this.direction == 3) {
      this.direction = 4;
    }
    if (this.direction == 4) {
      this.direction = 3;
    }

  }
  
  private int opposite() {
    if (this.direction == 1) {
      return 2;
    }
    if (this.direction == 2) {
      return 1;
    }
    if (this.direction == 3) {
      return 4;
    }
    if (this.direction == 4) {
      return 3;
    }
    else{
      return 0;
    }
  }
  
  private void randoMove(int dir) {
    int r = (int) random(10);
    for (int j = 0; j < r; j++) {
       this.move(dir);
       this.collideWall();
    }
  }
  
}

class Blackboard {
  HashMap<Integer, Tank> etList; // Enemy Tank List
  
  Blackboard() {
    etList = new HashMap<Integer, Tank>();
  }
  
  public Tank get(Integer key) {
    return etList.get(key);
  }
  
  public void put(Integer key, Tank tank) {
    etList.put(key, tank);
  }
}

abstract class Task {
  abstract int execute(); 
  Blackboard bb;
}

class Drive extends Task {
  Drive(Blackboard bb) {
    this.bb = bb;
  }
  
  int execute(){
    // generate random move 
    for (int i = 1; i < 10; i++) {
      int dir = (int) random(4);
      Tank tank_temp = bb.get(i);
      if (tank_temp.alive == true) {
        tank_temp.randoMove(dir);
      }
    }
    return SUCCESS;
  }
}


class Fire extends Task {
  Fire(Blackboard bb) {
    this.bb = bb;
  }
  
  int execute(){
    // generate random move 
    for (int i = 1; i < 10; i++) {
      Tank tank_temp = bb.get(i);
      if (tank_temp.alive == true) {
        // to fire
      }
    }
    return SUCCESS;
  }
} 

class Aim extends Task {
  Aim(Blackboard bb) {
    this.bb = bb;
  }
  
  int execute(){
    // generate random move 
    for (int i = 1; i < 10; i++) {
      Tank tank_temp = bb.get(i);
      if (tank_temp.alive == true) {
        // to Aim
      }
    }
    return SUCCESS;
  }
} 
