package com.rack.p5gui;

import processing.core.PApplet;

public class LabelView extends View {
    private String text;

    public LabelView(int x, int y, String text) {
        this.x = x;
        this.y = y;
        this.text = text;
    }

    @Override
    public void setup(PApplet parent) {
    }

    @Override
    public void draw(PApplet parent) {
        parent.pushMatrix();
        parent.textAlign(PApplet.TOP, PApplet.RIGHT);
        parent.text(text, x, y);
        parent.popMatrix();
    }
}
