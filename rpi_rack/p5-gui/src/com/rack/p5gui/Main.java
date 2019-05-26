package com.rack.p5gui;

import processing.core.PApplet;

/**
 * Created by jnonis on 5/7/19.
 */
public class Main extends PApplet {
    private P5GUI gui;
    private PagerView pagerView;
    private LedView ledView;

    private long lastLedUpdate;
    private int lastColor;

    public static void main(String[] args){
        PApplet.main(Main.class);
    }

    public void settings(){
        size(320,480);
    }

    public void setup() {
        gui = new P5GUI(this);

        pagerView = new PagerView();
        gui.addView(pagerView);

        ViewGroup group = new ViewGroup();
        group.addView(new KnobView(260, 20, 40, "Knob 1", this, null));
        group.addView(new KnobView(260, 120, 40, "Knob 2", null, null));
        group.addView(new KnobView(260, 220, 40, "Knob 3", null, null));
        group.addView(new KnobView(260, 320, 40, "Knob 4", null, null));
        group.addView(new ButtonView(30, 320, 40, "But", null, null));
        //group.addView(new JackInputView(20, 320, 40, "MODEL", null, null));

        group.addView(new JackInputView(160, 300, 30, "Test", null, null));

        ledView = new LedView(100, 100, 10);
        group.addView(ledView);
        pagerView.addView(group);

        gui.setup();

        lastLedUpdate = System.currentTimeMillis();
    }

    public void draw() {
        long now = System.currentTimeMillis();
        if (now - lastLedUpdate > 1000) {
            int color = color(255, 0, 0);
            if (lastColor == color) {
                color = color(255, 0, 0, 0);
            }
            ledView.setColor(color);
            lastColor = color;
            lastLedUpdate = now;
        }
    }
}
