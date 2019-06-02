package com.rack.p5gui;

import processing.core.PApplet;
import processing.core.PImage;

import java.lang.reflect.Method;

public abstract class ImageKnobView extends View {
    public static final int MAX_VALUE = 127;
    private PImage[] images;
    private float value = MAX_VALUE / 2;
    private int width;
    private int height;
    private boolean isDragging = false;
    private int startY;
    private float startValue;
    private String label;
    protected int labelColor = 0;
    protected int labelSize = 12;
    protected Object listener;
    protected String callback;
    protected Method method;

    public ImageKnobView(int x, int y, Object listener, String callback) {
        this(x, y, null, listener, callback);
    }

    public ImageKnobView(int x, int y, String label, Object listener, String callback) {
        this.x = x;
        this.y = y;
        this.label = label;
        this.listener = listener;
        this.callback = callback;
    }

    public void setup(PApplet pApplet) {
        if (listener != null && callback != null) {
            try {
                method = listener.getClass().getMethod(callback, float.class, boolean.class);
            } catch(Exception e) { e.printStackTrace(); }
        }

        images = loadImages(pApplet);
        width = images[0].width;
        height = images[0].height;
    }

    public void draw(PApplet parent) {
        int aux = (int) PApplet.map(value, 0, MAX_VALUE, 0, 290);
        float angle = PApplet.radians(aux - 145);

        parent.pushMatrix();
        parent.imageMode(PApplet.CENTER);
        parent.translate(x + width / 2, y + height / 2);
        parent.rotate(angle);
        parent.image(images[getCurrentImageIndex()], 0, 0);

        if (label != null) {
            parent.rotate(-angle);
            parent.fill(labelColor);
            parent.textSize(labelSize);
            parent.textAlign(PApplet.CENTER, PApplet.CENTER);
            parent.text(label, 0, 0);
        }
        parent.popMatrix();

        parent.imageMode(PApplet.CORNER);
    }

    @Override
    public boolean mousePressed(int mouseX, int mouseY) {
        if (mouseX > x && mouseX < x + width
                && mouseY > y && mouseY < y + height) {
            startY = mouseY;
            startValue = value;
            isDragging = true;
            return true;
        }
        return false;
    }

    @Override
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

    @Override
    public boolean mouseReleased(int mouseX, int mouseY) {
        if (isDragging) {
            isDragging = false;
            return true;
        }
        return false;
    }

    public boolean mouseClicked(int mouseX, int mouseY) {
        if (mouseX > x && mouseX < x + width
                && mouseY > y && mouseY < y + height) {
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
        if (value > MAX_VALUE) {
            value = MAX_VALUE;
        } else if (value < 0) {
            value = 0;
        }
        this.value = value;
    }

    public float getValue() {
        return value;
    }

    protected PImage[] loadImages(PApplet pApplet) {
        return new PImage[] { loadImage(pApplet) };
    }

    protected int getCurrentImageIndex() {
        return 0;
    }

    protected abstract PImage loadImage(PApplet pApplet);

    public void setLabel(String label) {
        this.label = label;
    }
}
