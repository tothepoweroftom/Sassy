


void setup() {
  size(1280, 720);
  wsc= new WebsocketClient(this, "ws://localhost:8080");
  minim = new Minim(this);

  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();
  in.mute();

  inflate = minim.loadSample( "inflate.mp3", // filename
    512      // buffer size
    );

  deflate = minim.loadSample( "deflate.mp3", // filename
    512      // buffer size
    );
}

void draw() {
  background(255, 255, 0);
  fill(0);

  drawCreatures();
  drawDebug();
  calculateAmplitude();
}



void drawCreatures() {

  if (critters.size() > 0 ) {
    for (Map.Entry me : critters.entrySet()) {
      Creature c = (Creature) me.getValue();
      c.draw(aa);
    }
  }
}

void drawDebug() {

  String debug = "People : " + poses_size + "\n"
    + "Amplitude Level: " + aa  + "\n";
  fill(0);
  text(debug, 10, 10);
  rect(10, 60, 10, aa*500);
}

void calculateAmplitude() {
  amplitude = in.left.level() + in.right.level();
  addToBuffer(amplitude);
  aa = calculateAverageAmplitude();
  if (aa > GLOBAL_AMP_THRESHOLD && sound) {
    //inflate.trigger();
    sound = false;
  }
}


void addToBuffer(float amplitude) {
  if (amplitude_buffer.size() < buffer_size) {
    amplitude_buffer.append(amplitude);
  } else if (amplitude_buffer.size() == buffer_size) {
    amplitude_buffer.remove(0);
  }
}

float calculateAverageAmplitude() {
  float ret = 0.0;
  if (amplitude_buffer.size() != 0) {

    for (int i=0; i<amplitude_buffer.size(); i++) {
      ret+=amplitude_buffer.get(i);
    }

    ret = ret/amplitude_buffer.size();
  }


  return ret;
}