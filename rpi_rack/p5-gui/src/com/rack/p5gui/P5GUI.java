package com.rack.p5gui;

import processing.core.PApplet;
import processing.core.PGraphics;
import processing.event.MouseEvent;

/**
 * GUI processing library.
 */
public class P5GUI {
    public final static String VERSION = "##library.prettyVersion##";

    /** Processing application. */
    private PApplet parent;

    /** Render buffer. */
    private PGraphics buffer;

    private boolean useBuffer = false;

    /** Main view. */
    private ViewGroup mainView;

    /**
     * Return the version of the Library.
     * @return String the version.
     */
    public static String version() {
        return VERSION;
    }

    /**
     * Constructor.
     * @param parent the Processing application.
     */
    public P5GUI(PApplet parent) {
        this(parent, false);
    }

    /**
     * Constructor.
     * @param parent the Processing application.
     * @param useBuffer indicates if it has to use a render buffer.
     */
    public P5GUI(PApplet parent, boolean useBuffer) {
        this.parent = parent;
        this.useBuffer = useBuffer;
        mainView = new ViewGroup();
        parent.registerMethod("setup", this);
        parent.registerMethod("draw", this);
        parent.registerMethod("mouseEvent", this);
        welcome();
    }

    private void welcome() {
        System.out.println("##library.name## ##library.prettyVersion## by ##author##");
    }

    /**
     * Add a view to sketch.
     * @param view the view.
     */
    public void addView(View view) {
        mainView.addView(view);
    }

    public void setup() {
        if (useBuffer) {
            buffer = parent.createGraphics(parent.width, parent.height);
        } else {
            buffer = parent.getGraphics();
        }
        mainView.setup(parent);
    }

    public void draw() {
        mainView.draw(parent);
    }

    public void mouseEvent(MouseEvent event) {
        int x = event.getX();
        int y = event.getY();

        switch (event.getAction()) {
            case MouseEvent.PRESS:
                mainView.mousePressed(x, y);
                break;
            case MouseEvent.RELEASE:
                mainView.mouseReleased(x, y);
                break;
            case MouseEvent.CLICK:
                mainView.mouseClicked(x, y);
                break;
            case MouseEvent.DRAG:
                mainView.mouseDragged(x, y);
                break;
            case MouseEvent.MOVE:
                break;
        }
    }
}
