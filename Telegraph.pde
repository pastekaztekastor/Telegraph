import processing.awt.PSurfaceAWT.SmoothCanvas;
import javax.swing.JFrame;
import java.awt.Dimension;
import java.util.Arrays;

DataDeleguate data;
TextureDeleguate textures;
ScreenDeleguate screen;

int lastheight;
int lastWidth;

public void setup() {
  SmoothCanvas sc = (SmoothCanvas) getSurface().getNative();
  JFrame frame = (JFrame) sc.getFrame();
  Dimension dim = new Dimension(640, 900);
  frame.setMinimumSize(dim);

  background(0);
  size(640,860);
  noSmooth();
  noStroke();
  lastheight = height;
  lastWidth = width;
  surface.setResizable(true);
  data = new DataDeleguate();
  textures = new TextureDeleguate();
  screen = new ScreenDeleguate(data, textures);
  screen.setLaunchScreen();
}

public void draw(){
  if(width != lastWidth || height != lastheight){
    lastWidth = width;
    lastheight = height;
    sizeChanged();
  }
  screen.drawScreen();
}

public void sizeChanged(){
  screen.sizeChanged();
}

public void keyPressed(){
  screen.aKeyWasPressed();
}

public void mouseClicked(){
  screen.mouseIsClicked();
}

public void mouseMoved(){
  screen.mouseIsMoved();
}

public void mouseDragged() {
  screen.mouseIsDragged();
}

public void mousePressed() {
  screen.mouseIsPressed();
}

public void mouseReleased(){
  screen.mouseIsReleased();
}
