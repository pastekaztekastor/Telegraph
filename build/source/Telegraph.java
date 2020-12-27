import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.awt.PSurfaceAWT.SmoothCanvas; 
import javax.swing.JFrame; 
import java.awt.Dimension; 
import java.util.Arrays; 
import javax.swing.event.EventListenerList; 
import java.util.ArrayList; 
import java.util.ArrayList; 
import java.util.ArrayList; 
import java.util.ArrayList; 
import java.util.HashMap; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Telegraph extends PApplet {






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


abstract interface ClickListener extends EventListener{
  public void onClick(Button src);
}

abstract class Button{
  // La position est au centre de l'objet
  protected PVector   mPosition;
  protected float     mWidth;
  protected float     mHeight;
  protected boolean   mIsHovered;
  protected boolean   mIsVisible;

  protected final     EventListenerList mListeners;

  protected Button(float x, float y, float width, float height){
    mListeners   = new EventListenerList();
    mPosition   = new PVector(x, y);
    mWidth      = width;
    mHeight     = height;
    mIsHovered  = false;
    mIsVisible  = true;
  }

  protected abstract void draw();

  public void drawButton(){
    if(mIsVisible){
      draw();
    }
  }

  public void setVisibility(boolean value){
    mIsVisible = value;
  }

  public void addListener(ClickListener listener){
    mListeners.add(ClickListener.class, listener);
  }

  // Supprime le listener mis en paramètre
  public void removeListener(ClickListener listener){
    mListeners.remove(ClickListener.class, listener);
  }

  // il y a eu un click, vérifier si la souris est sur le bouton, et prévenir les listeners
  public void isClick(){
    if(isMouseOnIt()){
      fireButtonClicked(this);
    }
  }

  // Renvoie tout les listeners de type ClickListener
  protected ClickListener[] getClickListeners() {
    return mListeners.getListeners(ClickListener.class);
  }

  // J'alerte tout mes listeners que le bouton a été cliqué
  protected void fireButtonClicked(Button src){
    for(ClickListener listener : getClickListeners()){
      listener.onClick(src);
    }
  }

  public void setPosition(float x, float y){
    mPosition.x = x;
    mPosition.y = y;
  }

  public boolean isMouseOnIt(){
    if(mIsVisible && isMouseBetweenPos(mPosition.x - mWidth/2, mPosition.x + mWidth/2, mPosition.y - mHeight/2, mPosition.y + mHeight/2)){
      cursor(HAND);
      mIsHovered = true;
      return true;
    } else {
      mIsHovered = false;
      return false;
    }
  }

  // Renvoi true si la position de la souris est entre les valeurs
  private boolean isMouseBetweenPos(float startX, float endX, float startY, float endY){
    return mouseX > startX
      && mouseX < endX
      && mouseY > startY
      && mouseY < endY;
  }
}


public class ImageButton extends Button{
  public static final int NONE   = 0;
  public static final int UP     = 1;
  public static final int DOWN   = 2;
  public static final int LEFT   = 3;
  public static final int RIGHT  = 4;

  private PImage mImage;
  private int    mMode;

  public ImageButton(float x, float y, PImage image){
    super(x, y, image.width + 20, image.height + 20);
    mImage = image;
    mMode  = NONE;
  }

  public void setMode(int mode){
    mMode = mode;
  }

  protected void draw(){
    imageMode(CENTER);
    if(mMode == NONE) image(mImage, mPosition.x, mPosition.y);
    else if(mMode == UP) image(mImage, mPosition.x, mPosition.y - second()%2*10);
    else if(mMode == DOWN) image(mImage, mPosition.x, mPosition.y + second()%2*10);
    else if(mMode == LEFT) image(mImage, mPosition.x - second()%2*10, mPosition.y);
    else if(mMode == RIGHT) image(mImage, mPosition.x + second()%2*10, mPosition.y);
  }
}


public class TextButton extends Button{
  private String mText;
  private int    mFontSize;
  private PImage mLeftSelector;
  private PImage mRightSelector;

  // Le bouton est nu, sans décoration lors du survol
  public TextButton(float x, float y, String text, int fontSize){
    this(x, y, text, fontSize, null, null);
  }

  // Si le bouton est survolé, une flèche apparaitra à gauche
  public TextButton(float x, float y, String text, int fontSize, PImage leftSelector){
    this(x, y, text, fontSize, leftSelector, null);
  }

  // Si le bouton est survolé, une flèche apparaitra à gauche et a droite
  public TextButton(float x, float y, String text, int fontSize, PImage leftSelector, PImage rightSelector){
    super(x, y, 0, fontSize);
    textSize(fontSize);
    mWidth      = textWidth(text);
    mText       = text;
    mFontSize   = fontSize;
    mLeftSelector  = leftSelector;
    mRightSelector = rightSelector;
  }

  public void setText(String text){
    textSize(mFontSize);
    mWidth      = textWidth(text);
    mText = text;
  }

  protected void draw(){
    textSize(mFontSize);
    textAlign(CENTER, CENTER);
    text(mText, mPosition.x, mPosition.y);
    if(mIsHovered){
      if(mLeftSelector != null){
        imageMode(CENTER);
        image(mLeftSelector, mPosition.x - mWidth/2 - mLeftSelector.width - second()%2*10, mPosition.y + 5);
      }
      if(mRightSelector != null){
        imageMode(CENTER);
        image(mRightSelector, mPosition.x + mWidth/2 + mRightSelector.width + second()%2*10, mPosition.y + 5);
      }
    }
  }
}

public class CreateEditorScreen extends Screen implements ClickListener{
  private final ScreenDeleguate   mScreenDeleguate;
  private final DataDeleguate     mData;
  private final TextureDeleguate  mTextures;
  
  private TextField   mWidthTextField;
  private TextField   mHeightTextField;
  private TextField   mNameTextField;
  private TextButton  mBackButton;
  private TextButton  mCreateButton;
  private String      mErrorMessage;

  CreateEditorScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate  = screenDeleguate;
    mData             = dataDeleguate;
    mTextures         = textures;
    mErrorMessage     = "";
    mBackButton       = new TextButton(width/2 - 150, height - 50, "Retour", 36, mTextures.mLeftSelector);
    mCreateButton     = new TextButton(width/2 + 150, height - 50, "Créer", 36, mTextures.mLeftSelector);
    mWidthTextField   = new TextField(width/2 - 100, height/2 - 105, 200, 50, 2);
    mHeightTextField  = new TextField(width/2 - 100, height/2 + 25, 200, 50, 2);
    mNameTextField    = new TextField(width/2 - 170, height/2 + 155, 340, 50, 8);
    
    // J'enregistre l'objet courant comme écouteur
    mBackButton.addListener(this);
    mCreateButton.addListener(this);
    
    // Je paramètre les champs de texte
    mWidthTextField.setFilter(TextField.ONLY_NUMBERS);
    mHeightTextField.setFilter(TextField.ONLY_NUMBERS);
    mNameTextField.setFilter(TextField.NUMBERS_AND_CHARACTERS);
    mWidthTextField.setActive(true);
    
    // J'actualise le curseur
    mouseMoved();
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawBody();
    drawErrorMessage();
  }
  
  private void drawBody(){
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    text("Largeur du niveau", width/2, height/2 - 130);
    mWidthTextField.drawTextField();
    text("hauteur du niveau", width/2, height/2);
    mHeightTextField.drawTextField();
    text("Nom du niveau", width/2, height/2 + 130);
    mNameTextField.drawTextField();
    mBackButton.drawButton();
    mCreateButton.drawButton();
  }
  
  private void drawErrorMessage(){
    fill(mTextures.mErrorColor);
    textAlign(CENTER, CENTER);
    textFont(mTextures.mFont, 18);
    text(mErrorMessage, width/2, height - 100); 
  }
  
  public void onClick(Button src){
    if(src == mBackButton){
      // Le bouton Retour est cliqué, on affiche le menu
      mScreenDeleguate.setMenuScreen();
    } else if(src == mCreateButton){
      // Le bouton créer est cliqué, on créé le niveau et on lance la page de création
      // Il faut vérifier que le nom choisis n'existe pas déja
      if(mWidthTextField.getText().length() == 0 || mHeightTextField.getText().length() == 0 || mNameTextField.getText().length() == 0){
        mErrorMessage = "Tu dois remplir tout les champs";
        return;
      }
      int levelWidth  = Integer.parseInt(mWidthTextField.getText());
      int levelHeight = Integer.parseInt(mHeightTextField.getText());
      if(levelWidth < 2 || levelWidth > 25 || levelHeight < 2 || levelHeight > 25){
        mErrorMessage = "La taille du niveau doit etre entre 2 et 25";
        return;
      }
      for(Level level : mData.mLevels){
        if(level.getname().toLowerCase().equals(mNameTextField.getText().toLowerCase())){
          // Le nom choisis existe déja, afficher un message d'erreur;
          mErrorMessage = "Le nom choisis existe déja";
          return;
        }
      }
      Level level = new Level(levelWidth, levelHeight, mNameTextField.getText());
      mScreenDeleguate.setSetupEditorScreen(level);
    }
    // La page est changée, j'enlève les listeners
    mBackButton.removeListener(this);
    mCreateButton.removeListener(this);
  }
  
  public void mouseClicked(){
    mWidthTextField.isClick();
    mHeightTextField.isClick();
    mNameTextField.isClick();
    mCreateButton.isClick();
    mBackButton.isClick();
  }
  
  public void keyPressed(){
    // Une touche est préssée, je préviens les champs de texte
    mWidthTextField.aKeyWasPressed(key); 
    mHeightTextField.aKeyWasPressed(key); 
    mNameTextField.aKeyWasPressed(key);
  }
  
  public void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    // Si la souris n'est sur aucun, je met le curseur par défaut
    if(!mWidthTextField.isMouseOnIt() 
        && !mHeightTextField.isMouseOnIt()
        && !mNameTextField.isMouseOnIt()
        && !mBackButton.isMouseOnIt() 
        && !mCreateButton.isMouseOnIt()){
      cursor(ARROW);
    }
  }
  
  public void sizeChanged(){
    // La taille de la fenetre change, je recalcule les positions des boutons et champs de texte
    mWidthTextField.setPosition(width/2 - 100, height/2 - 105);
    mHeightTextField.setPosition(width/2 - 100, height/2 + 25);
    mNameTextField.setPosition(width/2 - 170, height/2 + 155);
    mBackButton.setPosition(width/2 - 150, height - 50);
    mCreateButton.setPosition(width/2 + 150, height - 50);
  }
}


