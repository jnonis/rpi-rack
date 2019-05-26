import com.rack.p5gui.*;

public class Plaits extends Module implements Pageable {
  public static final String NAME = "plts~-module";
  private PImage background;
  
  private ModelButtonView model1View;
  private ModelButtonView model2View;
  
  private BigKnobView freqView;
  private BigKnobView harmonicsView;
  
  private MediumKnobView timbreView;
  private MediumKnobView morphView;
  private MediumKnobRedView lpgView;
  private MediumKnobRedView decayView;
  
  private TrimpotView modTimbreView;
  private TrimpotView modFMView;
  private TrimpotView modMorphView;
  
  private JackInputView outView;
  private JackInputView auxView;
  
  private int model = 0;
  private ArrayList<LedView> leds = new ArrayList();
  private int model1Color;
  private int model2Color;
  
  private int currentControls;
  
  public Plaits(Rack rack, int id) {
    super(rack, id);
    model1View = new ModelButtonView(133, 60, this, "onModel1");
    model2View = new ModelButtonView(166, 60, this, "onModel2");
    freqView = new BigKnobView(60, 80, this, "onFrequency");
    harmonicsView = new BigKnobView(194, 80, this, "onHarmonics");
    timbreView = new MediumKnobView(64, 190, this, "onTimbre");
    morphView = new MediumKnobView(204, 190, this, "onMorph");
    lpgView = new MediumKnobRedView(64, 190, this, "onLPG");
    lpgView.setVisible(false);
    decayView = new MediumKnobRedView(204, 190, this, "onDecay");
    decayView.setVisible(false);
    modTimbreView = new TrimpotView(76, 290, this, "onTimbreMod");
    modFMView = new TrimpotView(148, 290, this, "onFMMod");
    modMorphView = new TrimpotView(220, 290, this, "onMorphMod");
    
    outView = new JackInputView(202, 416, 30, "", this, "onOutClick");
    auxView = new JackInputView(244, 416, 30, "", this, "onAuxClick");
    
    addView(model1View);
    addView(model2View);
    addView(freqView);
    addView(harmonicsView);
    addView(timbreView);
    addView(morphView);
    addView(lpgView);
    addView(decayView);
    addView(modTimbreView);
    addView(modFMView);
    addView(modMorphView);
    addView(new JackInputView(76, 362, 30, "", this, null));
    addView(new JackInputView(118, 362, 30, "", this, null));
    addView(new JackInputView(160, 362, 30, "", this, null));
    addView(new JackInputView(202, 362, 30, "", this, null));
    addView(new JackInputView(244, 362, 30, "", this, null));
    addView(new JackInputView(76, 416, 30, "", this, null));
    addView(new JackInputView(118, 416, 30, "", this, null));
    addView(new JackInputView(160, 416, 30, "", this, null));
    addView(outView);
    addView(auxView);
    
    outJacks.add(outView);
    outJacks.add(auxView);
    
    for (int i = 0; i < 8; i++) {
      LedView led = new LedView(158, (int) (92 + (20.4 * i)), 10);
      leds.add(led);
      addView(led);
    }
    model1Color = color(0, 255, 0);
    model2Color = color(255, 0, 0);
    updateLed();
    updateControls();
  }
  
  public String getName() {
    return NAME;
  }
  
  public void setup(PApplet parent) {
    super.setup(parent);
    background = parent.loadImage("plts~_background.png");
  }
  
  public void draw(PApplet parent) {
    parent.image(background, 0, 0);
    super.draw(parent);
  }

  public void onModel1(boolean isLong) {
    if (model > 8) {
      model -= 8;
    } else {
      model++;
      if (model > 7) {
        model = 0;
      }
    }
    updateLed();
    oscManager.sendFloat("/plts~/model", model);
  }
  
  public void onModel2(boolean isLong) {
    if (model < 8) {
      model += 8;
    } else {
      model++;
      if (model > 15) {
        model = 8;
      }
    }
    updateLed();
    oscManager.sendFloat("/plts~/model", model);
  }
  
  private void updateLed() {
    for(int i = 0; i < 8; i++) {
      if (i == model || i == (model - 8)) {
        if (model < 8) {
          leds.get(i).setColor(model1Color);
        } else {
          leds.get(i).setColor(model2Color);
        }
      } else {
        leds.get(i).setColor(127);
      }
    }
    println("Model: " + model);
  }
  
  public void onFrequency(float value, boolean click) {
    if (click) {
      return;
    }
    oscManager.sendFloat("/plts~/freq", (value - (ImageKnobView.MAX_VALUE / 2)) / (ImageKnobView.MAX_VALUE / 2));
  }
  
  public void onHarmonics(float value, boolean click) {
    if (click) {
      return;
    }
    oscManager.sendFloat("/plts~/harmonics", value / ImageKnobView.MAX_VALUE);
  }
  
