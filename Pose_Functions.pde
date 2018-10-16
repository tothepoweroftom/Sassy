//Incoming data from websocket poses.

void webSocketEvent(String msg) {


  JSONObject json = parseJSONObject(msg);
  poses = json.getJSONArray("poses");
  poses_size =0;
  if (poses.size() > 0) {
    for (int i=0; i<poses.size(); i++) {
      JSONObject pose = poses.getJSONObject(i);
      if (pose.getFloat("score") > 0.15) {
        parsePose(pose, i);
        poses_size++;
      }
    }
  }
  //println("poses length: " + poses_size + " , " + "creatures length: " + critters.size());
  //Want to remove a pose if no longer detected. 
}


// Parse the websocket JSON for the data.
void parsePose(JSONObject pose, int index) {
  HashMap<String, PVector> hm = new HashMap<String, PVector>();
  JSONArray keypoints = pose.getJSONArray("keypoints");
  for (int i = 0; i<keypoints.size(); i++) {
    PVector pos = new PVector(keypoints.getJSONObject(i).getJSONObject("position").getFloat("x"), keypoints.getJSONObject(i).getJSONObject("position").getFloat("y"));
    if (keypoints.getJSONObject(i).getFloat("score") > 0.15) {
      hm.put(keypoints.getJSONObject(i).getString("part"), pos);
    }
  }
  // SET HISTORY  
  parsedPoses[index] = hm;
  setKeypoints();
}


void setKeypoints() {
  float amplitude = calculateAverageAmplitude();
  //Get nose from parsedPoses and History
  for (int i = 0; i<parsedPoses.length; i++) {
    if (parsedPoses[i] != null) {
      if (critters.get(str(i)) == null) {
        critters.put(str(i), new Creature(parsedPoses[i], str(i)));
      } else {
        critters.get(str(i)).update(parsedPoses[i]);
      }
    }
  }
}