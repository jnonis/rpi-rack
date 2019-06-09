import com.rack.p5gui.*;

public class Plaits extends Module implements Pageable {
  public static final String NAME = "plts~-module";
  private PImage background;
  
  private TL1105 model1View;
  private TL1105 model2View;
  
  private Rogan3PSWhite freqView;
  private Rogan3PSWhite harmonicsView;
  
  private Rogan1PSWhite timbreView;
  private Rogan1PSWhite morphView;
  private Rogan1PSRed lpgView;
  private Rogan1PSRed decayView;
  
  private Trimpot modTimbreView;
  private Trimpot modFMView;
  private Trimpot modMorphView;
  
  private JackInputView outView;
  private JackInputView auxView;
  
  private int model = 0;
  private ArrayList<LedView> leds = new ArrayList();
  private int model1Color;
  private int model2Color;
  
  private int currentControls;
  
  public Plaits(Rack rack, int id) {
    super(rack, id);
    model1View = new TL1105(133, 60, this, "onModel1");
    model2View = new TL1105(166, 60, this, "onModel2");
    freqView = new Rogan3PSWhite(60, 80, this, "onFrequency");
    harmonicsView = new Rogan3PSWhite(194, 80, this, "onHarmonics");
    timbreView = new Rogan1PSWhite(64, 190, this, "onTimbre");
    morphView = new Rogan1PSWhite(204, 190, this, "onMorph");
    lpgView = new Rogan1PSRed(64, 190, this, "onLPG");
    lpgView.setVisible(false);
    decayView = new Rogan1PSRed(204, 190, this, "onDecay");
    decayView.setVisible(false);
    modTimbreView = new Trimpot(76, 290, this, "onTimbreMod");
    modFMView = new Trimpot(148, 290, this, "onFMMod");
    modMorphView = new Trimpot(220, 290, this, "onMorphMod");
    
    outView = new JackInputView(187, 401, 30, "", this, "onOutClick");
    auxView = new JackInputView(229, 401, 30, "", this, "onAuxClick");
    
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
    // FIXME
    inJacks.add(new JackInputView(61, 347, 30, "", this, null));
    JackInputView jack = new JackInputView(61, 347, 30, "", this, "onModelIn");
    addView(jack);
    inJacks.add(jack);
    jack = new JackInputView(103, 347, 30, "", this, "onTimbreIn");
    addView(jack);
    inJacks.add(jack);
    jack = new JackInputView(145, 347, 30, "", this, "onFMIn");
    addView(jack);
    inJacks.add(jack);
    jack = new JackInputView(187, 347, 30, "", this, "onMorphIn");
    addView(jack);
    inJacks.add(jack);
    jack = new JackInputView(229, 347, 30, "", this, "onHarmonicsIn");
    addView(jack);
    inJacks.add(jack);
    jack = new JackInputView(61, 401, 30, "", this, "onTriggerIn");
    addView(jack);
    inJacks.add(jack);
    jack = new JackInputView(103, 401, 30, "", this, "onLevelIn");
    addView(jack);
    inJacks.add(jack);
    jack = new JackInputView(145, 401, 30, "", this, "onVOctIn");
    addView(jack);
    inJacks.add(jack);
    addView(outView);
    addView(auxView);
    
    outJacks.add(outView);
    outJacks.add(auxView);
    
    for (int i = 0; i < 8; i++) {
      LedView led = new LedView(153, (int) (87 + (20.4 * i)), 10);
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
  
  public void onModelIn(boolean isLong) {
    if (isLong) {
      rack.disconnectIn(NAME, 1);
    } else {
      rack.setConnectionIn(NAME, 1);
    }
  }
  
  public void onTimbreIn(boolean isLong) {
    if (isLong) {
      rack.disconnectIn(NAME, 2);
      oscManager.sendFloat("/plts~/timbre/active", 0);
    } else {
      rack.setConnectionIn(NAME, 2);
      oscManager.sendFloat("/plts~/timbre/active", 1);
    }
  }
  
  public void onFMIn(boolean isLong) {
    if (isLong) {
      rack.disconnectIn(NAME, 3);
      oscManager.sendFloat("/plts~/fm/active", 0);
    } else {
      rack.setConnectionIn(NAME, 3);
      oscManager.sendFloat("/plts~/fm/active", 1);
    }
  }
  
  public void onMorphIn(boolean isLong) {
    if (isLong) {
      rack.disconnectIn(NAME, 4);
      oscManager.sendFloat("/plts~/morph/active", 0);
    } else {
      rack.setConnectionIn(NAME, 4);
      oscManager.sendFloat("/plts~/morph/active", 1);
    }
  }
  
  public void onHarmonicsIn(boolean isLong) {
    if (isLong) {
      rack.disconnectIn(NAME, 5);
    } else {
      rack.setConnectionIn(NAME, 5);
    }
  }
  
  public void onTriggerIn(boolean isLong) {
    if (isLong) {
      rack.disconnectIn(NAME, 6);
      oscManager.sendFloat("/plts~/trigger/active", 0);
    } else {
      rack.setConnectionIn(NAME, 6);
      oscManager.sendFloat("/plts~/trigger/active", 1);
    }
  }
  
  public void onLevelIn(boolean isLong) {
    if (isLong) {
      rack.disconnectIn(NAME, 7);
      oscManager.sendFloat("/plts~/level/active", 0);
    } else {
      rack.setConnectionIn(NAME, 7);
      oscManager.sendFloat("/plts~/level/active", 1);
    }
  }
  
  public void onVOctIn(boolean isLong) {
    if (isLong) {
      rack.disconnectIn(NAME, 8);
    } else {
      rack.setConnectionIn(NAME, 8);
    }
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
  
  public void onButton(int index, int value) {
    switch (currentControls) {
      case 0:
        if (value == 1) {
          switch (index) {
            case 0:
              onModel1(false);
              break;
            case 1:
              onModel2(false);
              break;
            case 2:
              if (timbreView.isVisible()) {
                onTimbre(timbreView.getValue(), true);
              } else {
                onLPG(lpgView.getValue(), true);
              }
              break;
            case 3:
              if (morphView.isVisible()) {
                onMorph(morphView.getValue(), true);
              } else {
                onDecay(decayView.getValue(), true);
              }
              break;
          }
        }
        break;
      case 1:
        if (value == 1 && index == 3) {
          oscManager.sendFloat("/plts~/trigger", value);
        }
        break;
    }
  }
  
  public void onEncoder(int index, int value) {
    switch (currentControls) {
      case 0:
        switch (index) {
          case 0:
            freqView.setValue(freqView.getValue() + value);
            onFrequency(freqView.getValue(), false);
            break;
          case 1:
            harmonicsView.setValue(harmonicsView.getValue() + value);
            onHarmonics(harmonicsView.getValue(), false);
            break;
          case 2:
            if (timbreView.isVisible()) {
              timbreView.setValue(timbreView.getValue() + value);
              onTimbre(timbreView.getValue(), false);
            } else {
              lpgView.setValue(lpgView.getValue() + value);
              onLPG(lpgView.getValue(), false);
            }
            break;
          case 3:
            if (morphView.isVisible()) {
              morphView.setValue(morphView.getValue() + value);
              onMorph(morphView.getValue(), false);
            } else {
              decayView.setValue(decayView.getValue() + value);
              onDecay(decayView.getValue(), false);
            }
            break;
        }
        break;
      case 1:
        switch (index) {
          case 0:
            modTimbreView.setValue(modTimbreView.getValue() + value);
            onTimbreMod(modTimbreView.getValue(), false);
            break;
          case 1:
            modFMView.setValue(modFMView.getValue() + value);
            onFMMod(modFMView.getValue(), false);
            break;
          case 2:
            modMorphView.setValue(modMorphView.getValue() + value);
            onMorphMod(modMorphView.getValue(), false);
            break;
        }
        break;
    }
  }
}
