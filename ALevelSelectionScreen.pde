import java.util.ArrayList;

public class LevelSelectionScreen extends Screen implements ClickListener{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private int mSelectedLevel;
  private int mStartingDrawLevel;
  
  private ImageButton mUpButton;
  private ImageButton mDownButton;
  private TextButton  mBackButton;

  public LevelSelectionScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate    = screenDeleguate;
    mData               = data;
    mTextures           = textures;
    mSelectedLevel      = 0;
    mStartingDrawLevel  = 0;
    mUpButton           = new ImageButton(width/2 - 150, height/2 - 98, mTextures.mUpArrow);
    mDownButton         = new ImageButton(width/2 - 150, height/2 + 202, mTextures.mDownArrow);
    mBackButton         = new TextButton(width/2, height - 50, "retour", 36, mTextures.mLeftSelector);
    
    mUpButton.setMode(ImageButton.UP);
    mDownButton.setMode(ImageButton.DOWN);
    actualiseButtonVisibility();
    mUpButton.addListener(this);
    mDownButton.addListener(this);
    mBackButton.addListener(this);
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
  }
  
  private void actualiseButtonVisibility(){
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
  }
  
  public void onClick(Button src){
    if(src == mUpButton){
      mStartingDrawLevel --;
      actualiseButtonVisibility();
    } else if(src == mDownButton){
      mStartingDrawLevel ++;
      actualiseButtonVisibility();
    } else if(src == mBackButton){
      mUpButton.removeListener(this);
      mDownButton.removeListener(this);
      mBackButton.removeListener(this);
      mScreenDeleguate.setMenuScreen();
    }
  }

  void drawLevels(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("niveau", width/2 - gap, height/2 - 150);
    text("meilleur", width/2 + gap, height/2 - 200);
    text("score", width/2 + gap, height/2 - 150);
    
    
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

      // affichage de la flèche de sélection du niveau
      if(levelId == mSelectedLevel){
        int gap2 = (int)textWidth(levelName) / 2 + 30 + second()%2*10;
        imageMode(CENTER);
        image(mTextures.mLeftSelector, width/2 - gap - gap2, height/2 - 48 + i * 50);
      }
    }
  }

  int isHoveringMenuId(){
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

  void mouseClicked(){
    mBackButton.isClick();
    mUpButton.isClick();
    mDownButton.isClick();
    int id = isHoveringMenuId();
    if(id >= 0){
      mSelectedLevel = id;
      mScreenDeleguate.setOnGameScreen(mData.mLevels.get(id));
    }
    mouseMoved();
  }

  void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    // Si la souris n'est sur aucun, je met le curseur par défaut
    if(mBackButton.isMouseOnIt()) return; 
    else if(mUpButton.isMouseOnIt()) return; 
    else if(mDownButton.isMouseOnIt()) return; 
    int id = isHoveringMenuId();
    if(id >= 0){
      mSelectedLevel = id;
      cursor(HAND);
      return;
    } else {
      mSelectedLevel = -1;
    }
    cursor(ARROW);
  }
}
