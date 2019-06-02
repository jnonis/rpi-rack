import com.rack.p5gui.*;

public class Audio extends Module {
  public static final String NAME = "audio~-module";
  private KnobView inLeftView;
  private KnobView inRightView;
  private KnobView outLeftView;
  private KnobView outRightView;
  
  public Audio(Rack rack, int id) {
    super(rack, id);
    inLeftView = new KnobView(80, 40, 40, "In Left", this, "onInLeft");
    inRightView = new KnobView(80, 120, 40, "In Right", this, "onInRight");
    outLeftView = new KnobView(190, 40, 40, "Out Left", this, "onOutLeft");
    outRightView = new KnobView(190, 120, 40, "Out Right", this, "onOutRight");
    
    addView(inLeftView);
    addView(inRightView);
    addView(outLeftView);
    addView(outRightView);
    
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
    
    jack = new JackInputView(170, 340, 30, "Out L", this, "onOutLeftClick");
    addView(jack);
    inJacks.add(jack);
    jack = new JackInputView(230, 340, 30, "Out R", this, "onOutRightClick");
    addView(jack);
    inJacks.add(jack);
    
    jack = new JackInputView(170, 260, 30, "CV Out 1", this, "onCVOut1Click");
    addView(jack);
    inJacks.add(jack);
    jack = new JackInputView(230, 260, 30, "CV Out 2", this, "onCVOut2Click");
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
  
  public void onCVIn1Click(boolean isLong) {
    if (isLong) {
    } else {
      rack.setConnectionOut(NAME, 2);
    }
  }
  
  public void onCVIn2Click(boolean isLong) {
    if (isLong) {
    } else {
      rack.setConnectionOut(NAME, 3);
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
  
  public void onCVOut1Click(boolean isLong) {
    if (isLong) {
    } else {
      rack.setConnectionIn(NAME, 2);
    }
  }
  
  public void onCVOut2Click(boolean isLong) {
    if (isLong) {
    } else {
      rack.setConnectionIn(NAME, 3);
    }
  }
  
  public void onEncoder(int index, int value) {
    switch (index) {
      case 3:
        inLeftView.setValue(inLeftView.getValue() + value);
        onInLeft(inLeftView.getValue(), false);
        break;
      case 2:
        inRightView.setValue(inRightView.getValue() + value);
        onInRight(inRightView.getValue(), false);
        break;
      case 1:
        outLeftView.setValue(outLeftView.getValue() + value);
        onOutLeft(outLeftView.getValue(), false);
        break;
      case 0:
        outRightView.setValue(outRightView.getValue() + value);
        onOutRight(outRightView.getValue(), false);
        break;
    }
  }
}
