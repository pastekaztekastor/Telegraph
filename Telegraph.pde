import processing.awt.PSurfaceAWT.SmoothCanvas;
import javax.swing.JFrame;
import java.awt.Dimension;
import java.util.Arrays;

DataDeleguate data;
TextureDeleguate textures;
ScreenDeleguate screen;

int lastheight;
int lastWidth;

void setup() {
  SmoothCanvas sc = (SmoothCanvas) getSurface().getNative();
  JFrame frame = (JFrame) sc.getFrame();
  Dimension dim = new Dimension(400, 300);
  frame.setMinimumSize(dim);
  
  background(0);
  frameRate(1000);
  size(640,860);
  noSmooth();
  noStroke();
  lastheight = height;
  lastWidth = width;
  surface.setResizable(true);
  data = new DataDeleguate();
  textures = new TextureDeleguate();
  screen = new ScreenDeleguate(data, textures);
  screen.setScoreScreen();
}

void draw(){
  if(width != lastWidth || height != lastheight){
    lastWidth = width;
    lastheight = height;
    sizeChanged();
  }
  screen.drawScreen();
}

void sizeChanged(){
  screen.sizeChanged();
}

void keyPressed(){
  screen.aKeyWasPressed();
}

void mouseClicked(){
  screen.mouseIsClicked();
}

void mouseMoved(){
  screen.mouseIsMoved();
}

void mouseDragged() {
  screen.mouseIsDragged();
}

void mousePressed() {
  screen.mouseIsPressed();
}

void mouseReleased(){
  screen.mouseIsReleased();
}
