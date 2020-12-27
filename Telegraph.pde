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
  // Défini une taille minimum à la fenetre du jeu
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
  // Défini l'écran courant comme instance de LaunchScreen
  screen.setLaunchScreen();
}

public void draw(){
  // Vérifie si la taille de la fenetre a changé et apelle la méthode si besoin
  if(width != lastWidth || height != lastheight){
    lastWidth = width;
    lastheight = height;
    sizeChanged();
  }
  // Affiche l'écran courant
  screen.drawScreen();
}

// Prévient l'écran courant que la taille de la fenetre a changé
public void sizeChanged(){
  screen.sizeChanged();
}

// Prévient l'écran courant qu'une touche du clavier viens d'etre pressée
public void keyPressed(){
  screen.aKeyWasPressed();
}

// Prévient l'écran courant que la souris a été cliquée
public void mouseClicked(){
  screen.mouseIsClicked();
}

// Prévient l'écran courant que la souris bouge
public void mouseMoved(){
  screen.mouseIsMoved();
}

// Prévient l'écran courant que la souris "dragg"
public void mouseDragged() {
  screen.mouseIsDragged();
}

// Prévient l'écran courant qu'un bouton de la souris est appuyé
public void mousePressed() {
  screen.mouseIsPressed();
}

// Prévient l'écran courant qu'un bouton de la souris viens d'ètre relaché
public void mouseReleased(){
  screen.mouseIsReleased();
}
