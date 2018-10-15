import websockets.*;
import java.util.Map;
import java.util.Iterator;
// Note the HashMap's "key" is a String and "value" is an Integer
WebsocketClient wsc;
int now;
boolean newEllipse;

JSONArray poses;
int poses_size = 0;
//ArrayList<HashMap> parsedPoses = new ArrayList<HashMap>();
HashMap[] parsedPoses = new HashMap[10];
HashMap[] posesHistory = new HashMap[10];

color[] palette = {#ff00ff, #ff0000, #0000ff, #00ff00, #ffff00};
HashMap<String, Creature> critters = new HashMap<String, Creature>();

void setup() {
  size(1280, 720, P2D);
  wsc= new WebsocketClient(this, "ws://localhost:8080");
}

void draw() {
  background(255, 255, 0);
  fill(0);

  drawCreatures();
}



void drawCreatures() {

  if (critters.size() > 0 ) {
    for (Map.Entry me : critters.entrySet()) {
       Creature c = (Creature) me.getValue();
       c.draw();
    }
  }
}