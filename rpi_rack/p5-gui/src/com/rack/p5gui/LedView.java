package com.rack.p5gui;

import processing.core.PApplet;


public class LedView extends View {
    private int size;
    private int color = 127;

    public LedView(int x, int y, int size) {
        this.x = x;
        this.y = y;
        this.size = size;
    }

    @Override
    public void setup(PApplet parent) {
    }

    @Override
    public void draw(PApplet parent) {
        parent.pushMatrix();
        parent.translate(x, y);

        parent.fill(127);
        parent.ellipse(0, 0, size, size);
        parent.fill(color);
        parent.ellipse(0, 0, size, size);

        parent.popMatrix();
    }

    public void setColor(int color) {
        this.color = color;
    }
}
