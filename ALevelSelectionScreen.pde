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
  private TextButton[]    mLevelButtons;

  public LevelSelectionScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate    = screenDeleguate;
    mData               = data;
    mTextures           = textures;
    mSelectedLevel      = 0;
    mStartingDrawLevel  = 0;
    mUpButton           = new ImageButton(width/2 - 150, height/2 - 98, mTextures.mUpArrow);
    mDownButton         = new ImageButton(width/2 - 150, height/2 + 202, mTextures.mDownArrow);
    mBackButton         = new TextButton(width/2, height - 50, "retour", 36, mTextures.mLeftSelector);
    mLevelButtons = new TextButton[5];
    for(int i = 0; i < mLevelButtons.length; i++){
      mLevelButtons[i] = new TextButton(width/2 - 150, height/2 - 50 + i * 50, "bb", 36, mTextures.mLeftSelector);
      mLevelButtons[i].addListener(this);
    }
    
    mUpButton.setMode(ImageButton.UP);
    mDownButton.setMode(ImageButton.DOWN);
    actualiseButtons();
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
    mUpButton.removeListener(this);
    mDownButton.removeListener(this);
    for(Button btn : mLevelButtons){
      btn.removeListener(this);
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
      // Affichage du temps
      String levelName = mData.mLevels.get(mStartingDrawLevel + i).mLevelName;
      if(mData.getCurrentplayer().getTimeAtLevel(levelName).toInteger() != -1){
        text(mData.getCurrentplayer().getTimeAtLevel(levelName).toStringFormat(2), width/2 + gap, height/2 - 50 + i * 50);
      } else {
        text("###", width/2 + gap, height/2 - 50 + i * 50);
      }
    }
  }

  void mouseClicked(){
    mBackButton.isClick();
    mUpButton.isClick();
    mDownButton.isClick();
    for(Button btn : mLevelButtons){
      btn.isClick(); 
    }
    mouseMoved();
  }

  void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    // Si la souris n'est sur aucun, je met le curseur par défaut
    if(mBackButton.isMouseOnIt()) return; 
    else if(mUpButton.isMouseOnIt()) return; 
    else if(mDownButton.isMouseOnIt()) return; 
    for(Button btn : mLevelButtons){
      if(btn.isMouseOnIt()) return; 
    }
    cursor(ARROW);
  }
  
  void sizeChanged(){
    
  }
}
