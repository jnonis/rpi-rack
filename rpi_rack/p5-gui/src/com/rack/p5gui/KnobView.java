package com.rack.p5gui;

import processing.core.PApplet;

import java.lang.reflect.Method;

public class KnobView extends View {
    public static final int MAX_VALUE = 127;
    private int size;
    private String title;
    private Object listener;
    private String callback;
    private Method method;
    private float value = 64;
    private boolean isDragging = false;
    private int startY;
    private float startValue;

    public KnobView(int x, int y, int size, String title, Object listener, String callback) {
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
                method = listener.getClass().getMethod(callback, float.class, boolean.class);
            } catch(Exception e) { e.printStackTrace(); }
        }
    }

    public void draw(PApplet parent) {
        parent.pushMatrix();
        parent.translate(x, y);

        parent.ellipseMode(PApplet.CORNER);
        parent.fill(255);
        parent.ellipse(0, 0, size, size);

        parent.fill(0);
        parent.textSize(12);
        parent.textAlign(PApplet.CENTER, PApplet.TOP);
        parent.text(title, size / 2, size + 8);

        int aux = (int) PApplet.map(value, 0, MAX_VALUE, 0, 290);
        float angle = PApplet.radians(aux - 145);
        parent.translate(size / 2, size / 2);
        parent.rotate(angle);
        parent.line(0, 0, 0, -size / 2);

        parent.popMatrix();
    }

    public boolean mousePressed(int mouseX, int mouseY) {
        if (mouseX > x && mouseX < x + size
                && mouseY > y && mouseY < y + size) {
            startY = mouseY;
            startValue = value;
            isDragging = true;
            return true;
        }
        return false;
    }

    public boolean mouseDragged(int mouseX, int mouseY) {
        if (isDragging) {
            int delta = startY - mouseY;
            float newValue = startValue + delta / 2;
            if (newValue < 0) {
                newValue = 0;
            } else if (newValue > MAX_VALUE) {
                newValue = MAX_VALUE;
            }
            if (newValue != value) {
                value = newValue;
                if (method != null) {
                    try {
                        method.invoke(listener, value, false);
                    } catch(Exception e) { }
                }
            }
            return true;
        }
        return false;
    }

    public boolean mouseReleased(int mouseX, int mouseY) {
        if (isDragging) {
            isDragging = false;
            return true;
        }
        return false;
    }

    public boolean mouseClicked(int mouseX, int mouseY) {
        if (mouseX > x && mouseX < x + size
                && mouseY > y && mouseY < y + size) {
            System.out.println("Click");
            if (method != null) {
                try {
                    method.invoke(listener, value, true);
                } catch(Exception e) { }
            }
            return true;
        }
        return false;
    }

    public void setValue(float value) {
        this.value = value;
    }

    public float getValue() {
        return value;
    }
}
