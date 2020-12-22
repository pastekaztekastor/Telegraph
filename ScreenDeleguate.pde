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