class DataDeleguate{
  public Player mCurrentPlayer;
  public ArrayList<Level> mLevels;
  public ArrayList<Player> mPlayers;

  DataDeleguate(){
    loadLevels();
    loadPlayers();
  }

  public void loadLevels(){
    mLevels = new ArrayList<Level>();
    File[] files = listFiles("/levels");
    for(int i = 0; i < files.length; i++){
      Level level = new Level(files[i]);
      mLevels.add(level);
    }
  }

  public void loadPlayers(){
    mPlayers = new ArrayList<Player>();
    File[] files = listFiles("/players");
    for(int i = 0; i < files.length; i++){
      Player player = new Player(split(files[i].getName(), '.')[0]);
      mPlayers.add(player);
    }
  }
  
  public ArrayList<Level> getLevels(){
    return mLevels; 
  }

  public ArrayList<Player> getPlayersOfLevel(int levelId){
    ArrayList<Player> list = new ArrayList<Player>();
    for(Player player : mPlayers){
      if(player.getTimeAtLevel(mLevels.get(levelId).getname()).toInteger() >= 0){
        println(player.getTimeAtLevel(mLevels.get(levelId).getname()).toInteger());
        // Le joueur a déja joué sur le niveau recherché, l'ajouter au tableau
        list.add(player);
      }
    }
    return list;
  }

  public void setCurrentPlayerTo(String name){
    for(Player player : mPlayers){
      if(player.mPlayerName.equals(name)){
        // Le joueur existe déja, on le récupère
        mCurrentPlayer = player;
        return;
      }
    }
    // Le joueur n'existe pas, alors il faut le créer
    mCurrentPlayer = new Player(name);
    mPlayers.add(mCurrentPlayer);
  }
  
  public Player getCurrentplayer(){
    if(this.mCurrentPlayer == null){
      throw new Error("Aucun joueur courant");
    }
    return this.mCurrentPlayer;
  }
}

public class HelpScreen extends Screen implements ClickListener{
  private ScreenDeleguate     mScreenDeleguate;
  private DataDeleguate       mData;
  private TextureDeleguate    mTextures;
  
  private TextButton          mBackButton;

  private String[]            mAdaptedText;
  private String[]            mMainText = { "Chaque niveau comporte une grille remplie de stations télégraphiques.",
                                            "Suite à la dernière éruption du Piton de la Fournaise-Niels, certaines sont déconnectées.",
                                            "Pour les reconnecter, tu disposes d'un fil.",
                                            "Clique sur une station pour le commencer et déplace ta souris en maintenant le clic pour le continuer.",
                                            "Le passage d'un fil change l'état de la station.",
                                            "Mais attention, si un fil passe sur une station déjà connectée, cela brouille son signal et la station se déconnecte." };

  HelpScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures) {
    mScreenDeleguate   = screenDeleguate;
    mData              = dataDeleguate;
    mTextures          = textures;
    mAdaptedText       = new String[0];
    mBackButton        = new TextButton(width/2, height - 50, "retour", 36, mTextures.mLeftSelector);
    mBackButton.addListener(this);
    sizeChanged();
  }

  public void drawScreen() {
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawBody();
    mBackButton.drawButton();
    mouseMoved();
  }

  private void drawBody() {
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Aide générale", width/2, 200);

    textFont(mTextures.mFont, 18);
    textAlign(LEFT, CENTER);
    text("Station connectée", width/2 + 10, 240 + 48/2);
    text("Station déconnectée", width/2 + 10, 240 + 48 / 2 + 48/8 + 48);
    mTextures.drawEmptyTile(width/2 - 55, 240, 48);
    mTextures.drawTelegraphTile(width/2 - 55, 240 + 48 + 48/8, 48);

    textAlign(CENTER, CENTER);
    for(int i = 0; i < mAdaptedText.length; i++){
      text(mAdaptedText[i], width/2, 370 + i * 30);
    }
  }

  private final String[] adaptToWidth(String[] linesToAdapt, int textSize, int maxWidth){
    textSize(textSize);
    String[] newTable = new String[0];
    for(int i = 0; i < linesToAdapt.length; i++){
      String[] words = split(linesToAdapt[i], ' ');
      for(int j = 0; j < words.length; j++){
        String str = words[j];;
        for(int k = j+1; k < words.length; k++){
          if(textWidth(str + ' ' + words[k]) > maxWidth){
            break;
          } else {
            str += ' ' + words[k];
          }
          j = k;
        }
        newTable = append(newTable, str);
      }
    }
    return newTable;
  }
  
  public void onClick(Button src){
    if(src == mBackButton) mScreenDeleguate.setMenuScreen();
    mBackButton.removeListener(this);
  }

  public void mouseClicked(){
    mBackButton.isClick();
  }
  
  public void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    // Si la souris n'est sur aucun, je met le curseur par défaut
    if(!mBackButton.isMouseOnIt()){
      cursor(ARROW);
    }
  }

  public void sizeChanged(){
    mAdaptedText = adaptToWidth(mMainText, 18, width - 50);
    mBackButton.setPosition(width/2, height - 50);
  }
}

public class LaunchScreen extends Screen implements ClickListener{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private final TextField mNameTextField;
  private final TextButton mNextButton;

  LaunchScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    mNameTextField = new TextField(width/2 - 170, height/2 - 25, 340, 50, 8);
    mNextButton = new TextButton(width/2, height - 50, "Maxime Maria", 36);
    mNextButton.addListener(this);
    mNextButton.setVisibility(false);
    mNameTextField.setActive(true);
    mNameTextField.setStyle(TextField.BORDERLESS);
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawTiles();
    drawBody();
    mNameTextField.drawTextField();
    mNextButton.drawButton();
  }
  
  public void onClick(Button src){
    if(src == mNextButton){
      mData.setCurrentPlayerTo(mNameTextField.getText());
      mScreenDeleguate.setMenuScreen();
      mNextButton.removeListener(this);
    }
  }

  public void drawTiles(){
    rectMode(CORNER);
    int tileSize = 56;
    int gap = tileSize / 8;
    mTextures.drawTelegraphTile(width/2 - tileSize - gap, height/4, tileSize);
    mTextures.drawEmptyTile(width/2 + gap, height/4, tileSize);
  }

  public void drawBody(){
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Entre ton pseudo", width/2, height/2 - 64);
    if(mNameTextField.getText().length() > 0 && millis()/100%10 >= 5){
      text("[Appuie sur Max !!]", width/2, height/2 + 64);
    }
  }
  
  public void sizeChanged(){
    mNameTextField.setPosition(width/2 - 170, height/2 - 25);
  }
  
  public void mouseMoved(){
    if(!mNextButton.isMouseOnIt()){
      cursor(ARROW); 
    }
  }
  
  public void mouseClicked(){
    mNextButton.isClick(); 
  }

  public void keyPressed(){
    mNameTextField.aKeyWasPressed(key);
    if(mNameTextField.getText().length() > 0){
      mNextButton.setVisibility(true); 
    } else {
      mNextButton.setVisibility(false); 
    }
  }
}


public class Level{
  private final static String LEVEL_PATH = "/levels/";
  String mLevelName;
  int[][] mLevelMatrix;

  public Level(File filePath){
    String[] file = loadStrings(LEVEL_PATH + filePath.getName());
    String name = split(filePath.getName(), '.')[0];

    mLevelMatrix = new int[file.length][split(file[0],' ').length];

    for(int i = 0; i < file.length; i++){
      String[] line = split(file[i],' ');
      for(int j = 0; j < line.length; j++){
        mLevelMatrix[i][j] = Integer.parseInt(line[j]);
      }
    }
    mLevelName = name;
  }
  
  public Level(int width, int height, String name){
    mLevelName = name;
    mLevelMatrix = new int[height][width];
    for(int i = 0 ; i < height; i++){
      for(int j = 0; j < width; j++){
        mLevelMatrix[i][j] = 1;
      }
    }
  }
  
  public void generateLevelFile(int[][] mPathMatrix){
    mLevelMatrix = mPathMatrix;
    String[] lines = new String[mPathMatrix.length];
    for(int i = 0 ; i < mPathMatrix.length; i++){
      lines[i] = "";
      for(int j = 0; j < mPathMatrix[i].length; j++){
        lines[i] += String.valueOf(mPathMatrix[i][j]);
        if(j != mPathMatrix[i].length - 1){
          lines[i] += ' ';
        }
      }
    }
    saveStrings(LEVEL_PATH + mLevelName + ".txt", lines);
  }
  
  public int getWidth(){
    return mLevelMatrix[0].length; 
  }
  
  public int getHeight(){
    return mLevelMatrix.length; 
  }
  
  public String getname(){
    return mLevelName; 
  }
  
  public int getValueAt(int x, int y){
    return mLevelMatrix[y][x]; 
  }
}


public class LevelDrawer extends FrameDrawer{
  
  LevelDrawer(DataDeleguate dataDeleguate, TextureDeleguate textures, Level level){
    super(dataDeleguate, textures, level);
  }

  public Time getScore(){
    return mTimer.getTime();
  }
  
  public void updateLevelData() {
    updatePathTable();
    checkWin();
  }

  private void checkWin() {
    for (int i = 0; i < mCurrentlevel.getHeight(); i++) {
      for (int j = 0; j < mCurrentlevel.getWidth(); j++) {
        if (mCurrentlevel.mLevelMatrix[i][j] - mPathTable[i][j] != 0) {
          // Il reste au moins une case qui empèche de gagner, la fonction s'arrete
          return;
        }
      }
    }
    // Le joueur a gagné, on sauvegarde le temps
    mTimer.pause();
    mData.getCurrentplayer().setNewScore(mCurrentlevel, mTimer.getTime().toInteger());
    //screen.setMenuScreen();
  }
}

public class EditorDrawer extends FrameDrawer{
  
  EditorDrawer(DataDeleguate dataDeleguate, TextureDeleguate textures, Level level){
    super(dataDeleguate, textures, level);
  }
  
  public void saveLevel(){
    mCurrentlevel.generateLevelFile(mPathTable);
  }
  
  public void updateLevelData() {
    updatePathTable();
  }
}

abstract class FrameDrawer {
  protected final DataDeleguate mData;
  protected final TextureDeleguate mTextures;

  protected final Timer mTimer;

  protected final Level mCurrentlevel;
  protected Position[] mCurrentPlayerPath;
  protected int[][] mPathTable;

  private float mTileSize;
  private float mStartingX;
  private float mStartingY;
  private float mGap;

  public FrameDrawer(DataDeleguate dataDeleguate, TextureDeleguate textures, Level level) {
    mData = dataDeleguate;
    mTextures = textures;
    mCurrentlevel = level;
    mCurrentPlayerPath = new Position[0];
    mPathTable = new int[level.getHeight()][level.getWidth()];
    updatePathTable();
    setSize();
    mTimer = new Timer();
  }

  public void draw() {
    drawLevel();
    drawPath();
  }

  public void setSize() {
    float heightAvailable = height - 300;
    float widthAvailable = width;

    float tileSize1 = (int)( heightAvailable / ((float)mCurrentlevel.getHeight() + (float)mCurrentlevel.getHeight() / 4) ) ;
    tileSize1 = tileSize1 - tileSize1%8;

    float tileSize2 = (int)( widthAvailable / ((float)mCurrentlevel.getWidth() + (float)mCurrentlevel.getWidth() / 4) ) ;
    tileSize2 = tileSize2 - tileSize2%8;

    if (tileSize1 < tileSize2) {
      mTileSize = tileSize1;
    } else {
      mTileSize = tileSize2;
    }

    mGap = mTileSize / 4;
    mStartingX = width / 2 - ( mCurrentlevel.getWidth() * (mTileSize + mGap) - mGap ) / 2;
    mStartingY = height / 2 + 50 - ( mCurrentlevel.getHeight() * (mTileSize + mGap) - mGap ) / 2;
  }

  private void drawPath() {
    rectMode(CENTER);
    for (int i = 0; i < mCurrentPlayerPath.length; i++) {
      float centerX1 = mStartingX + mTileSize / 4 + mTileSize / 4 + mCurrentPlayerPath[i].getX() * (mTileSize + mTileSize / 4);
      float centerY1 = mStartingY + mTileSize / 4 + mTileSize / 4 + mCurrentPlayerPath[i].getY() * (mTileSize + mTileSize / 4);
      if (i + 1 < mCurrentPlayerPath.length) {
        float centerX2 = mStartingX + mTileSize / 4 + mTileSize / 4 + mCurrentPlayerPath[i + 1].getX() * (mTileSize + mTileSize / 4);
        float centerY2 = mStartingY + mTileSize / 4 + mTileSize / 4 + mCurrentPlayerPath[i + 1].getY() * (mTileSize + mTileSize / 4);
        fill(mTextures.mLineColor);
        if (mCurrentPlayerPath[i].getX() == mCurrentPlayerPath[i + 1].getX()) {
          rect((centerX1+centerX2)/2, (centerY1+centerY2)/2, mTileSize / 4, mTileSize / 8 * 6);
        } else {
          rect((centerX1+centerX2)/2, (centerY1+centerY2)/2, mTileSize / 8 * 6, mTileSize / 4);
        }
      }
      fill(mTextures.mLineDotColor);
      rect(centerX1, centerY1, mTileSize / 8 * 4, mTileSize / 8 * 4);
    }
    rectMode(CORNER);
  }

  private void drawLevel() {
    Position tileHovered = getPositionOfTileHovered();
    if (tileHovered != null) {
      mTextures.drawSelectorTile(mStartingX + (mTileSize + mGap) * tileHovered.getX() - mGap / 2, mStartingY + (mTileSize + mGap) * tileHovered.getY() - mGap / 2, mTileSize + mGap);
    }
    for (int i = 0; i < mCurrentlevel.getHeight(); i++) {
      for (int j = 0; j < mCurrentlevel.getWidth(); j++) {
        // soit un 0 soit un 1
        if (mCurrentlevel.mLevelMatrix[i][j] == 1) {
          if (mPathTable[i][j] == 0) {
            mTextures.drawTelegraphTile(mStartingX + (mTileSize + mGap) * j, mStartingY + (mTileSize + mGap) * i, mTileSize);
          } else {
            mTextures.drawEmptyTile(mStartingX + (mTileSize + mGap) * j, mStartingY + (mTileSize + mGap) * i, mTileSize);
          }
        } else {
          if (mPathTable[i][j] == 0) {
            mTextures.drawEmptyTile(mStartingX + (mTileSize + mGap) * j, mStartingY + (mTileSize + mGap) * i, mTileSize);
          } else {
            mTextures.drawTelegraphTile(mStartingX + (mTileSize + mGap) * j, mStartingY + (mTileSize + mGap) * i, mTileSize);
          }
        }
      }
    }
  }
  