  public void onTimbre(float value, boolean click) {
    if (click) {
      timbreView.setVisible(false);
      lpgView.setVisible(true);
      return;
    }
    oscManager.sendFloat("/plts~/timbre", value / ImageKnobView.MAX_VALUE);
  }
  
  public void onLPG(float value, boolean click) {
    if (click) {
      timbreView.setVisible(true);
      lpgView.setVisible(false);
      return;
    }
    oscManager.sendFloat("/plts~/lpg", value / ImageKnobView.MAX_VALUE);
  }
  
  public void onMorph(float value, boolean click) {
    if (click) {
      morphView.setVisible(false);
      decayView.setVisible(true);
      println("Morph click");
      return;
    }
    oscManager.sendFloat("/plts~/morph", value / ImageKnobView.MAX_VALUE);
  }
  
  public void onDecay(float value, boolean click) {
    if (click) {
      morphView.setVisible(true);
      decayView.setVisible(false);
      return;
    }
    oscManager.sendFloat("/plts~/decay", value / ImageKnobView.MAX_VALUE);
  }
  
  public void onTimbreMod(float value, boolean click) {
    if (click) {
      return;
    }
    oscManager.sendFloat("/plts~/mod/timbre", (value - (ImageKnobView.MAX_VALUE / 2)) / (ImageKnobView.MAX_VALUE / 2));
  }
  
  public void onFMMod(float value, boolean click) {
    if (click) {
      return;
    }
    oscManager.sendFloat("/plts~/mod/fm", (value - (ImageKnobView.MAX_VALUE / 2)) / (ImageKnobView.MAX_VALUE / 2));
  }
  
  public void onMorphMod(float value, boolean click) {
    if (click) {
      return;
    }
    oscManager.sendFloat("/plts~/mod/morph", (value - (ImageKnobView.MAX_VALUE / 2)) / (ImageKnobView.MAX_VALUE / 2));
  }
  
  public void onOutClick(boolean isLong) {
    if (isLong) {
      rack.disconnectOut(NAME, 0);
    } else {
      rack.setConnectionOut(NAME, 0); //<>//
    }
  }
  
  public void onAuxClick(boolean isLong) {
    if (isLong) {
      rack.disconnectOut(NAME, 1);
    } else {
      rack.setConnectionOut(NAME, 1);
    }
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
        model1View.setLabel("1");
        model2View.setLabel("2");
        freqView.setLabel("1");
        harmonicsView.setLabel("2");
        timbreView.setLabel("3");
        lpgView.setLabel("3");
        morphView.setLabel("4");
        decayView.setLabel("4");
        modTimbreView.setLabel(null);
        modFMView.setLabel(null);
        modMorphView.setLabel(null);
        break;
      case 1:
        model1View.setLabel(null);
        model2View.setLabel(null);
        freqView.setLabel(null);
        harmonicsView.setLabel(null);
        timbreView.setLabel(null);
        lpgView.setLabel(null);
        morphView.setLabel(null);
        decayView.setLabel(null);
        modTimbreView.setLabel("1");
        modFMView.setLabel("2");
        modMorphView.setLabel("3");
        break;
    } 
  }
}

public class BigKnobView extends ImageKnobView {
  
  public BigKnobView(int x, int y, Object listener, String callback) {
    super(x, y, listener, callback);
    labelSize = 16;
  }
  
  protected PImage loadImage(PApplet parent) {
    return parent.loadImage("Rogan3PSWhite.png");
  }
}

public class MediumKnobView extends ImageKnobView {
  
  public MediumKnobView(int x, int y, Object listener, String callback) {
    super(x, y, listener, callback);
    labelSize = 14;
  }
  
  protected PImage loadImage(PApplet parent) {
    return parent.loadImage("Rogan1PSWhite.png");
  }
}

public class MediumKnobRedView extends ImageKnobView {
  
  public MediumKnobRedView(int x, int y, Object listener, String callback) {
    super(x, y, listener, callback);
    labelSize = 14;
  }
  
  protected PImage loadImage(PApplet parent) {
    return parent.loadImage("Rogan1PSRed.png");
  }
}

public class TrimpotView extends ImageKnobView {
  
  public TrimpotView(int x, int y, Object listener, String callback) {
    super(x, y, listener, callback);
    labelSize = 10;
    labelColor = 255;
  }
  
  protected PImage loadImage(PApplet parent) {
    return parent.loadImage("Trimpot.png");
  }
}

public class ModelButtonView extends ImageButtonView {
  
  public ModelButtonView(int x, int y, Object listener, String callback) {
    super(x, y, listener, callback);
    labelSize = 10;
    labelColor = 255;
  }
  
  protected PImage createImageIdle(PApplet parent) {
    return parent.loadImage("TL1105_1.png");
  }
  
  protected PImage createImagePressed(PApplet parent) {
    return parent.loadImage("TL1105_0.png");
  }
}
