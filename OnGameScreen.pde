
public class OnGameScreen extends Screen{
  private final ScreenDeleguate mScreenDeleguate;
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

  //private Position mCurrentTileHoverPosition;

  OnGameScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures, Level level){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    mCurrentlevel = level;
    mCurrentPlayerPath = new Position[0];
    mPathTable = new int[level.getHeight()][level.getWidth()];
    updatePathTable();
    setSize();
    mTimer = new Timer();
  }

  void drawScreen(){
    background(mTextures.mBackgroundColor);
    drawHeader();
    drawLevel();
    drawPath();
    drawFooter();
  }

  private void drawHeader(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Temps", width/2, 50);
    text("Actuel", width/2 - gap, 100);
    text(mTimer.getTime().toStringFormat(2), width/2 - gap, 150);
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

  private void drawPath(){
    rectMode(CENTER);
    for(int i = 0; i < mCurrentPlayerPath.length; i++){
       float centerX1 = mStartingX + mTileSize / 4 + mTileSize / 4 + mCurrentPlayerPath[i].getX() * (mTileSize + mTileSize / 4);
       float centerY1 = mStartingY + mTileSize / 4 + mTileSize / 4 + mCurrentPlayerPath[i].getY() * (mTileSize + mTileSize / 4);
       if(i + 1 < mCurrentPlayerPath.length){
         float centerX2 = mStartingX + mTileSize / 4 + mTileSize / 4 + mCurrentPlayerPath[i + 1].getX() * (mTileSize + mTileSize / 4);
         float centerY2 = mStartingY + mTileSize / 4 + mTileSize / 4 + mCurrentPlayerPath[i + 1].getY() * (mTileSize + mTileSize / 4);
         fill(mTextures.mLineColor);
         if(mCurrentPlayerPath[i].getX() == mCurrentPlayerPath[i + 1].getX()){
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

  private void drawLevel(){
    Position tileHovered = getPositionOfTileHovered();
    if(tileHovered != null){
      drawSelectorTile(mStartingX + (mTileSize + mGap) * tileHovered.getX() - mGap / 2 , mStartingY + (mTileSize + mGap) * tileHovered.getY() - mGap / 2, mTileSize + mGap);
    }
    for(int i = 0; i < mCurrentlevel.getHeight(); i++){
      for(int j = 0; j < mCurrentlevel.getWidth(); j++){
        // soit un 0 soit un 1
        if(mCurrentlevel.mLevelMatrix[i][j] == 1){
          if(mPathTable[i][j] == 0){
            drawTelegraphTile(mStartingX + (mTileSize + mGap) * j, mStartingY + (mTileSize + mGap) * i, mTileSize);
          } else {
            drawEmptyTile(mStartingX + (mTileSize + mGap) * j, mStartingY + (mTileSize + mGap) * i, mTileSize);
          }
        } else {
          if(mPathTable[i][j] == 0){
            drawEmptyTile(mStartingX + (mTileSize + mGap) * j, mStartingY + (mTileSize + mGap) * i, mTileSize);
          } else {
            drawTelegraphTile(mStartingX + (mTileSize + mGap) * j, mStartingY + (mTileSize + mGap) * i, mTileSize);
          }
        }
      }
    }
  }

  private void drawTelegraphTile(float xPos, float yPos, float tileSize){
    float tilePad = tileSize / 8.0;
    rectMode(CORNER);
    fill(mTextures.mWorkingCellColor);
    rect(xPos, yPos, tileSize, tileSize);
    fill(mTextures.mBackgroundColor);
    rect(xPos + tilePad, yPos + tilePad, tilePad * 6, tilePad * 6);
    fill(mTextures.mWorkingCellColor);
    rect(xPos + tilePad * 3, yPos + tilePad * 3, tilePad * 2, tilePad * 2);
  }

  private void drawEmptyTile(float xPos, float yPos, float tileSize){
    float tilePad = tileSize / 8.0;
    rectMode(CORNER);
    fill(mTextures.mEmptyCellColor);
    rect(xPos, yPos, tileSize, tileSize);
    fill(mTextures.mBackgroundColor);
    rect(xPos + tilePad, yPos + tilePad, tilePad * 6, tilePad * 6);
  }

  private void drawSelectorTile(float xPos, float yPos, float tileSize){
    float tilePad = tileSize / 10.0;
    float cornerSize = tilePad*3 - second()%2*tilePad;
    float gap = tileSize / 2;
    rectMode(CORNER);
    fill(mTextures.mSelectorCellColor);
    rect(xPos, yPos, cornerSize, cornerSize);
    rect(xPos + tileSize-cornerSize, yPos, cornerSize, cornerSize);
    rect(xPos, yPos + tileSize-cornerSize, cornerSize, cornerSize);
    rect(xPos + tileSize-cornerSize, yPos + tileSize-cornerSize, cornerSize, cornerSize);
  }

  private boolean isPositionInTheLevel(Position pos){
    return pos.getX() >= 0
             && pos.getY() >= 0
             && pos.getX() < mCurrentlevel.getWidth()
             && pos.getY() < mCurrentlevel.getHeight();
  }

  private void updateLevelData(){
    updatePathTable();
    checkWin();
  }

  private void updatePathTable(){
    for(int i = 0; i < mPathTable.length; i++){
      for(int j = 0; j < mPathTable[i].length; j++){
        mPathTable[i][j] = 0;
      }
    }
    for(Position pos : mCurrentPlayerPath){
      if(mPathTable[pos.getY()][pos.getX()] == 0){
        mPathTable[pos.getY()][pos.getX()] = 1;
      } else {
        mPathTable[pos.getY()][pos.getX()] = 0;
      }
    }
  }

  private void checkWin(){
    for(int i = 0; i < mCurrentlevel.getHeight(); i++){
      for(int j = 0; j < mCurrentlevel.getWidth(); j++){
        if(mCurrentlevel.mLevelMatrix[i][j] - mPathTable[i][j] != 0){
          // Il reste au moins une case qui empèche de gagner, la fonction s'arrete
          return;
        }
      }
    }
    // Le joueur a gagné, on sauvegarde le temps
    mTimer.pause();
    mData.getCurrentplayer().setNewScore(mCurrentlevel,mTimer.getTime().toInteger());
    println(mTimer.getTime().toStringFormat(2));
    //screen.setMenuScreen();
  }

  private void addNewPointToPath(Position pos, boolean fromSingleTap, boolean tapHolded){
    // Il ne doit pas y avoir une seule case présente sur la grille, pour commencer la ligne il faut donc que
    // le joueur glisse sa souris en maintenant le click sur au moins deux cases.
    if(mCurrentPlayerPath.length == 0){
      if(tapHolded){
        mTimer.start();
        mCurrentPlayerPath = appendTablePosition(mCurrentPlayerPath, pos);
        updateLevelData();
        return;
      } else {
        return;
      }
    }
    // Si la position existe a la dernière case, alors ne rien faire
    if(mCurrentPlayerPath[mCurrentPlayerPath.length-1].equals(pos)){
      return;
    }
    // Si la position est a une case de la dernière et ne sort pas du tableau
    if(isPositionInTheLevel(pos) && mCurrentPlayerPath[mCurrentPlayerPath.length-1].isNextTo(pos)){
      // Le joueur peut juste vouloir revenir d'une case en arrière
      if(mCurrentPlayerPath.length > 1 && mCurrentPlayerPath[mCurrentPlayerPath.length-2].equals(pos)){
        // Alors enlever une case
        mCurrentPlayerPath = setNewSizeToTable(mCurrentPlayerPath, mCurrentPlayerPath.length-1);
        updateLevelData();
        return;
      }
      // Vérifier si la case n'existe pas déja et alors vérifier si la case peut se faire ou non
      for(int i = 0; i < mCurrentPlayerPath.length; i++){
        if(i == 0 && mCurrentPlayerPath[i].equals(pos) && !mCurrentPlayerPath[mCurrentPlayerPath.length - 1].canItCross(
                                                                       mCurrentPlayerPath[0]
                                                                       ,mCurrentPlayerPath[1])){
          // Le joueur a cliqué sur la case de départ, cas particulier, mais il ne peut pas la traverser
          if(fromSingleTap){
            // le joueur a juste fait un click et n'est pas en train de maintenir la souris cliquée, alors racourcir la ligne
            mCurrentPlayerPath = setNewSizeToTable(mCurrentPlayerPath, i+1);
            updateLevelData();
          }
          return;
        } else if(i != 0 && mCurrentPlayerPath[i].equals(pos) && !mCurrentPlayerPath[mCurrentPlayerPath.length - 1].canItCross(mCurrentPlayerPath[i - 1]
                                                                        ,mCurrentPlayerPath[i]
                                                                        ,mCurrentPlayerPath[i + 1])){
          // Le joueur a cliqué sur une case existante mais ne peut pas la traverser (cas des coins)
          if(fromSingleTap){
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
    for(int i = mCurrentPlayerPath.length - 1; i >= 0 ; i--){
      if(fromSingleTap && mCurrentPlayerPath[i].equals(pos)){
        mCurrentPlayerPath = setNewSizeToTable(mCurrentPlayerPath, i+1);
        updateLevelData();
      }
    }
  }

  private Position[] setNewSizeToTable(Position[] table, int newSize){
    Position[] newTable = new Position[newSize];
    for(int i = 0; i < newTable.length; i++){
      newTable[i] = table[i];
    }
    return newTable;
  }

  private Position[] appendTablePosition(Position[] table, Position element){
    Position[] newTable = new Position[table.length + 1];
    for(int i = 0; i < table.length; i++){
      newTable[i] = table[i];
    }
    newTable[table.length] = element;
    return newTable;
  }

  private Position getPositionOfTileHovered(){
    float x = (mouseX - mStartingX + mTileSize / 8) / (mTileSize + mTileSize / 4);
    float y = (mouseY - mStartingY + mTileSize / 8) / (mTileSize + mTileSize / 4);
    if((int)x > mCurrentlevel.getWidth()-1 || x < 0){
      return null;
    } else if((int)y > mCurrentlevel.getHeight()-1 || y < 0){
      return null;
    }
    return new Position((int)x, (int)y);
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

  void mouseReleased(){
    if(mCurrentPlayerPath.length == 1){
      mCurrentPlayerPath = setNewSizeToTable(mCurrentPlayerPath, 0);
      updateLevelData();
      mTimer.stop();
      return;
    }
  }

  void mouseDragged(){
    Position pos = getPositionOfTileHovered();
    if(pos != null){
      addNewPointToPath(pos, false, true);
    }
  }
  
  void mouseClicked(){
    if (isHoveringButtonID() != -1){
      // La souris est sur un bouton
      if(isHoveringButtonID() == 1){
        // Revenir a la selection des niveaux
        mScreenDeleguate.setLevelSelectionScreen();
      } else if(isHoveringButtonID() == 2){
        // Relancer la partie
        mTimer.stop();
        mCurrentPlayerPath = setNewSizeToTable(mCurrentPlayerPath, 0);
        updateLevelData(); 
      }
    }
  }

  void mousePressed(){
    Position pos = getPositionOfTileHovered();
    if(pos != null){
      addNewPointToPath(pos, true, true);
    }
  }

  void setSize(){
    float heightAvailable = height - 300;
    float widthAvailable = width;

    float tileSize1 = (int)( heightAvailable / ((float)mCurrentlevel.getHeight() + (float)mCurrentlevel.getHeight() / 4) ) ;
    tileSize1 = tileSize1 - tileSize1%8;

    float tileSize2 = (int)( widthAvailable / ((float)mCurrentlevel.getWidth() + (float)mCurrentlevel.getWidth() / 4) ) ;
    tileSize2 = tileSize2 - tileSize2%8;

    if(tileSize1 < tileSize2){
      mTileSize = tileSize1;
    } else {
      mTileSize = tileSize2;
    }

    mGap = mTileSize / 4;
    mStartingX = width / 2 - ( mCurrentlevel.getWidth() * (mTileSize + mGap) - mGap ) / 2;
    mStartingY = height / 2 + 50 - ( mCurrentlevel.getHeight() * (mTileSize + mGap) - mGap ) / 2;
  }

  void sizeChanged(){
    setSize();
  }
}
