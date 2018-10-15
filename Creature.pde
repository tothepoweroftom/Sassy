class Creature {
  PImage head;
  PImage body;
  HashMap pose;
  HashMap previousPose;

  boolean alive;
  int life;

  String number;
  Creature(HashMap _pose, String _number) {
    head = loadImage("head.png");
    body = loadImage("body.png");
    pose = _pose;
    previousPose = this.pose;
    number = _number;
    alive = true ;
    life = 5;
  }

  void update(HashMap newPose) {
    this.previousPose = this.pose;
    this.pose = newPose;
    //float d = checkDistance(point);

    //if (d < 500.0) {
    //  headPos.lerp(point, 0.5);
    //} else {
    //  headPos = point;

    //}
  }

  void draw() {
    Iterator it = pose.entrySet().iterator();
    while (it.hasNext()) {
      Map.Entry pair = (Map.Entry)it.next();
      System.out.println(pair.getKey() + " = " + pair.getValue());
      PVector position = (PVector)pair.getValue();
      text((String)pair.getKey(), position.x+10.0, position.y+10.0);
      ellipse(position.x, position.y, 10, 10);
      //it.remove(); // avoids a ConcurrentModificationException
    }
  }

  float checkDistance(PVector point1, PVector point2) {
    float d = PVector.dist(point1, point2);
    println("disatnce: " + d);
    if ( d < 0.0001) {
      life--;
      if (life <= 0) {
        alive = false;
      }
    } else {
      life = 5;
    }
    return d;
  }

  //Create a PVector for each keypoint, lerp with previous point.
  PVector getKeypoint(String point, int i) {
    PVector ret = this.pose.get(point) != null ? (PVector)this.pose.get(point) : new PVector(-1000, -1000);
    return ret;
  }
}