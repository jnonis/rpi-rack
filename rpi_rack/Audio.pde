import com.rack.p5gui.*;

public class Audio extends Module {
  public static final String NAME = "audio~-module";
  
  public Audio(Rack rack, int id) {
    super(rack, id);
    addView(new KnobView(80, 20, 40, "In Left", this, "onInLeft"));
    addView(new KnobView(80, 100, 40, "In Right", this, "onInRight"));
    addView(new KnobView(200, 20, 40, "Out Left", this, "onOutLeft"));
    addView(new KnobView(200, 100, 40, "Out Right", this, "onOutRight"));
    
    addView(new JackInputView(40, 380, 30, "In L", this, "onInLeftClick"));
    addView(new JackInputView(100, 380, 30, "In R", this, "onInRightClick"));
    addView(new JackInputView(180, 380, 30, "Out L", this, "onOutLeftClick"));
    addView(new JackInputView(240, 380, 30, "Out R", this, "onOutRightClick"));
  }
  
  public String getName() {
    return NAME;
  }
  
  public void onInLeft(float value, boolean click) {
    if (click) {
      return;
    }
    oscManager.sendFloat("/audio~/in/1", value);
  }
  
  public void onInRight(float value, boolean click) {
    if (click) {
      return;
    }
    oscManager.sendFloat("/audio~/in/2", value);
  }
  
  public void onOutLeft(float value, boolean click) {
    if (click) {
      return;
    }
    oscManager.sendFloat("/audio~/out/1", value);
  }
  
  public void onOutRight(float value, boolean click) {
    if (click) {
      return;
    }
    oscManager.sendFloat("/audio~/out/2", value);
  }

  public void onInLeftClick(boolean isLong) {
    if (isLong) {
    } else {
      rack.setConnectionOut(NAME, 0);
    }
  }
  
  public void onInRightClick(boolean isLong) {
    if (isLong) {
    } else {
      rack.setConnectionOut(NAME, 1);
    }
  }
  
  public void onOutLeftClick(boolean isLong) {
    if (isLong) {
    } else {
      rack.setConnectionIn(NAME, 0);
    }
  }
  
  public void onOutRightClick(boolean isLong) {
    if (isLong) {
    } else {
      rack.setConnectionIn(NAME, 1);
    }
  }
}
