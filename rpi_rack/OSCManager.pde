import netP5.*;
import oscP5.*;

class OSCManager {
  private OscP5 oscP5;
  private NetAddress remote;
  
  public OSCManager(PApplet parent) {
    // Listen for incomming messages in port 4001
    oscP5 = new OscP5(parent, 4001);
    // Send messages to port 4000
    remote = new NetAddress("127.0.0.1", 4000);
  }
 //<>//
  void sendFloat(String path, float value) {
    OscMessage msg = new OscMessage(path);
    msg.add(value);
    oscP5.send(msg, remote);
  }
  
  void sendConnection(String path, float modOut, float out, float modIn, float in) {
    OscMessage msg = new OscMessage(path);
    msg.add(modOut);
    msg.add(out);
    msg.add(modIn);
    msg.add(in);
    oscP5.send(msg, remote);
  }
  
  void sendDisconnection(String path, float modOut, float out, float modIn, float in) {
    OscMessage msg = new OscMessage(path);
    msg.add(modOut);
    msg.add(out);
    msg.add(modIn);
    msg.add(in);
    oscP5.send(msg, remote);
  }
  
  void send(String path) {
    OscMessage msg = new OscMessage(path);
    oscP5.send(msg, remote);
  }
}
