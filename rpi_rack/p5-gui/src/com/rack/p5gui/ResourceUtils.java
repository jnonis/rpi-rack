package com.rack.p5gui;

import java.awt.Image;
import java.io.IOException;
import java.io.InputStream;

import javax.swing.ImageIcon;

import processing.core.PApplet;
import processing.core.PFont;
import processing.core.PImage;

/**
 * Utils handle GUI resources.
 * @author Javier Nonis
 */
public class ResourceUtils {

    /**
     * Loads an image from classpath in Processing format.
     * @param filePath the image file path.
     * @return an image.
     */
    public static PImage loadPImageARGBFromClasspath(String filePath) {
        Image image = loadImageFromClasspath(filePath);
        PImage pImage = new PImage(image);
        pImage.format = PApplet.ARGB;
        return pImage;
    }

    /**
     * Loads an image from classpath.
     * @param filePath the image file path.
     * @return an image.
     */
    public static Image loadImageFromClasspath(String filePath) {
        InputStream inputStream = ClassLoader.getSystemResourceAsStream(filePath);
        byte[] bytes = PApplet.loadBytes(inputStream);
        return new ImageIcon(bytes).getImage();
    }

    /**
     * Loads a font from classpath in Processing format.
     * @param filePath the font file path.
     * @return an font.
     */
    public static PFont loadFontFromClasspath(String filePath) {
        try {
            InputStream input = ClassLoader.getSystemResourceAsStream(filePath);
            return new PFont(input);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}

