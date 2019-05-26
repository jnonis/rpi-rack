package com.rack.p5gui;

import processing.core.PApplet;

import java.lang.reflect.Method;

public class ButtonView extends View {
    private static final long LONG_CLICK_TIME = 1500;
    protected int size;
    protected String title;
    protected Object listener;
    protected String callback;
    protected Method method;
    protected boolean isPressed = false;
    protected long pressStart;

    public ButtonView(int x, int y, int size, String title, Object listener, String callback) {
        this.x = x;
        this.y = y;
        this.size = size;
        this.title = title;
        this.listener = listener;
        this.callback = callback;
    }

    public void setup(PApplet parent) {
        if (listener != null && callback != null) {
            try {
                method = listener.getClass().getMethod(callback, boolean.class);
            } catch(Exception e) { e.printStackTrace(); }
        }
    }

    public void draw(PApplet parent) {
        parent.pushMatrix();
        parent.translate(x, y);

        if (isPressed) {
            parent.fill(127);
        } else {
            parent.fill(255);
        }
        parent.rect(0, 0, size, size, 7);

        parent.fill(0);
        parent.textSize(12);
        parent.textAlign(PApplet.CENTER, PApplet.CENTER);
        parent.text(title, size / 2, size / 2);

        parent.popMatrix();
    }

    public boolean mousePressed(int mouseX, int mouseY) {
        if (mouseX > x && mouseX < x + size
                && mouseY > y && mouseY < y + size) {
            isPressed = true;
            pressStart = System.currentTimeMillis();
            return true;
        }
        return false;
    }

    public boolean mouseDragged(int mouseX, int mouseY) {
        if (isPressed) {
            return true;
        }
        return false;
    }

    public boolean mouseReleased(int mouseX, int mouseY) {
        if (isPressed) {
            isPressed = false;
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
        return false;
    }
}
