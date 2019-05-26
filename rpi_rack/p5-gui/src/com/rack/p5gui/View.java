package com.rack.p5gui;

import processing.core.PApplet;

public abstract class View {
    protected int x;
    protected int y;
    protected boolean visible = true;
    protected boolean enable = true;

    public abstract void setup(PApplet parent);

    public abstract void draw(PApplet parent);

    public void setPosition(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public void setVisible(boolean visible) {
        this.visible = visible;
    }

    public void setEnable(boolean enable) {
        this.enable = enable;
    }

    public boolean mousePressed(int mouseX, int mouseY) {
        return false;
    }

    public boolean mouseDragged(int mouseX, int mouseY) {
        return false;
    }

    public boolean mouseReleased(int mouseX, int mouseY) {
        return false;
    }

    public boolean mouseClicked(int mouseX, int mouseY) {
        return false;
    }
}
