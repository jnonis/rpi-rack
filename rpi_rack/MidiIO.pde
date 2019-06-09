import com.rack.p5gui.*;

public class MidiIO extends Module {
  public static final String NAME = "midi-io-module";
  
  public MidiIO(Rack rack, int id) {
    super(rack, id);
    addView(new LabelView(30, 30, "MIDI IN"));
    JackInputView jack = new JackInputView(40, 340, 30, "Note", this, "onNote");
    addView(jack);
    outJacks.add(jack);
    jack = new JackInputView(90, 340, 30, "CV", this, "onCV");
    addView(jack);
    outJacks.add(jack);
    jack = new JackInputView(140, 340, 30, "Gate", this, "onGate");
    addView(jack);
    outJacks.add(jack);
    jack = new JackInputView(190, 340, 30, "Trig", this, "onTrigger");
    addView(jack);
    outJacks.add(jack);
    jack = new JackInputView(240, 340, 30, "Vel", this, "onVelocity");
    addView(jack);
    outJacks.add(jack);
  }
  
  public String getName() {
    return NAME;
  }
  
  public void onNote(boolean isLong) {
    if (isLong) {
      rack.disconnectOut(NAME, 0);
    } else {
      rack.setConnectionOut(NAME, 0);
    }
  }
  
  public void onCV(boolean isLong) {
    if (isLong) {
      rack.disconnectOut(NAME, 1);
    } else {
      rack.setConnectionOut(NAME, 1);
    }
  }
  
  public void onGate(boolean isLong) {
    if (isLong) {
      rack.disconnectOut(NAME, 2);
    } else {
      rack.setConnectionOut(NAME, 2);
    }
  }
  
  public void onTrigger(boolean isLong) {
    if (isLong) {
      rack.disconnectOut(NAME, 3);
    } else {
      rack.setConnectionOut(NAME, 3);
    }
  }
  
  public void onVelocity(boolean isLong) {
    if (isLong) {
      rack.disconnectOut(NAME, 4);
    } else {
      rack.setConnectionOut(NAME, 4);
    }
  }
}