  public abstract void updateLevelData();

  private boolean isPositionInTheLevel(Position pos) {
    return pos.getX() >= 0
      && pos.getY() >= 0
      && pos.getX() < mCurrentlevel.getWidth()
      && pos.getY() < mCurrentlevel.getHeight();
  }

  protected void updatePathTable() {
    for (int i = 0; i < mPathTable.length; i++) {
      for (int j = 0; j < mPathTable[i].length; j++) {
        mPathTable[i][j] = 0;
      }
    }
    for (Position pos : mCurrentPlayerPath) {
      if (mPathTable[pos.getY()][pos.getX()] == 0) {
        mPathTable[pos.getY()][pos.getX()] = 1;
      } else {
        mPathTable[pos.getY()][pos.getX()] = 0;
      }
    }
  }

  private void addNewPointToPath(Position pos, boolean fromSingleTap, boolean tapHolded) {
    // Il ne doit pas y avoir une seule case présente sur la grille, pour commencer la ligne il faut donc que
    // le joueur glisse sa souris en maintenant le click sur au moins deux cases.
    if (mCurrentPlayerPath.length == 0) {
      if (tapHolded) {
        mTimer.start();
        mCurrentPlayerPath = appendTablePosition(mCurrentPlayerPath, pos);
        updateLevelData();
        return;
      } else {
        return;
      }
    }
    // Si la position existe a la dernière case, alors ne rien faire
    if (mCurrentPlayerPath[mCurrentPlayerPath.length-1].equals(pos)) {
      return;
    }
    // Si la position est a une case de la dernière et ne sort pas du tableau
    if (isPositionInTheLevel(pos) && mCurrentPlayerPath[mCurrentPlayerPath.length-1].isNextTo(pos)) {
      // Le joueur peut juste vouloir revenir d'une case en arrière
      if (mCurrentPlayerPath.length > 1 && mCurrentPlayerPath[mCurrentPlayerPath.length-2].equals(pos)) {
        // Alors enlever une case
        mCurrentPlayerPath = setNewSizeToTable(mCurrentPlayerPath, mCurrentPlayerPath.length-1);
        updateLevelData();
        return;
      }
      // Vérifier si la case n'existe pas déja et alors vérifier si la case peut se faire ou non
      for (int i = 0; i < mCurrentPlayerPath.length; i++) {
        if (i == 0 && mCurrentPlayerPath[i].equals(pos) && !mCurrentPlayerPath[mCurrentPlayerPath.length - 1].canItCross(
          mCurrentPlayerPath[0]
          , mCurrentPlayerPath[1])) {
          // Le joueur a cliqué sur la case de départ, cas particulier, mais il ne peut pas la traverser
          if (fromSingleTap) {
            // le joueur a juste fait un click et n'est pas en train de maintenir la souris cliquée, alors racourcir la ligne
            mCurrentPlayerPath = setNewSizeToTable(mCurrentPlayerPath, i+1);
            updateLevelData();
          }
          return;
        } else if (i != 0 && mCurrentPlayerPath[i].equals(pos) && !mCurrentPlayerPath[mCurrentPlayerPath.length - 1].canItCross(mCurrentPlayerPath[i - 1]
          , mCurrentPlayerPath[i]
          , mCurrentPlayerPath[i + 1])) {
          // Le joueur a cliqué sur une case existante mais ne peut pas la traverser (cas des coins)
          if (fromSingleTap) {
            // le joueur a juste fait un click et n'est pas en train de maintenir la souris cliquée, alors racourcir la ligne
            mCurrentPlayerPath = setNewSizeToTable(mCurrentPlayerPath, i+1);
            updateLevelData();
          }
          return;
        }
      }
      // Ajouter la nouvelle case au tableau
      mCurrentPlayerPath = appendTablePosition(mCurrentPlayerPath, pos);
      updateLevelData();
      return;
    }
    // Si la position est sur le chemin déja existant alors racourcir le chemin
    for (int i = mCurrentPlayerPath.length - 1; i >= 0; i--) {
      if (fromSingleTap && mCurrentPlayerPath[i].equals(pos)) {
        mCurrentPlayerPath = setNewSizeToTable(mCurrentPlayerPath, i+1);
        updateLevelData();
      }
    }
  }

  private Position[] setNewSizeToTable(Position[] table, int newSize) {
    Position[] newTable = new Position[newSize];
    for (int i = 0; i < newTable.length; i++) {
      newTable[i] = table[i];
    }
    return newTable;
  }

  private Position[] appendTablePosition(Position[] table, Position element) {
    Position[] newTable = new Position[table.length + 1];
    for (int i = 0; i < table.length; i++) {
      newTable[i] = table[i];
    }
    newTable[table.length] = element;
    return newTable;
  }

  private Position getPositionOfTileHovered() {
    float x = (mouseX - mStartingX + mTileSize / 8) / (mTileSize + mTileSize / 4);
    float y = (mouseY - mStartingY + mTileSize / 8) / (mTileSize + mTileSize / 4);
    if ((int)x > mCurrentlevel.getWidth()-1 || x < 0) {
      return null;
    } else if ((int)y > mCurrentlevel.getHeight()-1 || y < 0) {
      return null;
    }
    return new Position((int)x, (int)y);
  }
  
  public boolean isMouseOnTheGrid(){
     return getPositionOfTileHovered() != null;
  }
  
  public void resetGame(){
    mTimer.stop();
    mCurrentPlayerPath = setNewSizeToTable(mCurrentPlayerPath, 0);
    updateLevelData(); 
  }
  
  public void mouseReleased(){
    if(mCurrentPlayerPath.length == 1){
      mCurrentPlayerPath = setNewSizeToTable(mCurrentPlayerPath, 0);
      updateLevelData();
      mTimer.stop();
      return;
    }
  }

  public void mouseDragged(){
    Position pos = getPositionOfTileHovered();
    if(pos != null){
      addNewPointToPath(pos, false, true);
    }
  }
  
  public void mousePressed(){
    Position pos = getPositionOfTileHovered();
    if(pos != null){
      addNewPointToPath(pos, true, true);
    }
  }
}


public class LevelSelectionScreen extends Screen implements ClickListener{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private int mStartingDrawLevel;
  
  private ImageButton mUpButton;
  private ImageButton mDownButton;
  private TextButton  mBackButton;
  private TextButton[]    mLevelButtons;

  public LevelSelectionScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate    = screenDeleguate;
    mData               = data;
    mTextures           = textures;
    mStartingDrawLevel  = 0;
    mUpButton           = new ImageButton(width/2 - 150, height/2 - 98, mTextures.mUpArrow);
    mDownButton         = new ImageButton(width/2 - 150, height/2 + 202, mTextures.mDownArrow);
    mBackButton         = new TextButton(width/2, height - 50, "retour", 36, mTextures.mLeftSelector);
    mLevelButtons       = new TextButton[5];
    for(int i = 0; i < mLevelButtons.length; i++){
      mLevelButtons[i]  = new TextButton(width/2 - 150, height/2 - 50 + i * 50, "bb", 36, mTextures.mLeftSelector);
      mLevelButtons[i].addListener(this);
    }
    
