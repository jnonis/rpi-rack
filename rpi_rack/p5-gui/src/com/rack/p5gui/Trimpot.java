package com.rack.p5gui;

import processing.core.PApplet;
import processing.core.PImage;

public class Trimpot extends ImageKnobView {

    public Trimpot(int x, int y, Object listener, String callback) {
        super(x, y, listener, callback);
        labelSize = 10;
        labelColor = 255;
    }

    public Trimpot(int x, int y, String label, Object listener, String callback) {
        super(x, y, label, listener, callback);
        labelSize = 10;
        labelColor = 255;
    }

    @Override
    protected PImage loadImage(PApplet pApplet) {
        return ResourceUtils.loadPImageARGBFromClasspath("Trimpot.png");
    }
}
