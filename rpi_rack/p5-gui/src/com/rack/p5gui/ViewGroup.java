package com.rack.p5gui;

import processing.core.PApplet;
import processing.event.MouseEvent;

import java.util.ArrayList;
import java.util.List;

public class ViewGroup extends View {
    /** Added views. */
    private List<View> views = new ArrayList<>();

    /**
     * Add a view to sketch.
     * @param view the view.
     */
    public void addView(View view) {
        views.add(view);
    }

    public void setup(PApplet parent) {
        for (View view : views) {
            view.setup(parent);
        }
    }

    public void draw(PApplet parent) {
        for (View view : views) {
            if (view.visible) {
                view.draw(parent);
            }
        }
    }

    public void mouseEvent(MouseEvent event) {
        int mouseX = event.getX();
        int mouseY = event.getY();

        switch (event.getAction()) {
            case MouseEvent.PRESS:
                mousePressed(mouseX, mouseY);
                break;
            case MouseEvent.RELEASE:
                mouseReleased(mouseX, mouseY);
                break;
            case MouseEvent.CLICK:
                break;
            case MouseEvent.DRAG:
                mouseDragged(mouseX, mouseY);
                break;
            case MouseEvent.MOVE:
                break;
        }
    }

    public boolean mousePressed(int mouseX, int mouseY) {
        for (int i = views.size(); i > 0; i--) {
            View view = views.get(i - 1);
            if (view.visible && view.mousePressed(mouseX, mouseY)) {
                break;
            }
        }
        return false;
    }

    public boolean mouseDragged(int mouseX, int mouseY) {
        for (int i = views.size(); i > 0; i--) {
            View view = views.get(i - 1);
            if (view.visible && view.mouseDragged(mouseX, mouseY)) {
                break;
            }
        }
        return false;
    }

    public boolean mouseReleased(int mouseX, int mouseY) {
        for (int i = views.size(); i > 0; i--) {
            View view = views.get(i - 1);
            if (view.visible && view.mouseReleased(mouseX, mouseY)) {
                break;
            }
        }
        return false;
    }

    public boolean mouseClicked(int mouseX, int mouseY) {
        for (int i = views.size(); i > 0; i--) {
            View view = views.get(i - 1);
            if (view.visible && view.mouseClicked(mouseX, mouseY)) {
                break;
            }
        }
        return false;
    }
}