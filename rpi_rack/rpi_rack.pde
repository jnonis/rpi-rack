import com.rack.p5gui.*;

OSCManager oscManager;
P5GUI gui;
Rack rack;
GPIOControl control;

void setup() {
  size(320,480);
  //fullScreen();
  frameRate(15);
  smooth();
  
  oscManager = new OSCManager(this);
  
  gui = new P5GUI(this);
  rack = new Rack(this, oscManager);
  gui.addView(rack);
    
  gui.addView(new ButtonView(0, 440, 40, "Prev", this, "onPreviousPage"));
  gui.addView(new ButtonView(280, 440, 40, "Next", this, "onNextPage"));
  gui.setup();
  
  control = new GPIOControl();
  control.attachButtonListener(this, "onButton");
  control.attachEncoderListener(this, "onEncoder");
}

void draw() {
}

void oscEvent(OscMessage msg) {
  rack.oscEvent(msg);
}

void onPreviousPage(boolean isLongClick) {
  rack.previous();
}

void onNextPage(boolean isLongClick) {
  rack.next();
}

void onButton(int index, int value) {
  rack.onButton(index, value);
}

void onEncoder(int index, int value) {
  rack.onEncoder(index, value);
}