    mUpButton  .setMode(ImageButton.UP);
    mDownButton.setMode(ImageButton.DOWN);
    mUpButton  .addListener(this);
    mDownButton.addListener(this);
    mBackButton.addListener(this);
    actualiseButtons();
    mouseMoved();
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawLevels();
    tint(255, 127);
    mUpButton.drawButton();
    mDownButton.drawButton();
    tint(255, 255);
    mBackButton.drawButton();
    for(Button btn : mLevelButtons){
      btn.drawButton(); 
    }
  }
  
  private void actualiseButtons(){
    if(mStartingDrawLevel == 0){
       mUpButton.setVisibility(false);
    } else{
       mUpButton.setVisibility(true);
    }
    if(mStartingDrawLevel + 5 < mData.mLevels.size()){
      mDownButton.setVisibility(true);
    } else {
      mDownButton.setVisibility(false);
    }
    for(int i = 0; i < mLevelButtons.length && mStartingDrawLevel + i < mData.mLevels.size(); i++){
      mLevelButtons[i].setText(mData.mLevels.get(mStartingDrawLevel + i).mLevelName);
    }
  }
  
  public void onClick(Button src){
    if(src == mUpButton){
      mStartingDrawLevel --;
      actualiseButtons();
    } else if(src == mDownButton){
      mStartingDrawLevel ++;
      actualiseButtons();
    } else if(src == mBackButton){
      removeButtonsListeners();
      mScreenDeleguate.setMenuScreen();
    } else {
      for(int i = 0; i < mLevelButtons.length; i++){
        if(src == mLevelButtons[i]){
          removeButtonsListeners();
          mScreenDeleguate.setOnGameScreen(mData.mLevels.get(mStartingDrawLevel + i));
        }
      }
    }
  }
  
  private void removeButtonsListeners(){
    mBackButton.removeListener(this);
    mUpButton  .removeListener(this);
    mDownButton.removeListener(this);
    for(Button btn : mLevelButtons){
      btn.removeListener(this);
    }
  }

  public void drawLevels(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("niveau", width/2 - gap, height/2 - 150);
    text("meilleur", width/2 + gap, height/2 - 200);
    text("score", width/2 + gap, height/2 - 150);
    for(int i = 0; i < 5 && mStartingDrawLevel + i < mData.mLevels.size(); i++){
      // Affichage du temps
      String levelName = mData.mLevels.get(mStartingDrawLevel + i).mLevelName;
      if(mData.getCurrentplayer().getTimeAtLevel(levelName).toInteger() != -1){
        text(mData.getCurrentplayer().getTimeAtLevel(levelName).toStringFormat(2), width/2 + gap, height/2 - 50 + i * 50);
      } else {
        text("###", width/2 + gap, height/2 - 50 + i * 50);
      }
    }
  }

  public void mouseClicked(){
    mBackButton.isClick();
    mUpButton  .isClick();
    mDownButton.isClick();
    for(Button btn : mLevelButtons){
      btn.isClick(); 
    }
    mouseMoved();
  }

  public void mouseMoved(){
    // La souris bouge, je préviens mes boutons et si elle n'est sur aucun, je met le curseur par défaut
    if(mBackButton.isMouseOnIt()) return; 
    else if(mUpButton.isMouseOnIt()) return; 
    else if(mDownButton.isMouseOnIt()) return; 
    for(Button btn : mLevelButtons){
      if(btn.isMouseOnIt()) return; 
    }
    cursor(ARROW);
  }
  
  public void sizeChanged(){
    mUpButton.setPosition(width/2 - 150, height/2 - 98);
    mDownButton.setPosition(width/2 - 150, height/2 + 202);
    mBackButton.setPosition(width/2, height - 50);
    for(int i = 0; i < mLevelButtons.length; i++){
      mLevelButtons[i].setPosition(width/2 - 150, height/2 - 50 + i * 50);
    }
  }
}

public class MenuScreen extends Screen implements ClickListener{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private String[] menuContent = {"Jouer", "Scores", "Aide", "Editeur",  "Quitter"};
  private Button[] mButtons;

  MenuScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    // Génération des boutons
    mButtons = new TextButton[menuContent.length];
    for(int i = 0; i < menuContent.length; i++){
      mButtons[i] = new TextButton(width/2, height/2 - 100 + i * 50, menuContent[i], 36, mTextures.mLeftSelector, mTextures.mRightSelector);
      mButtons[i].addListener(this);
    }
    mouseMoved();
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawMenu();
    imageMode(CENTER);
    image(mTextures.mAward, width/2, height - 150);
  }

  public void drawMenu(){
    fill(mTextures.mTextColor);
    for(Button btn : mButtons){
      btn.drawButton(); 
    }
  }
  
  public void onClick(Button src){
    if(src == mButtons[0]) mScreenDeleguate.setLevelSelectionScreen();
    else if(src == mButtons[1]) mScreenDeleguate.setScoreScreen();
    else if(src == mButtons[2]) mScreenDeleguate.setHelpScreen();
    else if(src == mButtons[3]) mScreenDeleguate.setCreateEditorScreen();
    else if(src == mButtons[4]) mScreenDeleguate.setLaunchScreen();
    for(Button btn : mButtons){
      btn.removeListener(this); 
    }
  }

  public void mouseClicked(){
    for(Button btn : mButtons){
      btn.isClick(); 
    }
  }

  public void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    // Si la souris n'est sur aucun, je met le curseur par défaut
    for(Button btn : mButtons){
      if(btn.isMouseOnIt()) return; 
    }
    cursor(ARROW);
  }
  
  public void sizeChanged(){
    for(int i = 0; i < menuContent.length; i++){
      mButtons[i].setPosition(width/2, height/2 - 100 + i * 50);
    } 
  }
}

public class OnGameScreen extends Screen implements ClickListener{
  private final ScreenDeleguate mScreenDeleguate;
  private final DataDeleguate mData;
  private final TextureDeleguate mTextures;
  
  private final LevelDrawer mLeveldrawer;
  private final Level mCurrentlevel;
  
  private final TextButton mLeaveButton;
  private final TextButton mReloadButton;

  OnGameScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures, Level level){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    mCurrentlevel = level;
    mLeveldrawer = new LevelDrawer(dataDeleguate, textures, level);
    mLeaveButton = new TextButton(width/2 - 150, height - 50, "Sortir", 36, mTextures.mLeftSelector);
    mReloadButton = new TextButton(width/2 + 150, height - 50, "Relancer", 36, mTextures.mLeftSelector);
    mLeaveButton.addListener(this);
    mReloadButton.addListener(this);
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    drawHeader();
    mLeveldrawer.draw();
    fill(mTextures.mTextColor);
    mLeaveButton.drawButton();
    mReloadButton.drawButton();
    mouseMoved();
  }

  public void onClick(Button src){
    if(src == mLeaveButton){
      mLeaveButton.removeListener(this);
      mReloadButton.removeListener(this);
      mScreenDeleguate.setLevelSelectionScreen();
    } else if(src == mReloadButton) mLeveldrawer.resetGame();
  }

  private void drawHeader(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Temps", width/2, 50);
    text("Actuel", width/2 - gap, 100);
    text(mLeveldrawer.getScore().toStringFormat(2), width/2 - gap, 150);
    text("Meilleur", width/2 + gap, 100);
    text(mData.getCurrentplayer().getTimeAtLevel(mCurrentlevel.getname()).toStringFormat(2), width/2 + gap, 150);
  }

  public void mouseReleased(){
    mLeveldrawer.mouseReleased();
  }

  public void mouseDragged(){
    mLeveldrawer.mouseDragged();
  }
  
  public void mouseClicked(){
    mLeaveButton.isClick();
    mReloadButton.isClick();
  }
  
  public void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    // Si la souris n'est sur aucun, je met le curseur par défaut
    if(mLeaveButton.isMouseOnIt()) return; 
    else if(mReloadButton.isMouseOnIt()) return; 
    
    if(mLeveldrawer.isMouseOnTheGrid() && !mousePressed){
      cursor(HAND);
    } else if(mLeveldrawer.isMouseOnTheGrid() && mousePressed){
      cursor(MOVE);
    } else {
      cursor(ARROW);
    }
  }

  public void mousePressed(){
    mLeveldrawer.mousePressed();
  }

  public void sizeChanged(){
    mLeveldrawer.setSize();
    mLeaveButton.setPosition(width/2 - 150, height - 50);
    mLeaveButton.setPosition(width/2 + 150, height - 50);
  }
}


public class Player {
  private final static String PLAYER_PATH = "/players/";
  private final String mPlayerName;
  public HashMap<String, Integer> mScores = new HashMap<String, Integer>();

