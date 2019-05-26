package com.rack.p5gui;

import processing.core.PApplet;

import java.util.ArrayList;
import java.util.List;

public class PagerView extends View {
    protected List<View> pages = new ArrayList<>();
    protected int current = 0;
    protected boolean isPageChanged = false;

    public void addView(View view) {
        pages.add(view);
    }

    public void next() {
        if (pages.isEmpty()) {
            return;
        }
        View view = pages.get(current);
        if (view instanceof Pageable) {
            if (((Pageable) view).onNext()) {
                isPageChanged = true;
                return;
            }
        }
        current++;
        if (current >= pages.size()) {
            current = pages.size() - 1;
        }
        isPageChanged = true;
    }

    public void previous() {
        if (pages.isEmpty()) {
            return;
        }
        View view = pages.get(current);
        if (view instanceof Pageable) {
            if (((Pageable) view).onPrevious()) {
                isPageChanged = true;
                return;
            }
        }
        current--;
        if (current < 0) {
            current = 0;
        }
        isPageChanged = true;
    }

    public void setup(PApplet parent) {
        for (View page : pages) {
            page.setup(parent);
        }
    }

    public void draw(PApplet parent) {
        if (isPageChanged) {
            isPageChanged = false;
            parent.background(206);
        }
        if (!pages.isEmpty()) {
            pages.get(current).draw(parent);
        }
    }

    public boolean mousePressed(int mouseX, int mouseY) {
        if (pages.isEmpty()) {
            return false;
        }
        return pages.get(current).mousePressed(mouseX, mouseY);
    }

    public boolean mouseDragged(int mouseX, int mouseY) {
        if (pages.isEmpty()) {
            return false;
        }
        return pages.get(current).mouseDragged(mouseX, mouseY);
    }

    public boolean mouseReleased(int mouseX, int mouseY) {
        if (pages.isEmpty()) {
            return false;
        }
        return pages.get(current).mouseReleased(mouseX, mouseY);
    }

    public boolean mouseClicked(int mouseX, int mouseY) {
        if (pages.isEmpty()) {
            return false;
        }
        return pages.get(current).mouseClicked(mouseX, mouseY);
    }
}
