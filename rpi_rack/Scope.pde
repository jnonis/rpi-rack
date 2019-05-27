import com.rack.p5gui.*;

public class Scope extends Module {
  public static final String NAME = "scope~-module";
  private ScopeView scopeView;
  
  public Scope(Rack rack, int id) {
    super(rack, id);
    
    scopeView = new ScopeView(30, 30);
    
    addView(scopeView);
    JackInputView jack = new JackInputView(40, 380, 30, "In", this, "onInClick");
    addView(jack);
    inJacks.add(jack);
  }
    
  public String getName() {
    return NAME;
  }
  
  public void onInClick(boolean isLong) {
    if (isLong) {
      rack.disconnectIn(NAME, 0);
    } else {
      rack.setConnectionIn(NAME, 0);
    }
  }
  
  public void addValue(float value) {
    scopeView.addValue(value);
  }
  
  void oscEvent(OscMessage msg) {
    Object[] args = msg.arguments();
    for (int i = 0; i < args.length; i++) {
      Number n = (Number) args[i];
      float value = n.floatValue();
      addValue(value);
    }
  }
}

public class ScopeView extends View {
  private float[] array = new float[512];
  private int index = 0;
  private PGraphics graphic;

  public ScopeView(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public void setup(PApplet parent) {
    println("Scope setup");
    graphic = parent.createGraphics(array.length, 128);
    println(this.graphic);
  }

  public void draw(PApplet parent) {
    parent.pushMatrix();
    parent.translate(x, y);
    
    graphic.beginDraw();
    graphic.background(255);
    int current = index;
    for (int i = 1; i < array.length; i++) {
      int ci = current + i;
      if (ci >= array.length) {
        ci = ci - array.length + 1;
      }
      graphic.line((ci - 1), (array[ci - 1] * 128f) + 64f, ci, (array[ci] * 128f) + 64f);
    }
    graphic.endDraw();
    parent.scale(0.5, 1);
    parent.image(this.graphic, 0, 0);
    
    parent.stroke(0);
    parent.noFill();
    parent.scale(2, 1);
    parent.rect(0, 0, 256, 128);
    parent.fill(0);
    
    parent.popMatrix(); //<>//
  }
  
  public void addValue(float value) {
    array[index] = value;
    index++;
    if (index >= array.length) {
      index = 0;
    }
  }
}