  public Player(String playerName) {
    mPlayerName = playerName;
    // Il faut vérifier si le joueur existe dans la base
    File[] files = listFiles(PLAYER_PATH);
    for (int i = 0; i < files.length; i++) {
      if (split(files[i].getName(), '.')[0].equals(playerName)) {
        // Le joueur a déja un fichier on récupère ses informations
        String[] file = loadStrings(PLAYER_PATH + playerName + ".txt");
        for (int j = 0; j < file.length; j++) {
          String[] line = split(file[j], ';');
          mScores.put(line[0], Integer.parseInt(line[1]));
        }
        return;
      }
    }
    // Le joueur n'existe pas dans la base, on lui créé un fichier 
    String[] lines = new String[0];
    saveStrings(PLAYER_PATH + playerName + ".txt", lines);
  }

  public String getName() {
    return mPlayerName;
  }

  public void setNewScore(Level level, int time) {
    // Changer la valeur dans la variable
    if (mScores.containsKey(level.getname())) {
      if (getTimeAtLevel(level.getname()).toInteger() > time) {
        // Le joueur viens de battre son score, alors le réécrire
        mScores.replace(level.getname(), time);
        rewritePlayerFile();
        return;
      } else {
        // Rien n'a changé alors ne rien faire
        return;
      }
    }
    // Changer la valeur dans le fichier
    mScores.put(level.getname(), time);
    rewritePlayerFile();
  }

  public void rewritePlayerFile() {
    String[] lines = new String[0];
    for (Map.Entry<String, Integer> score : mScores.entrySet()) {
      lines = append(lines, score.getKey() + ";" + score.getValue());
    }
    saveStrings(PLAYER_PATH + mPlayerName + ".txt", lines);
  }

  public Time getTimeAtLevel(String levelName) {
    if (mScores.get(levelName) == null) {
      return new Time(-1);
    } else {
      return new Time(mScores.get(levelName));
    }
  }
}
class Position{
  final int x;
  final int y;
  
  Position(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  public int getX(){
    return this.x; 
  }
  
  public int getY(){
    return y; 
  }
  
  public boolean equals(Position pos){
    return this.x == pos.x && this.y == pos.y;
  }
  
  public boolean isNextTo(Position pos){
    return (abs(this.x - pos.x) == 1 && this.y - pos.y == 0)
            || (abs(this.y - pos.y) == 1 && this.x - pos.x == 0);
  }
  
  public final boolean canItCross(Position p1, Position p2, Position p3){
    //println("Position a check " + p1.x + ":" + p1.y + " " + p2.x + ":" + p2.y + " " + p3.x + ":" + p3.y + " ");
    if(p1.x - p2.x == 0 && p1.x - p3.x == 0){
      // Allignés sur l'axe des x 
      boolean res = this.x - p1.x == 0;
      return !res;
    } else if(p1.y - p2.y == 0 && p1.y - p3.y == 0){
     // Allignés sur l'axe des y
      boolean res = this.y - p1.y == 0;
      return !res;
    } else {
     return false; 
    }
  }
  
  public final boolean canItCross(Position p1, Position p2){
    if(p1.x - p2.x == 0){
      // Allignés sur l'axe des x 
      boolean res = this.x - p1.x == 0;
      return !res;
    } else if(p1.y - p2.y == 0){
     // Allignés sur l'axe des y 
     boolean res = this.y - p1.y == 0;
     return !res;
    } else {
     return false; 
    }
  }
}


public class ScoreScreen extends Screen implements ClickListener{
  private ScreenDeleguate     mScreenDeleguate;
  private DataDeleguate       mData;
  private TextureDeleguate    mTextures;
  
  private int                 mCurrentDisplayedLevelID;
  private ArrayList<Player>   mPlayersToDisplay;
  private String              mCurrentDisplayedLevelName;
  private int                 mCurrentFirstDisplayedPlayer;
  
  private ImageButton mUpButton;
  private ImageButton mDownButton;
  private ImageButton mLeftButton;
  private ImageButton mRightButton;
  private TextButton  mBackButton;
  
  
  public ScoreScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures) {
    mScreenDeleguate             = screenDeleguate;
    mData                        = dataDeleguate;
    mTextures                    = textures;
    mCurrentDisplayedLevelID     = 0;
    mCurrentFirstDisplayedPlayer = 0;
    
    mBackButton = new TextButton(width/2, height - 50, "Retour", 36, mTextures.mLeftSelector);
    mUpButton = new ImageButton(width/2 , height/2 - 98, mTextures.mUpArrow);
    mDownButton = new ImageButton(width/2 , height/2 + 202, mTextures.mDownArrow);
    mLeftButton = new ImageButton(width/2 - 30 - textWidth("Niveau " + mCurrentDisplayedLevelName)/2, height/2 + 250, mTextures.mLeftArrow);
    mRightButton = new ImageButton(width/2 + 30 + textWidth("Niveau " + mCurrentDisplayedLevelName)/2, height/2 + 250, mTextures.mRightArrow);
    
    mUpButton.addListener(this);
    mDownButton.addListener(this);
    mLeftButton.addListener(this);
    mRightButton.addListener(this);
    mBackButton.addListener(this);
    
    mUpButton.setMode(ImageButton.UP);
    mDownButton.setMode(ImageButton.DOWN);
    mLeftButton.setMode(ImageButton.LEFT);
    mRightButton.setMode(ImageButton.RIGHT);
    refreshList();
    updateButtons();
  }
  
  public void onClick(Button src){
    if(src == mUpButton){
      mCurrentFirstDisplayedPlayer--;
    } else if(src == mDownButton){
      mCurrentFirstDisplayedPlayer++;
    } else if(src == mLeftButton){
      mCurrentDisplayedLevelID--;
      mCurrentFirstDisplayedPlayer = 0;
      refreshList();
    } else if(src == mRightButton){
      mCurrentDisplayedLevelID++;
      mCurrentFirstDisplayedPlayer = 0;
      refreshList();
    } else if(src == mBackButton){
      mBackButton.removeListener(this);
      mUpButton.removeListener(this);
      mDownButton.removeListener(this);
      mLeftButton.removeListener(this);
      mRightButton.removeListener(this);
      mScreenDeleguate.setMenuScreen();
    }
    updateButtons();
    updateButtonsPosition();
    refreshList();
  }
  
  private void updateButtons(){
    if(mCurrentFirstDisplayedPlayer > 0){
      mUpButton.setVisibility(true);
    } else {
      mUpButton.setVisibility(false);
    }
    if(mCurrentFirstDisplayedPlayer + 5 < mPlayersToDisplay.size()){
      mDownButton.setVisibility(true);
    } else {
      mDownButton.setVisibility(false);
    } 
    if(mCurrentDisplayedLevelID > 0 ){
      mLeftButton.setVisibility(true);
    } else {
      mLeftButton.setVisibility(false);
    }
    if(mCurrentDisplayedLevelID < mData.mLevels.size() - 1 ){
      mRightButton.setVisibility(true);
    } else {
      mRightButton.setVisibility(false);
    }
  }
  
  // Affiche l'écran complet
  public void drawScreen(){
    mouseMoved();
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawScores();
    mUpButton.drawButton();
    mDownButton.drawButton();
    mLeftButton.drawButton();
    mRightButton.drawButton();
    mBackButton.drawButton();
  }
  
  // Affiche le corps de la page (les scores et les flèches)
  private void drawScores(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    imageMode(CENTER);
    fill(mTextures.mTextColor);
    text("Tableau des scores", width/2, 200);
    text("Joueur", width/2 - gap, height/2 - 150);
    text("Score", width/2 + gap, height/2 - 150);
    for(int i = 0; i < 5 && mCurrentFirstDisplayedPlayer + i < mPlayersToDisplay.size(); i++){
      // Affichage du nom du joueur
      textAlign(LEFT, CENTER);
      text((mCurrentFirstDisplayedPlayer + i + 1)+ " " + mPlayersToDisplay.get(i).getName(), width/2 - gap - 140, height/2 - 50 + i * 50);
      // Affichage du temps
      textAlign(CENTER, CENTER);
      text(mPlayersToDisplay.get(mCurrentFirstDisplayedPlayer + i).getTimeAtLevel(mCurrentDisplayedLevelName).toStringFormat(2), width/2 + gap, height/2 - 50 + i * 50);
    }
    // Affichage du nom du niveau courrant
    textAlign(CENTER, CENTER);
    text("Niveau " + mCurrentDisplayedLevelName, width/2, height/2 + 250);
  }

