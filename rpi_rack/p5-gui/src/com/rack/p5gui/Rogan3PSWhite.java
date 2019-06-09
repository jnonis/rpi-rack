package com.rack.p5gui;

import processing.core.PApplet;
import processing.core.PImage;

public class Rogan3PSWhite extends ImageKnobView {

    public Rogan3PSWhite(int x, int y, Object listener, String callback) {
        super(x, y, listener, callback);
        labelSize = 16;
    }

    public Rogan3PSWhite(int x, int y, String label, Object listener, String callback) {
        super(x, y, label, listener, callback);
        labelSize = 16;
    }

    @Override
    protected PImage loadImage(PApplet pApplet) {
        return ResourceUtils.loadPImageARGBFromClasspath("Rogan3PSWhite.png");
    }
}
