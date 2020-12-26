
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

  void drawScreen(){
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

  void mouseReleased(){
    mLeveldrawer.mouseReleased();
  }

  void mouseDragged(){
    mLeveldrawer.mouseDragged();
  }
  
  void mouseClicked(){
    mLeaveButton.isClick();
    mReloadButton.isClick();
  }
  
  void mouseMoved(){
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

  void mousePressed(){
    mLeveldrawer.mousePressed();
  }

  void sizeChanged(){
    mLeveldrawer.setSize();
    mLeaveButton.setPosition(width/2 - 150, height - 50);
    mLeaveButton.setPosition(width/2 + 150, height - 50);
  }
}