  // Actualise les variables qui me permettent l'affichage de la page
  private void refreshList(){
    mCurrentDisplayedLevelName = mData.mLevels.get(mCurrentDisplayedLevelID).mLevelName;
    mPlayersToDisplay = mData.getPlayersOfLevel(mCurrentDisplayedLevelID);
    sortListByBestPlayer();
  }
  
  // Tri la liste de mes joueurs en fonction de leur temps sur le niveau affiché
  private void sortListByBestPlayer(){
    for(int i = 0; i < mPlayersToDisplay.size(); i++){
      for(int j = i; j < mPlayersToDisplay.size(); j++){
        if(mPlayersToDisplay.get(j).getTimeAtLevel(mCurrentDisplayedLevelName).toInteger() < mPlayersToDisplay.get(i).getTimeAtLevel(mCurrentDisplayedLevelName).toInteger()){
          Collections.swap(mPlayersToDisplay, i, j);
        }
      }
    }
  }

  public void mouseClicked(){
    mUpButton.isClick();
    mDownButton.isClick();
    mLeftButton.isClick();
    mRightButton.isClick();
    mBackButton.isClick();
  }
  
  public void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    // Si la souris n'est sur aucun, je met le curseur par défaut
    if(!mUpButton.isMouseOnIt() 
        && !mDownButton.isMouseOnIt()
        && !mLeftButton.isMouseOnIt()
        && !mRightButton.isMouseOnIt() 
        && !mBackButton.isMouseOnIt()){
      cursor(ARROW);
    }
  }
  
  private void updateButtonsPosition(){
    mBackButton.setPosition(width/2, height - 50);
    mUpButton.setPosition(width/2 , height/2 - 98);
    mDownButton.setPosition(width/2 , height/2 + 202);
    mLeftButton.setPosition(width/2 - 30 - textWidth("Niveau " + mCurrentDisplayedLevelName)/2, height/2 + 250);
    mRightButton.setPosition(width/2 + 30 + textWidth("Niveau " + mCurrentDisplayedLevelName)/2, height/2 + 250);
  }
  
  public void sizeChanged(){
    updateButtonsPosition();
  }
}
abstract class Screen {
  public abstract void drawScreen();
  public void keyPressed(){}
  public void mouseClicked(){}
  public void mouseMoved(){}
  public void mouseDragged(){}
  public void mousePressed(){}
  public void mouseReleased(){}
  public void sizeChanged(){}
}
class ScreenDeleguate {
  private Screen mCurrentScreen;
  private final DataDeleguate mData;
  private final TextureDeleguate mTextures;

  public ScreenDeleguate(DataDeleguate data, TextureDeleguate textures) {
    this.mData = data;
    this.mTextures = textures;
  }

  public final void drawScreen() {
    this.mCurrentScreen.drawScreen();
  }
  
  public void sizeChanged(){
    this.mCurrentScreen.sizeChanged(); 
  }

  public void aKeyWasPressed(){
    this.mCurrentScreen.keyPressed();
  }

  public void mouseIsClicked(){
    this.mCurrentScreen.mouseClicked();
  }
  
  public void mouseIsDragged(){
    this.mCurrentScreen.mouseDragged(); 
  }

  public void mouseIsMoved(){
    this.mCurrentScreen.mouseMoved();
  }
  
  public void mouseIsPressed(){
    this.mCurrentScreen.mousePressed(); 
  }

  public void mouseIsReleased(){
    this.mCurrentScreen.mouseReleased(); 
  }
  
  public final void setHelpScreen(){
    this.mCurrentScreen = new HelpScreen(this, mData, mTextures);
  }
  
  public final void setSetupEditorScreen(Level level){
    this.mCurrentScreen = new SetupEditorScreen(this, mData, mTextures, level); 
  }
  
  public final void setCreateEditorScreen(){
    this.mCurrentScreen = new CreateEditorScreen(this, mData, mTextures);
  }
  
  public final void setLaunchScreen() {
    this.mCurrentScreen = new LaunchScreen(this, mData, mTextures);
  }
  
  public final void setScoreScreen(){
    this.mCurrentScreen = new ScoreScreen(this, mData, mTextures); 
  }

  public final void setMenuScreen() {
    this.mCurrentScreen = new MenuScreen(this, mData, mTextures);
  }

  public final void setLevelSelectionScreen(){
    this.mCurrentScreen = new LevelSelectionScreen(this, mData, mTextures);
  }
  
  public final void setOnGameScreen(Level level){
    this.mCurrentScreen = new OnGameScreen(this, mData, mTextures, level);
  }
}

public class SetupEditorScreen extends Screen{
  private final ScreenDeleguate   mScreenDeleguate;
  private final DataDeleguate     mData;
  private final TextureDeleguate  mTextures;
  
  private final Level mCurrentlevel;
  private final EditorDrawer mEditordrawer;
  private TextButton  mBackButton;
  private TextButton  mCreateButton;
 
  public SetupEditorScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures, Level level){
    mScreenDeleguate  = screenDeleguate;
    mData             = dataDeleguate;
    mTextures         = textures;
    mCurrentlevel     = level;
    mEditordrawer     = new EditorDrawer(dataDeleguate, textures, level);
    mBackButton       = new TextButton(width/2 - 150, height - 50, "Retour", 36, mTextures.mLeftSelector);
    mCreateButton     = new TextButton(width/2 + 150, height - 50, "Créer", 36, mTextures.mLeftSelector);
  }
  
  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mEditordrawer.draw();
    fill(mTextures.mTextColor);
    mBackButton.drawButton();
    mCreateButton.drawButton();
    drawHeader();
  }
  
  private void drawHeader(){
    textAlign(CENTER, CENTER);
    textFont(mTextures.mFont, 36);
    text("Niveau : " + mCurrentlevel.getname(), width/2, 100.f);
    textFont(mTextures.mFont, 18);
    text("Dessinez le niveau", width/2, 150.f);
  }
  
  public void mouseClicked(){
    if(mBackButton.isMouseOnIt()){
      // Le bouton Retour est cliqué, on affiche le menu
      mScreenDeleguate.setMenuScreen();
    } else if(mCreateButton.isMouseOnIt()){
      // Le bouton créer est cliqué, on créé le niveau et on lance la page de création
      mEditordrawer.saveLevel();
      mData.mLevels.add(mCurrentlevel);
      mScreenDeleguate.setMenuScreen();
    }
  }

  public void mouseReleased(){
    mEditordrawer.mouseReleased();
  }

  public void mouseDragged(){
    mEditordrawer.mouseDragged();
  }
  
  public void mousePressed(){
    mEditordrawer.mousePressed();
  }
  
  public void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    if(!mBackButton.isMouseOnIt() 
        && !mCreateButton.isMouseOnIt()){
      cursor(ARROW);
    }
  }
  
  public void sizeChanged(){
    // La taille de la fenetre change, je recalcule les positions des boutons et champs de texte
    mBackButton.setPosition(width/2 - 150, height - 50);
    mCreateButton.setPosition(width/2 + 150, height - 50);
    mEditordrawer.setSize();
  }
}
public class TextField{
  public static final int ONLY_NUMBERS = 1;
  public static final int ONLY_CHARACTERS = 2;
  public static final int NUMBERS_AND_CHARACTERS = 3;
  public static final int OUTLINED = 1;
  public static final int BORDERLESS = 2;
  public static final int RIGHT_ALIGN = 1;
  public static final int CENTER_ALIGN = 2;
  public static final int LEFT_ALIGN = 3;
  
  private int       mPosX;
  private int       mPosY;
  private int       mWidth;
  private int       mHeight;
  private String    mContent;
  private boolean   mState;
  private int       mFilter;
  private int       mStyle;
  private int       mAlignment;
  private int       mDigitLimit;
  
  public TextField(int posX, int posY, int width, int height){
    this(posX, posY, width, height, 10);
  }
  
  public TextField(int posX, int posY, int width, int height, int digitLimit){
    mPosX         = posX;
    mPosY         = posY;
    mWidth        = width;
    mHeight       = height;
    mState        = false;
    mFilter       = NUMBERS_AND_CHARACTERS;
    mStyle        = OUTLINED;
    mAlignment    = CENTER_ALIGN;
    mDigitLimit   = digitLimit;
    mContent      = "";
  }
  
