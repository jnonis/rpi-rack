package com.rack.p5gui;

import processing.core.PApplet;
import processing.core.PImage;

public class Rogan2PSGreen extends ImageKnobView {

    public Rogan2PSGreen(int x, int y, Object listener, String callback) {
        super(x, y, listener, callback);
        labelSize = 14;
    }

    public Rogan2PSGreen(int x, int y, String label, Object listener, String callback) {
        super(x, y, label, listener, callback);
        labelSize = 14;
    }

    @Override
    protected PImage loadImage(PApplet pApplet) {
        return ResourceUtils.loadPImageARGBFromClasspath("Rogan2PSGreen.png");
    }
}
