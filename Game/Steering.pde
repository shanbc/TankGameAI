
class Steering {
  private static final float PI = (float) Math.PI;
  PVector position;
  PVector velocity;
  PVector lastNonZeroVel;
  float angle;
  float acceptLocRad, slowLocRad, maxSpeed;
  float acceptRotRad, slowRotRad, maxRotSpeed;
  float maxAccel, timeToTarget;

  public Steering(int x, int y){
    position = new PVector(x, y);
    velocity = new PVector(0,0);
    lastNonZeroVel = velocity.copy();
    angle = 0;
    acceptLocRad = 10;
    slowLocRad = 20;
    maxSpeed = 5;
    acceptRotRad = PI/60;
    slowRotRad = PI/15;
    maxRotSpeed = PI/30;
    maxAccel = (float) 0.4;
    timeToTarget = (float) 0.2;
    }

  float wrapAngle(float angle) {
    if (angle > PI) {
      return angle - 2 * PI;
    }
    if (angle < -PI) {
      return angle + 2 * PI;
    }
    return angle;
  }
  
  
  
  //Keep tracking of the tank angle but not the movement of the tank.
  void next(PVector vector) {
    float velx = velocity.x;
    float vely = velocity.y;
    float dist = PVector.dist(vector, position);
    PVector diff = PVector.sub(vector, position);
    
    // first rotate
    float targetAngle = lastNonZeroVel.heading();
    float rotation = wrapAngle(targetAngle - angle);
    float rotationSize = Math.abs(rotation);
    float rotSpeed;
    if (rotationSize > acceptRotRad) {
      if (rotationSize < slowRotRad) {
        rotSpeed = maxRotSpeed * rotationSize / slowRotRad;
      } else {
        rotSpeed = maxRotSpeed;
      }
      if (rotation < 0) {
        angle = wrapAngle(angle - rotSpeed);
      } else {
        angle = wrapAngle(angle + rotSpeed);
      }
    }
    
    // then move
    float targetSpeed;
    PVector targetVelocity;
    PVector fakeVel = new PVector(0,0);
    //print(velocity);

    if (dist <= acceptLocRad) {
      fakeVel.set(0, 0);
    } else {
      if (dist >= slowLocRad) {
        targetSpeed = maxSpeed;
      } else {
        targetSpeed = maxSpeed * dist / slowLocRad;
      }
      
      targetVelocity = diff;
      targetVelocity.normalize();
      targetVelocity.mult(targetSpeed);
      
      PVector acc = PVector.sub(targetVelocity, fakeVel);
      acc.div(timeToTarget);
      acc.limit(maxAccel);
      
      fakeVel.add(acc);
      fakeVel.limit(maxSpeed);
      lastNonZeroVel = fakeVel.copy();
    }
    velocity = new PVector(velx,vely);
    position.add(velocity);
  }
  
  void move(int direction)
  {
    //print(velocity);
    //velocity.set(1,1);
    if(direction == 0)
    {
      if(velocity.mag() != 0)
      {
        velocity.mult(0.75);
      }
    }
    if(direction == 1)
    {
      velocity.y -= 0.05;
    }
    if(direction == 2)
    {
      velocity.y += 0.05;
    }
    if(direction == 3)
    {
      velocity.x -= 0.05;
    }
    if(direction == 4)
    {
      velocity.x += 0.05;
    }
  }

}
