
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
    mTextures.drawTitle();
    drawLevels();
    drawBackbutton();
  }

  void drawLevels(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("niveau", width/2 - gap, height/2 - 150);
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

  void drawBackbutton(){
    String word = "retour";
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text(word, width/2, height - 50);
    if(mOnBackButton){
      image(mTextures.mLeftSelector, width/2 - (int)textWidth(word) / 2 - 30 - second()%2*10, height - 48);
    }
  }

  int isHoveringMenuId(){
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

  void keyPressed(){
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

  void mouseClicked(){
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

  void mouseMoved(){
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
