import com.rack.p5gui.*;

public class Braids extends Module implements Pageable {
  public static final String NAME = "brds~-module";
  private PImage background;
  private int currentControls;
  
  public Braids(Rack rack, int id) {
    super(rack, id);
    
    addView(new Segment4Display(30, 70));
    
    addView(new Rogan2SGray(231, 75, this, null));
    
    addView(new Rogan2PSWhite(33, 175, this, null));
    addView(new Rogan2PSWhite(131, 175, this, null));
    addView(new Rogan2PSWhite(231, 175, this, null));
    
    addView(new Rogan2PSGreen(33, 275, this, null));
    addView(new Rogan2PSGreen(131, 275, this, null));
    addView(new Rogan2PSRed(231, 275, this, null));
    
    addView(new JackInputView(22, 401, 30, "", this, null));
    addView(new JackInputView(68, 401, 30, "", this, null));
    addView(new JackInputView(116, 401, 30, "", this, null));
    addView(new JackInputView(162, 401, 30, "", this, null));
    addView(new JackInputView(210, 401, 30, "", this, null));
    addView(new JackInputView(267, 401, 30, "", this, null));
  }
  
  public String getName() {
    return NAME;
  }
  
  public void setup(PApplet parent) {
    super.setup(parent);
    background = parent.loadImage("brds~_background.png");
  }
  
  public void draw(PApplet parent) {
    parent.image(background, 0, 0);
    super.draw(parent);
  }
  
  public boolean onNext() {
    if (currentControls >= 1) {
      return false;
    }
    currentControls++;
    updateControls();
    return true;
  }
  
  public boolean onPrevious() {
    if (currentControls <= 0) {
      return false;
    }
    currentControls--;
    updateControls();
    return true;
  }
  
  private void updateControls() {
    switch (currentControls) {
      case 0:
        break;
      case 1:
        break;
    }
  }
}

public class Segment4Display extends View {
  private PFont font;
  
  public Segment4Display(int x, int y) {
    this.x = x;
    this.y = y;
  }

  public void setup(PApplet parent) {
    font = parent.loadFont("DSEG7Classic-Regular-36.vlw");
  }
  
  public void draw(PApplet parent) {
    parent.pushMatrix();
    parent.translate(x, y);
    
    parent.fill(56, 56, 56);
    parent.stroke(16, 16, 16);
    parent.rect(0, 0, 180, 70, 10);
    
    parent.fill(175, 210, 44);
    parent.textFont(font, 50);
    parent.textAlign(PApplet.LEFT, PApplet.TOP);
    parent.text("0000", 10, 13);

    parent.getGraphics().textFont = null;
    parent.stroke(0);
    parent.popMatrix();
  }
}
