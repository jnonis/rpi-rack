import com.rack.p5gui.*;

public class Audio extends Module {
  public static final String NAME = "audio~-module";
  
  public Audio(Rack rack, int id) {
    super(rack, id);
    addView(new KnobView(100, 40, 40, "In Left", this, "onInLeft"));
    addView(new KnobView(100, 120, 40, "In Right", this, "onInRight"));
    addView(new KnobView(190, 40, 40, "Out Left", this, "onOutLeft"));
    addView(new KnobView(190, 120, 40, "Out Right", this, "onOutRight"));
    
    JackInputView jack = new JackInputView(80, 340, 30, "In L", this, "onInLeftClick");
    addView(jack);
    outJacks.add(jack);
    jack = new JackInputView(130, 340, 30, "In R", this, "onInRightClick");
    addView(jack);
    outJacks.add(jack);
    jack = new JackInputView(180, 340, 30, "Out L", this, "onOutLeftClick");
    addView(jack);
    inJacks.add(jack);
    jack = new JackInputView(230, 340, 30, "Out R", this, "onOutRightClick");
    addView(jack);
    inJacks.add(jack);
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
