package com.rack.p5gui;

import processing.core.PApplet;

public class JackInputView extends ButtonView {
    private String label;
    protected int labelColor = 0;
    protected int labelSize = 12;
    protected boolean connected;

    public JackInputView(int x, int y, int size, String title, Object listener, String callback) {
        super(x, y, size, title, listener, callback);
    }

    public void draw(PApplet parent) {
        parent.pushMatrix();
        parent.translate(x, y);

        if (isPressed) {
            parent.fill(127);
        } else if (connected) {
            parent.fill(255, 0, 0);
        } else {
            parent.fill(255);
        }
        parent.ellipseMode(PApplet.CORNER);
        parent.ellipse(0, 0, size, size);
        parent.fill(0);
        parent.ellipse(0, 0, size / 2, size / 2);

        parent.fill(0);
        parent.textSize(12);
        parent.textAlign(PApplet.CENTER, PApplet.TOP);
        parent.text(title, 0, (size / 2) + 8);

        if (label != null) {
            parent.fill(labelColor);
            parent.textSize(labelSize);
            parent.textAlign(PApplet.CENTER, PApplet.CENTER);
            parent.text(label, 0, 0);
        }

        parent.popMatrix();
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public void setConnected(boolean connected) {
        this.connected = connected;
    }
}
