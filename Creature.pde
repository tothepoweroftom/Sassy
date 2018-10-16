class Creature {
  PShape head;
  PShape head_active;

  HashMap pose;
  HashMap previousPose;

  PVector headPos;
  float headscale = 100;

  boolean alive;
  int life;
  float amplitude;
  boolean growing = false;
  boolean canGrow = true;
  boolean canShrink = false;
  boolean triggered = false;

  String number;
  Creature(HashMap _pose, String _number) {
    head = loadShape("sound-face-01.svg");
    //head_active = loadShape("sound-face-big.svg");

    pose = _pose;
    previousPose = this.pose;
    number = _number;
    alive = true ;
    life = 5;
    amplitude = 0.0;

    //Get first keypoint
    headPos = this.getKeypoint("nose");
  }

  void update(HashMap newPose) {
    this.pose = newPose;
    updateHead();
  }

  void draw(float _amplitude) {
    if (alive) {
      fill(0);
      tint(255, life*51);
      //headscale = map(abs(amplitude), 0.0, 0.2, 30,60);

      if (checkIfGrowing(_amplitude)) {
        //ellipse(headPos.x, headPos.y, headscale+_amplitude*500, headscale+_amplitude*500);
        headscale+=1;
      }
      shape(head, headPos.x, headPos.y, headscale, headscale);


      //if (checkIfShrinking(amplitude) && canShrink) {
      //  shrink(100);
      //}
      //else {
      //  shrink(10000);
      //}
    }
  }

  void grow(int time) {
    int t = millis() + time;
    canGrow = false;

    while (millis() <= t) {
      //println("Timer: " + (t-millis()));
      if (headscale < 100.0) {

        headscale += 0.0001;
      }

      if (millis() == t) {
        canShrink = true;
      }
    }
  }

  void shrink(int time) {
    int t = millis() + time;

    while (millis() <= t) {
      //println("Timer: " + (t-millis()));
      if (headscale > 20.0) {
        headscale -= 0.0001;
      }

      if (millis() == t) {
        canGrow = true;
      }
    }
  }

  void updateHead() {
    PVector head_new = getKeypoint("nose");

    float d = checkDistance(headPos, head_new);
    if (d < 500.0) {
      headPos.lerp(head_new, 0.5);
    } else {
      headPos = head_new;
    }
  }

  boolean checkIfGrowing(float amplitude) {
    //println(amplitude);

    return amplitude > GLOBAL_AMP_THRESHOLD;
  }

  boolean checkIfShrinking(float amplitude) {
    //println(amplitude);

    return amplitude < GLOBAL_AMP_THRESHOLD_SHRINK;
  }
  void drawKeypoints() {
    Iterator it = pose.entrySet().iterator();
    while (it.hasNext()) {
      Map.Entry pair = (Map.Entry)it.next();
      //System.out.println(pair.getKey() + " = " + pair.getValue());
      PVector position = (PVector)pair.getValue();
      //setKeypoint(
      text((String)pair.getKey(), position.x+10.0, position.y+10.0);
      ellipse(position.x, position.y, 10, 10);
      //it.remove(); // avoids a ConcurrentModificationException
    }
  }

  float checkDistance(PVector point1, PVector point2) {
    float d = PVector.dist(point1, point2);
    if ( d < 0.0001) {
      life--;
      if (life <= 0) {
        alive = false;
      }
    } else {
      life = 5;
      alive = true;
    }
    return d;
  }

  //Create a PVector for each keypoint, lerp with previous point.
  PVector getKeypoint(String point) {
    PVector ret = this.pose.get(point) != null ? (PVector)this.pose.get(point) : new PVector(-1000, -1000);
    return ret;
  }
}