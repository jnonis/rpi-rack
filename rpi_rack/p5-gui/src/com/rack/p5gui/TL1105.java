package com.rack.p5gui;

import processing.core.PApplet;
import processing.core.PImage;

public class TL1105 extends ImageButtonView {

    public TL1105(int x, int y, Object listener, String callback) {
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
