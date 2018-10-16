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

Minim minim;
AudioInput in;
AudioSample inflate;
AudioSample deflate;
boolean sound = true;

float amplitude;
FloatList amplitude_buffer = new FloatList();
int buffer_size = 32;
float aa;

float GLOBAL_AMP_THRESHOLD = 0.1;
float GLOBAL_AMP_THRESHOLD_SHRINK = 0.1;