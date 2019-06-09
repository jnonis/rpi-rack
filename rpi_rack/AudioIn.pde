import com.rack.p5gui.*;

public class AudioIn extends Module {
  public static final String NAME = "audio-in~-module";
  private KnobView inLeftView;
  private KnobView inRightView;
  
  public AudioIn(Rack rack, int id) {
    super(rack, id);
    inLeftView = new KnobView(80, 40, 40, "In Left", this, "onInLeft");
    inRightView = new KnobView(80, 120, 40, "In Right", this, "onInRight");
    
    addView(inLeftView);
    addView(inRightView);
    
    JackInputView jack = new JackInputView(55, 340, 30, "In L", this, "onInLeftClick");
    addView(jack);
    outJacks.add(jack);
    jack = new JackInputView(110, 340, 30, "In R", this, "onInRightClick");
    addView(jack);
    outJacks.add(jack);
    
    jack = new JackInputView(55, 260, 30, "CV In 1", this, "onCVIn1Click");
    addView(jack);
    outJacks.add(jack);
    jack = new JackInputView(110, 260, 30, "CV In 2", this, "onCVIn2Click");
    addView(jack);
    outJacks.add(jack);
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
  
  public void onInLeftClick(boolean isLong) {
    if (isLong) {
      rack.disconnectOut(NAME, 0);
    } else {
      rack.setConnectionOut(NAME, 0);
    }
  }
  
  public void onInRightClick(boolean isLong) {
    if (isLong) {
      rack.disconnectOut(NAME, 1);
    } else {
      rack.setConnectionOut(NAME, 1);
    }
  }
  
  public void onCVIn1Click(boolean isLong) {
    if (isLong) {
      rack.disconnectOut(NAME, 2);
    } else {
      rack.setConnectionOut(NAME, 2);
    }
  }
  
  public void onCVIn2Click(boolean isLong) {
    if (isLong) {
      rack.disconnectOut(NAME, 3);
    } else {
      rack.setConnectionOut(NAME, 3);
    }
  }
  
  public void onEncoder(int index, int value) {
    switch (index) {
      case 0:
        inLeftView.setValue(inLeftView.getValue() + value);
        onInLeft(inLeftView.getValue(), false);
        break;
      case 1:
        inRightView.setValue(inRightView.getValue() + value);
        onInRight(inRightView.getValue(), false);
        break;
    }
  }
}
