package com.rack.p5gui;

import processing.core.PApplet;
import processing.core.PImage;

import java.lang.reflect.Method;

public abstract class ImageButtonView extends View {
    private static final long LONG_CLICK_TIME = 1500;
    private PImage imageIdle;
    private PImage imagePressed;
    private int width;
    private int height;
    private String label;
    protected int labelColor = 0;
    protected int labelSize = 12;
    protected Object listener;
    protected String callback;
    protected Method method;
    private boolean isPressed;
    protected long pressStart;

    public ImageButtonView(int x, int y, Object listener, String callback) {
        this.x = x;
        this.y = y;
        this.listener = listener;
        this.callback = callback;
    }

    @Override
    public void setup(PApplet parent) {
        if (listener != null && callback != null) {
            try {
                method = listener.getClass().getMethod(callback, boolean.class);
            } catch(Exception e) { e.printStackTrace(); }
        }

        imageIdle = createImageIdle(parent);
        imagePressed = createImagePressed(parent);
        width = imageIdle.width;
        height = imageIdle.height;
    }

    @Override
    public void draw(PApplet parent) {
        parent.pushMatrix();
        parent.imageMode(PApplet.CORNER);
        parent.translate(x, y);

        PImage image = isPressed ? imageIdle : imagePressed;
        parent.image(image, 0, 0);

        if (label != null) {
            parent.fill(labelColor);
            parent.textSize(labelSize);
            parent.textAlign(PApplet.CENTER, PApplet.CENTER);
            parent.text(label, width / 2, height / 2);
        }

        parent.popMatrix();

        parent.imageMode(PApplet.CORNER);
    }

    @Override
    public boolean mousePressed(int mouseX, int mouseY) {
        if (mouseX > x && mouseX < x + width
                && mouseY > y && mouseY < y + height) {
            isPressed = true;
            pressStart = System.currentTimeMillis();
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
                if (method != null) {
                    long now = System.currentTimeMillis();
                    try {
                        if (now - pressStart > LONG_CLICK_TIME) {
                            method.invoke(listener, new Object[] { true });
                        } else {
                            method.invoke(listener, new Object[] { false });
                        }
                    } catch(Exception e) { e.printStackTrace(); }
                }
                return true;
            }
        }
        return false;
    }

    public int getWidth() {
        return width;
    }

    public void setPressed(boolean pressed) {
        isPressed = pressed;
    }

    protected abstract PImage createImageIdle(PApplet parent);

    protected abstract PImage createImagePressed(PApplet parent);

    public void setLabel(String label) {
        this.label = label;
    }
}
