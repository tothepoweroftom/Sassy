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
  println("poses length: " + poses_size + " , " + "creatures length: " + critters.size());
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
  posesHistory[index] = parsedPoses[index] != null ? parsedPoses[index] : hm;
  parsedPoses[index] = hm;
  setKeypoints();
}


//Create a PVector for each keypoint, lerp with previous point.
PVector getKeypoint(String point, int i) {
  PVector ret = parsedPoses[i].get(point) != null ? (PVector)parsedPoses[i].get(point) : new PVector(0, 0);
  if (posesHistory[i] != null) {
    PVector pointHistory = posesHistory[i].get(point) != null ? (PVector)posesHistory[i].get(point) : new PVector(0, 0);
    ret.lerp(pointHistory, 0.5);
  } 
  return ret;
}


void setKeypoints() {
  //Get nose from parsedPoses and History
  for (int i = 0; i<parsedPoses.length; i++) {
    if (parsedPoses[i] != null) {
      PVector nose = getKeypoint("nose", i);
      PVector leftEar = getKeypoint("leftEar", i);
      PVector rightEar = getKeypoint("rightEar", i);

      if (critters.get(str(i)) == null) {
        critters.put(str(i), new Creature(nose, str(i)));
      } else {
        critters.get(str(i)).update(nose);
      }
    }
  }
}