class Creature {
  PImage head;
  PVector headPos;
  PImage body;
  boolean alive;
  int life;

  String number;
  Creature(PVector nose, String _number) {
    head = loadImage("head.png");
    body = loadImage("body.png");

    headPos = nose;
    number = _number;
    alive = true ;
    life = 5;
  }

  void update(PVector point) {

    checkDistance(point);
    headPos.lerp(point, 0.5);
  }

  void draw() {
    if (this.life > 0) {
      tint(255,life*51);
      text("pose: " + number, headPos.x, headPos.y);
      image(head, headPos.x, headPos.y, 100, 140);
      image(body, headPos.x, headPos.y+110, 120, 240);
    }
  }
  
  void checkDistance(PVector point){
    float d = PVector.dist(headPos, point);
    println("disatnce: " + d);
    if( d < 0.0001) {
      life--;
      if(life <= 0) {
       alive = false; 
      }
    } else {
      d = 50;
    }
  }
}