import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Arrays; 
import java.util.*; 
import java.util.ArrayList; 
import java.util.ArrayList; 
import java.util.HashMap; 

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
  frameRate(1000);
  
  
  noStroke();
  lastheight = height;
  lastWidth = width;
  surface.setResizable(true);
  data = new DataDeleguate();
  textures = new TextureDeleguate();
  screen = new ScreenDeleguate(data, textures);
  screen.setLaunchScreen();
  //screen.setOnGameScreen(data.mLevels.get(0));
}

public void draw(){
  if(width != lastWidth || height != lastheight){
    lastWidth = width;
    lastheight = height;
    sizeChanged();
  }
  screen.drawScreen();
  text((int)frameRate, 100, 20);
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
      //println(split(files[i].getName(), '.')[0]);
      Player player = new Player(split(files[i].getName(), '.')[0]);
      mPlayers.add(player);
    }
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

public class HelpScreen extends Screen {
  private ScreenDeleguate     mScreenDeleguate;
  private DataDeleguate       mData;
  private TextureDeleguate    mTextures;

  private boolean             mOnBackButton;

  private String[]            mAdaptedText;
  private String[]            mMainText = { "Chaques niveaux comporte une grille remplie de stations télégraphiques.",
                                            "Suite à la dernière érruption du Piton de la Fournaise-Niels, certaines sont déconnectées.",
                                            "Pour les reconnecter, tu dispose d'un fil.",
                                            "Clique sur une station pour le commencer et déplace ta souris en maintenant le clic pour le continuer.",
                                            "Le passage d'un fil change l'état de la station.",
                                            "Mais attention, si un fil passe sur une station déja connectée, cela brouille son signal et la station se déconnecte." };

  HelpScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures) {
    mScreenDeleguate   = screenDeleguate;
    mData              = dataDeleguate;
    mTextures          = textures;
    mAdaptedText       = new String[0];
    sizeChanged();
  }

  public void drawScreen() {
    background(mTextures.mBackgroundColor);
    drawTitle();
    drawBody();
    drawBackbutton();
  }

  public void drawTitle() {
    textFont(mTextures.mFont, 64);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextShadowColor);
    text("Telegraph", width/2+4, 84);
    fill(mTextures.mTextColor);
    text("Telegraph", width/2, 80);
  }

  public void drawBody() {
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Aide générale", width/2, 200);

    textFont(mTextures.mFont, 18);
    textAlign(LEFT, CENTER);
    text("Connecté", width/2 + 10, 240 + 48/2);
    text("Déconnecté", width/2 + 10, 240 + 48 / 2 + 48/8 + 48);
    mTextures.drawEmptyTile(width/2 - 55, 240, 48);
    mTextures.drawTelegraphTile(width/2 - 55, 240 + 48 + 48/8, 48);

    textAlign(CENTER, CENTER);
    for(int i = 0; i < mAdaptedText.length; i++){
      text(mAdaptedText[i], width/2, 370 + i * 30);
    }
  }

  public void drawBackbutton(){
    String word = "retour";
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text(word, width/2, height - 50);
    if(mOnBackButton){
      image(mTextures.mLeftSelector, width/2 - (int)textWidth(word) / 2 - 30 - second()%2*10, height - 48);
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

  private boolean isOnBackButton(){
     return mouseX > width / 2 - 100
      && mouseX < width / 2 + 100
      && mouseY > height - 70
      && mouseY < height - 30;
  }

  public void sizeChanged(){
    mAdaptedText = adaptToWidth(mMainText, 18, width - 50);
  }

  public void mouseClicked(){

  }



}

public class LaunchScreen extends Screen{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private String mCurrentName;

  LaunchScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    mCurrentName = "";
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    drawTitle();
    drawTiles();
    drawBody();
  }

  public void drawTitle(){
    textFont(mTextures.mFont, 64);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextShadowColor);
    text("Telegraph", width/2+4, 84);
    fill(mTextures.mTextColor);
    text("Telegraph", width/2, 80);
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
    String str = mCurrentName;
    if(second()%2 == 0){
      str+="|";
    }
    text(str, width/2, height/2);
    if(mCurrentName.length() > 0){
      text("[Appui sur Entrée]", width/2, height/2 + 64);
    }
  }

  public void keyPressed(){
    if (key == ENTER && mCurrentName.length() > 0){
      mData.setCurrentPlayerTo(mCurrentName);
      mScreenDeleguate.setMenuScreen();
    } else if(key == BACKSPACE && mCurrentName.length() > 0){
      mCurrentName = mCurrentName.substring(0, mCurrentName.length() - 1);
    } else if(Character.isLetterOrDigit(key)){
      mCurrentName += key;
    }
  }
}