  public void drawTextField(){
    if(mStyle == OUTLINED){
      // Afficher les rebords de la zone de texte
      fill(0,0);
      strokeWeight(3);
      stroke(255);
      rectMode(CORNER);
      rect(mPosX, mPosY, mWidth, mHeight);
      noStroke();
    }

    fill(255);
    String str = mContent;
    if(second()%2 == 0 && mState){
      str+="|";
    }
    drawText(str);
  }
  
  private void drawText(String text){
    if(mAlignment == CENTER_ALIGN){
      textAlign(CENTER,CENTER);
      text(text, mPosX + mWidth / 2, mPosY + mHeight / 2);
    } else if(mAlignment == RIGHT_ALIGN){
      textAlign(RIGHT,CENTER);
      text(text, mPosX + mWidth / 2, mPosY + mHeight);
    } else if(mAlignment == LEFT_ALIGN){
      textAlign(LEFT,CENTER);
      text(text, mPosX + mWidth / 2, mPosY);
    }
  }
  
  public void setAlignment(int value){
    if(value >= 1 && value <= 3){
      mAlignment = value;
    } else {
      throw new Error(value + "n'est pas un alignement compatible au TextField"); 
    }
  }
  
  public void setStyle(int value){
    if(value >= 1 && value <= 2){
      mStyle = value;
    } else {
      throw new Error(value + "n'est pas un style compatible au TextField"); 
    }
  }
  
  public void setPosition(int x, int y){
    mPosX = x;
    mPosY = y;
  }
  
  public void aKeyWasPressed(char character){
    if(!mState){
      return;
    } else {
      if (character == ENTER){
        //mState = false;
      } else if(character == BACKSPACE && mContent.length() > 0){
        mContent = mContent.substring(0, mContent.length() - 1);
      } else if(!(character == CODED) && mContent.length() < mDigitLimit){
        if(mFilter == NUMBERS_AND_CHARACTERS && character != BACKSPACE && character != '.'){
          mContent += character;
        } else if(mFilter == ONLY_NUMBERS && Character.isDigit(character)){
          mContent += character;
        } else if(mFilter == ONLY_CHARACTERS && Character.isLetter(character)){
          mContent += character;
        }
      }
    }
  }
  
  public boolean isMouseOnIt(){
    if(isMouseBetweenPos(mPosX, mPosX + mWidth, mPosY, mPosY + mHeight)){
      cursor(HAND);
      return true;
    } else {
      return false;
    }
  }
  
  // Renvoi true si la position de la souris est entre les valeurs
  private boolean isMouseBetweenPos(int startX, int endX, int startY, int endY){
    return mouseX > startX
      && mouseX < endX
      && mouseY > startY
      && mouseY < endY;
  }
  
  public void isClick(){
    if(isMouseOnIt()){
      setActive(true);
    } else {
      setActive(false); 
    }
  }
  
  public void setActive(boolean state){
    mState = state;
  }
  
  public void setFilter(int filterType){
    if(filterType >= 1 && filterType <= 3){
      mFilter = filterType;
    } else {
      throw new Error(filterType + "n'est pas un filtre compatible au TextField"); 
    }
  }
  
  public String getText(){
    return mContent;
  }
}
public class TextureDeleguate{
  private final PFont mFont;

  private final PImage mRightSelector;
  private final PImage mLeftSelector;

  private final PImage mUpArrow;
  private final PImage mDownArrow;
  private final PImage mLeftArrow;
  private final PImage mRightArrow;
  
  private final PImage mAward;

  private final int mBackgroundColor;
  private final int mTextColor;
  private final int mErrorColor;
  private final int mTextShadowColor;
  private final int mEmptyCellColor;
  private final int mWorkingCellColor;
  private final int mSelectorCellColor;
  private final int mLineColor;
  private final int mLineDotColor;

  public TextureDeleguate(){
    mFont = createFont("SuperLegendBoy.ttf", 32);

    mRightSelector = loadImage("data/selecteur_droit.png");
    mLeftSelector = loadImage("data/selecteur_gauche.png");

    mUpArrow = loadImage("data/up_arrow.png");
    mDownArrow = loadImage("data/down_arrow.png");
    mLeftArrow = loadImage("data/left_arrow.png");
    mRightArrow = loadImage("data/right_arrow.png");
    
    mAward = loadImage("data/award.png");

    mBackgroundColor = color(5, 5, 5);
    mTextColor = color(255);                                  // 255,211,56
    mErrorColor = color(237, 28, 36);
    mTextShadowColor = color(255, 158, 147);                  // Pink
    mEmptyCellColor = color(237, 28, 36);                     // Red
    mWorkingCellColor = color(255);
    mSelectorCellColor = color(5, 255, 71);
    mLineColor = color(18, 43, 255);
    mLineDotColor = color(43, 65, 255);
    // Color palette : #FF050D #FFD338 #FF1F26 #05FF47 #122BFF
  }
  
  public void drawTitle(){
    textFont(mFont, 64);
    textAlign(CENTER, CENTER);
    fill(mTextShadowColor);
    text("Telegraph", width/2+4, 84);
    fill(mTextColor);
    text("Telegraph", width/2, 80);
  }
  
  public void drawTelegraphTile(float xPos, float yPos, float tileSize) {
    float tilePad = tileSize / 8.0f;
    rectMode(CORNER);
    fill(mWorkingCellColor);
    rect(xPos, yPos, tileSize, tileSize);
    fill(mBackgroundColor);
    rect(xPos + tilePad, yPos + tilePad, tilePad * 6, tilePad * 6);
    fill(mWorkingCellColor);
    rect(xPos + tilePad * 3, yPos + tilePad * 3, tilePad * 2, tilePad * 2);
  }

  public void drawEmptyTile(float xPos, float yPos, float tileSize) {
    float tilePad = tileSize / 8.0f;
    rectMode(CORNER);
    fill(mEmptyCellColor);
    rect(xPos, yPos, tileSize, tileSize);
    fill(mBackgroundColor);
    rect(xPos + tilePad, yPos + tilePad, tilePad * 6, tilePad * 6);
  }

  public void drawSelectorTile(float xPos, float yPos, float tileSize) {
    float tilePad = tileSize / 10.0f;
    float cornerSize = tilePad*3 - second()%2*tilePad;
    float gap = tileSize / 2;
    rectMode(CORNER);
    fill(mSelectorCellColor);
    rect(xPos, yPos, cornerSize, cornerSize);
    rect(xPos + tileSize-cornerSize, yPos, cornerSize, cornerSize);
    rect(xPos, yPos + tileSize-cornerSize, cornerSize, cornerSize);
    rect(xPos + tileSize-cornerSize, yPos + tileSize-cornerSize, cornerSize, cornerSize);
  }
}

  
public class Timer{
  private boolean mState;
  private int mTimeAtPause;
  private int mMillisAtStart;
 
  public Timer(){
    mState = false;
  }
  
  public void start(){
    mState = true;
    mMillisAtStart = millis();
  }
  
  public void stop(){
    mTimeAtPause = mMillisAtStart;
    mState = false;
  }
  
  public void pause(){
    if(mState == true){
      mTimeAtPause = millis();
      mState = false;
    }
  }
  
  public void resume(){
    mMillisAtStart += (millis() - mTimeAtPause);
    mState = true;
  }
  
  public Time getTime(){
    return mState ? new Time(millis() - mMillisAtStart) : new Time(mTimeAtPause - mMillisAtStart);
  }
  /*
  public void reset(){
    
  }
  */
}

public class Time{
  private int mTime;
  
  public Time(int millis){
    mTime = millis;
  }
  
  public int toInteger(){
    return mTime;
  }
  
  public final String toStringFormat(int decimals){
    switch(decimals){
      case 0 :
        return (mTime/1000 + "s");
      case 1 :
        return (mTime/1000 + "." + mTime/100%10+ "s");
      case 2 :
        return (mTime/1000 + "." + mTime/100%10 + mTime/10%10 + "s");
      default :
        return (mTime/1000 + "." + mTime/100%10 + mTime/10%10 + mTime%1000+ "s");
    }
  }
}
  public void settings() {  size(640,860);  noSmooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Telegraph" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
