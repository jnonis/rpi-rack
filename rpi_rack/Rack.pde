

public class Rack extends PagerView {
  PApplet parent;
  OSCManager oscManager;
  private ArrayList<Module> modules = new ArrayList();
  private ArrayList<Connection> connections = new ArrayList();
  private ConnectionPlug currentIn;
  private ConnectionPlug currentOut;
  
  public Rack(PApplet parent, OSCManager oscManager) {
    this.parent = parent;
    this.oscManager = oscManager;
  }
  
  public void setup(PApplet parent) {
    super.setup(parent);
    updateRack();
  }
  
  public Module getModule(String name) {
    for (Module m : modules) {
      if (m.getName().equals(name)) {
        return m;
      }
    }
    return null;
  }
  
  public Module getModuleById(int id) {
    for (Module m : modules) {
      if (m.id == id) {
        return m;
      }
    }
    return null;
  }
  
  void oscEvent(OscMessage msg) {
    if(msg.addrPattern().startsWith("/modules")) {
      String name = msg.get(0).stringValue().split("/")[1];
      int id = msg.get(1).intValue();
      println(name);
      addModule(name, id);
    } else if(msg.addrPattern().startsWith("/connection")) {
      ConnectionPlug out = new ConnectionPlug(
          msg.get(0).intValue(),
          msg.get(1).intValue());
      ConnectionPlug in = new ConnectionPlug(
          msg.get(2).intValue(),
          msg.get(3).intValue());
      Connection connection = new Connection(out, in);
      connections.add(connection);
      Module module = getModuleById(out.module); //<>// //<>//
      if (module == null) {
        println("Module out null: " + out.module);
      } else {
        module.setConnectionOut(out.let);
      }
      module = getModuleById(in.module);
      if (module == null) {
        println("Module in null: " + in.module);
      } else {
        module.setConnectionIn(in.let);
      }
    } else {
      Module module = null;
      for (Module m : modules) {
        String path = "/" + m.getName().replaceAll("-module", "");
        if (msg.addrPattern().startsWith(path)) {
          module = m;
          break;
        }
      }
      if (module != null) {
        module.oscEvent(msg);
      }
    }
  }
  
  public void updateRack() {
    for (Module m : modules) { //<>// //<>//
      m.clearConnections();
    }
    connections.clear();
    oscManager.send("/list-rack");
  }
  
  public void setConnectionIn(String module, int inlet) {
    int id = getModule(module).getId();
    currentIn = new ConnectionPlug(id, inlet);
    sendConnection();
  }
  
  public void setConnectionOut(String module, int outlet) {
    int id = getModule(module).getId();
    currentOut = new ConnectionPlug(id, outlet);
    sendConnection();
  }
  
  public void sendConnection() {
    if (currentOut != null && currentIn != null) {
      for (Connection c : connections) {
        if (c.in.module == currentIn.module
            && c.in.let == currentIn.let
            && c.out.module == currentOut.module
            && c.out.let == currentOut.let) {
          currentIn = null;
          currentOut = null;
          return;
        }
      }
      oscManager.sendConnection("/connection",
          currentOut.module, currentOut.let,
          currentIn.module, currentIn.let);
      currentIn = null;
      currentOut = null;
      updateRack();
    }
  }
  
  public void disconnectIn(String name, int inlet) {
    Module module = getModule(name);
    for (Connection c : connections) {
      if (c.in.module == module.id && c.in.let == inlet) {
        oscManager.sendDisconnection("/disconnect",
            c.out.module, c.out.let,
            c.in.module, c.in.let);
      }
    }
    updateRack();
  }
  
  public void disconnectOut(String name, int outlet) {
    Module module = getModule(name);
    for (Connection c : connections) {
      if (c.out.module == module.id && c.out.let == outlet) {
        oscManager.sendDisconnection("/disconnect",
            c.out.module, c.out.let,
            c.in.module, c.in.let);
      }
    }
    updateRack();
  }
  
  void addModule(String name, int id) {
    for (Module module : modules) {
      if (module.getName().equals(name)) {
        module.setId(id);
        return;
      }
    }
    
    Module module = null;
    switch (name) {
      case Audio.NAME:
        module = new Audio(this, id);
        break;
      case Plaits.NAME:
        module = new Plaits(this, id);
        break;
      case Scope.NAME:
        module = new Scope(this, id);
        break;
      case MidiIO.NAME:
        module = new MidiIO(this, id);
        break;
    }
    if (module != null) {
      module.setup(parent);
      modules.add(module);
      // FIXME
      addView(module);
    }
  }
  
  public void onButton(int index, int value) {
    modules.get(current).onButton(index, value);
  }

  public void onEncoder(int index, int value) {
    modules.get(current).onEncoder(index, value);
  }
}

public abstract class Module extends ViewGroup {
  protected Rack rack;
  protected int id;
  protected ArrayList<JackInputView> inJacks = new ArrayList();
  protected ArrayList<JackInputView> outJacks = new ArrayList();
  
  public Module(Rack rack, int id) {
    this.rack = rack;
    this.id = id;
  }
  
  public int getId() {
    return id;
  }
  
  public void setId(int id) {
    this.id = id;
  }
  
  public abstract String getName();
  
  void oscEvent(OscMessage msg) {
  }
  
  void clearConnections() {
    for (int i = 0; i < inJacks.size(); i++) {
      inJacks.get(i).setConnected(false);
    }
    for (int i = 0; i < outJacks.size(); i++) {
      outJacks.get(i).setConnected(false);
    }
  }
  
  void setConnectionIn(int inlet) {
    if (inlet < inJacks.size()) {
      inJacks.get(inlet).setConnected(true);
    }
  }
  
  void setConnectionOut(int outlet) {
    if (outlet < outJacks.size()) {
      outJacks.get(outlet).setConnected(true);
    }
  }
  
  public void onButton(int index, int value) {
  }

  public void onEncoder(int index, int value) {
  }
}

public class Connection {
  ConnectionPlug out;
  ConnectionPlug in;
  
  public Connection(ConnectionPlug out, ConnectionPlug in) {
    this.out = out;
    this.in = in;
  }
}

public class ConnectionPlug {
  protected int module;
  protected int let;
  
  public ConnectionPlug(int module, int let) {
    this.module = module;
    this.let = let;
  }
}