public class Level{
  String mLevelName;
  int[][] mLevelMatrix;

  public Level(File filePath){
    String[] file = loadStrings("/levels/" + filePath.getName());
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


public class LevelDrawer {
  private final DataDeleguate mData;
  private final TextureDeleguate mTextures;

  private final Timer mTimer;

  private final Level mCurrentlevel;
  private Position[] mCurrentPlayerPath;
  private int[][] mPathTable;

  private float mTileSize;
  private float mStartingX;
  private float mStartingY;
  float mGap;

  public LevelDrawer(DataDeleguate dataDeleguate, TextureDeleguate textures, Level level) {
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

  public Time getScore(){
    return mTimer.getTime();
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

  private boolean isPositionInTheLevel(Position pos) {
    return pos.getX() >= 0
      && pos.getY() >= 0
      && pos.getX() < mCurrentlevel.getWidth()
      && pos.getY() < mCurrentlevel.getHeight();
  }

  private void updateLevelData() {
    updatePathTable();
    checkWin();
  }

  private void updatePathTable() {
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
    println(mTimer.getTime().toStringFormat(2));
    //screen.setMenuScreen();
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

public class LevelSelectionScreen extends Screen{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private int mSelectedLevel;
  private int mStartingDrawLevel;
  private boolean mOnBackButton;

  private boolean mMouseHavePriority;

  public LevelSelectionScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate = screenDeleguate;
    mData = data;
    mTextures = textures;
    mSelectedLevel = 0;
    mOnBackButton = false;
    mMouseHavePriority = false;
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    drawTitle();
    drawLevels();
    drawBackbutton();
  }

  public void drawTitle(){
    textFont(mTextures.mFont, 64);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextShadowColor);
    text("Telegraph", width/2+4, 84);
    fill(mTextures.mTextColor);
    text("Telegraph", width/2, 80);
  }

  public void drawLevels(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("niveaux", width/2 - gap, height/2 - 150);
    text("meilleur", width/2 + gap, height/2 - 200);
    text("score", width/2 + gap, height/2 - 150);

    if(!mMouseHavePriority){
      mStartingDrawLevel = mSelectedLevel - 2;

      if(mSelectedLevel - 2 < 0){
        mStartingDrawLevel = 0;
      } else if(mSelectedLevel + 2 > mData.mLevels.size() - 1){
        mStartingDrawLevel = mData.mLevels.size() - 5;
      }
    }

    // Affichage des fleches haut et bas
    tint(255, 127);
    if(mStartingDrawLevel > 0){
      image(mTextures.mUpArrow, width/2 - gap, height/2 - 98 + second()%2*10);
    }
    if(mStartingDrawLevel + 5 < mData.mLevels.size()){
      image(mTextures.mDownArrow, width/2 - gap, height/2 - 48 + 250 - second()%2*10);
    }
    tint(255, 255);

    for(int i = 0; i < 5 && mStartingDrawLevel + i < mData.mLevels.size(); i++){
      int levelId = mStartingDrawLevel + i;
      String levelName = mData.mLevels.get(levelId).mLevelName;
      text(levelName, width/2 - gap, height/2 - 50 + i * 50);

      // Affichage du temps
      if(mData.getCurrentplayer().getTimeAtLevel(levelName).toInteger() != -1){
        text(mData.getCurrentplayer().getTimeAtLevel(levelName).toStringFormat(2), width/2 + gap, height/2 - 50 + i * 50);
      } else {
        text("###", width/2 + gap, height/2 - 50 + i * 50);
      }


      if(levelId == mSelectedLevel && !mOnBackButton){
        int gap2 = (int)textWidth(levelName) / 2 + 30 + second()%2*10;
        imageMode(CENTER);
        image(mTextures.mLeftSelector, width/2 - gap - gap2, height/2 - 48 + i * 50);
      }
    }
  }

  public void drawBackbutton(){
    String word = "retour";
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text(word, width/2, height - 50);
    if(mOnBackButton){
      image(mTextures.mLeftSelector, width/2 - (int)textWidth(word) / 2 - 30 - second()%2*10, height - 48);
    }
  }

  public int isHoveringMenuId(){
    if(mStartingDrawLevel > 0){
      if(mouseX > width / 2 - 300
        && mouseX < width / 2 + 300
        && mouseY > height/2 - 70 + -1 * 50
        && mouseY < height/2 - 30 + -1 * 50){
          return -2;
      }
    }
    if(mStartingDrawLevel + 5 < mData.mLevels.size()){
      if(mouseX > width / 2 - 300
        && mouseX < width / 2 + 300
        && mouseY > height/2 - 70 + 5 * 50
        && mouseY < height/2 - 30 + 5 * 50){
          return -3;
      }
    }
    if(mouseX > width / 2 - 100
      && mouseX < width / 2 + 100
      && mouseY > height - 70
      && mouseY < height - 30){
        return -4;
    }
    for(int i = 0; i < 5 && mStartingDrawLevel + i < mData.mLevels.size(); i++){
      if(mouseX > width / 2 - 300
        && mouseX < width / 2 + 300
        && mouseY > height/2 - 70 + i * 50
        && mouseY < height/2 - 30 + i * 50){
          return i + mStartingDrawLevel;
      }
    }
    return -1;
  }

  public void keyPressed(){
      if (key == CODED) {
        if (
          keyCode == UP
          && mSelectedLevel > 0
          && !mOnBackButton) {
            mSelectedLevel--;
            mMouseHavePriority = false;
        } else if (
          keyCode == DOWN
          && mSelectedLevel < mData.mLevels.size() - 1
          && !mOnBackButton) {
            mSelectedLevel++;
            mMouseHavePriority = false;
        } else if (keyCode == LEFT || ( keyCode == UP && mSelectedLevel == mData.mLevels.size() - 1)) {
          mOnBackButton = false;
          mMouseHavePriority = false;
        } else if (keyCode == RIGHT || ( keyCode == DOWN && mSelectedLevel == mData.mLevels.size() - 1)) {
          mOnBackButton = true;
          mMouseHavePriority = false;
        }
      }
      if (key == ENTER && mOnBackButton){
        mScreenDeleguate.setMenuScreen();
      } else if(key == ENTER){
        mScreenDeleguate.setOnGameScreen(mData.mLevels.get(mSelectedLevel));
      }
  }

  public void mouseClicked(){
    int id = isHoveringMenuId();
    if(id != -1 && id != -4){
      // click sur un autre bouton que "retour"
      mOnBackButton = false;
      mMouseHavePriority = true;
      if(id == -2){
        // clik sur fleche du haut
        mSelectedLevel--;
        mStartingDrawLevel--;
      } else if(id == -3){
        // click sur fleche du bas
        mSelectedLevel++;
        mStartingDrawLevel++;
      } else {
        // click sur un niveau
        mSelectedLevel = id;
        mScreenDeleguate.setOnGameScreen(mData.mLevels.get(id));
      }
    } else if(id == -4){
      // click sur le bouton "retour"
      mOnBackButton = true;
      mScreenDeleguate.setMenuScreen();
    }
  }

  public void mouseMoved(){
    int id = isHoveringMenuId();
    if(id >= 0){
      mMouseHavePriority = true;
      mOnBackButton = false;
      mSelectedLevel = id;
    } else if(id == -4){
      mMouseHavePriority = true;
      mOnBackButton = true;
    }
  }
}

public class MenuScreen extends Screen{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private int mSelectedMenu;
  private String[] menuContent = {"jouer", "Scores", "Aide", "Editeur", "Crédits"};

  MenuScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    mSelectedMenu = 0;
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    drawTitle();
    drawMenu(menuContent, mSelectedMenu);
  }

  public void drawMenu(String[] menuContent, int selectedMenu){
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    for(int i = 0; i < menuContent.length; i++){
      text(menuContent[i], width/2, height/2 - 100 + i * 50);
      if(i == selectedMenu){
        int gap = (int)textWidth(menuContent[i]) / 2 + 30 + second()%2*10;
        imageMode(CENTER);
        image(mTextures.mLeftSelector, width/2 - gap, height/2 - 95 + i * 50);
        image(mTextures.mRightSelector, width/2 + gap, height/2 - 95 + i * 50);
      }
    }
  }

  public void drawTitle(){
    textFont(mTextures.mFont, 64);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextShadowColor);
    text("Telegraph", width/2+4, 84);
    fill(mTextures.mTextColor);
    text("Telegraph", width/2, 80);
  }

  public void keyPressed(){
    if (key == CODED) {
      if (keyCode == UP && mSelectedMenu >= 1) {
        mSelectedMenu--;
      } else if (keyCode == DOWN && mSelectedMenu <= 3) {
        mSelectedMenu++;
      }
    }
    if (key == ENTER){
      changeScreen();
    }
  }

  public void changeScreen(){
    switch(mSelectedMenu){
      case 0 :
        // Jouer
        mScreenDeleguate.setLevelSelectionScreen();
        break;
      case 1 :
        // Score board
        println("Score board");
        break;
      case 2 :
        // Help
        mScreenDeleguate.setHelpScreen();
        break;
      case 3 :
        // Editor
        println("Editor");
        break;
      case 4 :
        // Credits
        println("Credits");
    }
  }

  public int isHoveringMenuItemId(){
    for(int i = 0; i < menuContent.length; i++){
      if(mouseX > width / 2 - 200
        && mouseX < width / 2 + 200
        && mouseY > height/2 - 120 + i * 50
        && mouseY < height/2 - 80 + i * 50){
          return i;
      }
    }
    return -1;
  }

  public void mouseClicked(){
    if(isHoveringMenuItemId() != -1){
      mSelectedMenu = isHoveringMenuItemId();
      changeScreen();
    }
  }

  public void mouseMoved(){
    if(isHoveringMenuItemId() != -1){
      mSelectedMenu = isHoveringMenuItemId();
    }
  }
}

public class OnGameScreen extends Screen{
  private final ScreenDeleguate mScreenDeleguate;
  private final DataDeleguate mData;
  private final TextureDeleguate mTextures;
  
  private final LevelDrawer mLeveldrawer;
  private final Level mCurrentlevel;

  OnGameScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures, Level level){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    mCurrentlevel = level;
    mLeveldrawer = new LevelDrawer(dataDeleguate, textures, level);
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    drawHeader();
    mLeveldrawer.draw();
    drawFooter();
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

  private void drawFooter(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Sortir", width/2 - gap, height - 50);
    text("Relancer", width/2 + gap, height - 50);
    if(isHoveringButtonID() == 1){
      int selectorGap = (int)textWidth("Sortir") / 2 + 30 + second()%2*10;
      imageMode(CENTER);
      image(mTextures.mLeftSelector, width/2 - gap - selectorGap, height - 48);
      image(mTextures.mRightSelector, width/2 - gap + selectorGap, height - 48);
    } else if (isHoveringButtonID() == 2){
      int selectorGap = (int)textWidth("Relancer") / 2 + 30 + second()%2*10;
      imageMode(CENTER);
      image(mTextures.mLeftSelector, width/2 + gap - selectorGap, height - 48);
      image(mTextures.mRightSelector, width/2 + gap + selectorGap, height - 48);
    }
  }

  private int isHoveringButtonID(){
    if(mouseY > height - 70 && mouseY < height - 30){
      if(mouseX > width/2 - 300 &&  mouseX < width/2){
        // la souris est sur le bouton retour
        return 1; 
      } else if( mouseX > width/2 && mouseX < width/2 + 300){
        // la souris est sur le bouton relancer
        return 2; 
      }
    }
    return -1;
  }

  public void mouseReleased(){
    mLeveldrawer.mouseReleased();
  }

  public void mouseDragged(){
    mLeveldrawer.mouseDragged();
  }
  
  public void mouseClicked(){
    if (isHoveringButtonID() != -1){
      // La souris est sur un bouton
      if(isHoveringButtonID() == 1){
        // Revenir a la selection des niveaux
        mScreenDeleguate.setLevelSelectionScreen();
      } else if(isHoveringButtonID() == 2){
        // Relancer la partie
        mLeveldrawer.resetGame();
      }
    }
  }

  public void mousePressed(){
    mLeveldrawer.mousePressed();
  }

  public void sizeChanged(){
    mLeveldrawer.setSize();
  }
}


public class Player{
  public final static String PLAYER_PATH = "/players/";
  public final String mPlayerName;
  public HashMap<String, Integer> mScores = new HashMap<String, Integer>();

  public Player(String playerName){
    mPlayerName = playerName;
    // Il faut vérifier si le joueur existe dans la base
    File[] files = listFiles(PLAYER_PATH);
    for(int i = 0; i < files.length; i++){
      if(split(files[i].getName(), '.')[0].equals(playerName)){
        // Le joueur a déja un fichier on récupère ses informations
        String[] file = loadStrings(PLAYER_PATH + playerName + ".txt");
        for(int j = 0; j < file.length; j++){
          String[] line = split(file[j],';');
          mScores.put(line[0], Integer.parseInt(line[1]));
        }
        return;
      }
    }
    // Le joueur n'existe pas dans la base, on lui créé un fichier 
    String[] lines = new String[0];
    saveStrings(PLAYER_PATH + playerName + ".txt", lines);
  }

  public void setNewScore(Level level, int time){
    // Changer la valeur dans la variable
    if(mScores.containsKey(level.getname())){
      if(getTimeAtLevel(level.getname()).toInteger() > time){
        // Le joueur viens de battre son score, alors le réécrire
        mScores.replace(level.getname(), time);
        println("New score !");
        rewritePlayerFile();
        return;
      } else {
        // Rien n'a changé alors ne rien faire
        return;
      }
    }
    // Changer la valeur dans le fichier
    println("Valeur enregistrée");
    mScores.put(level.getname(), time);
    rewritePlayerFile();
  }
  
  public void rewritePlayerFile(){
    String[] lines = new String[0];
    for(Map.Entry<String, Integer> score : mScores.entrySet()){
      lines = append(lines, score.getKey() + ";" + score.getValue());
    }
    saveStrings(PLAYER_PATH + mPlayerName + ".txt", lines);
  }

  public Time getTimeAtLevel(String levelName){
    if(mScores.get(levelName) == null){
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
abstract class Screen {
  public void drawScreen(){}
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
  
  public final void setLaunchScreen() {
    this.mCurrentScreen = new LaunchScreen(this, mData, mTextures);
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
public class TextureDeleguate{
  private final PFont mFont;

  private final PImage mRightSelector;
  private final PImage mLeftSelector;

  private final PImage mUpArrow;
  private final PImage mDownArrow;

  private final int mBackgroundColor;
  private final int mTextColor;
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

    mBackgroundColor = color(5, 5, 5);
    mTextColor = color(255);                                  // 255,211,56
    mTextShadowColor = color(255, 158, 147);                  // Pink
    mEmptyCellColor = color(237, 28, 36);                     // Red
    mWorkingCellColor = color(255);
    mSelectorCellColor = color(5, 255, 71);
    mLineColor = color(18, 43, 255);
    mLineDotColor = color(43, 65, 255);
    // Color palette : #FF050D #FFD338 #FF1F26 #05FF47 #122BFF
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
  
  public void reset(){
    
  }
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
// Y'a un soucis quand y'a un nouvel utilisateur pour charger le temps du joueur
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
