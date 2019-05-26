package com.rack.p5gui;

import processing.core.PApplet;
import processing.core.PImage;

import java.lang.reflect.Method;

public abstract class ImageToggleView extends View {
    private PImage imageOn;
    private PImage imageOff;
    private int width;
    private int height;
    protected Object listener;
    protected String callback;
    protected Method method;
    private boolean isOn;
    private boolean isPressed;

    public ImageToggleView(int x, int y, Object listener, String callback) {
        this.x = x;
        this.y = y;
        this.listener = listener;
        this.callback = callback;
    }

    @Override
    public void setup(PApplet pApplet) {
        if (listener != null && callback != null) {
            try {
                method = listener.getClass().getMethod(callback, boolean.class);
            } catch(Exception e) { e.printStackTrace(); }
        }

        imageOn = createImageOn(pApplet);
        imageOff = createImageOff(pApplet);
        width = imageOn.width;
        height = imageOn.height;
    }

    @Override
    public void draw(PApplet pApplet) {
        pApplet.pushMatrix();
        pApplet.imageMode(PApplet.CORNER);
        pApplet.translate(x, y);

        PImage image = isOn ? imageOn : imageOff;
        pApplet.image(image, 0, 0);
        pApplet.popMatrix();

        pApplet.imageMode(PApplet.CORNER);
    }

    @Override
    public boolean mousePressed(int mouseX, int mouseY) {
        if (mouseX > x && mouseX < x + width
                && mouseY > y && mouseY < y + height) {
            isPressed = true;
            return true;
        }
        return false;
    }

    @Override
    public boolean mouseDragged(int mouseX, int mouseY) {
        if (isPressed) {
            return true;
        }
        return false;
    }

    @Override
    public boolean mouseReleased(int mouseX, int mouseY) {
        if (isPressed) {
            isPressed = false;
            if (mouseX > x && mouseX < x + width
                    && mouseY > y && mouseY < y + height) {
                isOn = !isOn;
                if (method != null) {
                    long now = System.currentTimeMillis();
                    try {
                        method.invoke(listener, new Object[] { isOn });
                    } catch(Exception e) { e.printStackTrace(); }
                }
                return true;
            }
        }
        return false;
    }

    public void setOn(boolean value) {
        isOn = value;
    }

    public boolean isOn() {
        return isOn;
    }

    public int getWidth() {
        return width;
    }

    protected abstract PImage createImageOn(PApplet parent);

    protected abstract PImage createImageOff(PApplet parent);
}
