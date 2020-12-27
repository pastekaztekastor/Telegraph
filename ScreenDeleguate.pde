class ScreenDeleguate {
  private Screen mCurrentScreen;
  private final DataDeleguate mData;
  private final TextureDeleguate mTextures;

  public ScreenDeleguate(DataDeleguate data, TextureDeleguate textures) {
    this.mData = data;
    this.mTextures = textures;
  }

  // Apelle la méthode drawScreen() de l'écran courant
  public final void drawScreen() {
    this.mCurrentScreen.drawScreen();
  }

  // Apelle la méthode sizeChanged() de l'écran courant
  public void sizeChanged(){
    this.mCurrentScreen.sizeChanged();
  }

  // Apelle la méthode keyPressed() de l'écran courant
  public void aKeyWasPressed(){
    this.mCurrentScreen.keyPressed();
  }

  // Apelle la méthode mouseClicked() de l'écran courant
  public void mouseIsClicked(){
    this.mCurrentScreen.mouseClicked();
  }

  // Apelle la méthode mouseDragged() de l'écran courant
  public void mouseIsDragged(){
    this.mCurrentScreen.mouseDragged();
  }

  // Apelle la méthode mouseMoved() de l'écran courant
  public void mouseIsMoved(){
    this.mCurrentScreen.mouseMoved();
  }

  // Apelle la méthode mousePressed() de l'écran courant
  public void mouseIsPressed(){
    this.mCurrentScreen.mousePressed();
  }

  // Apelle la méthode drawScreen() de l'écran courant
  public void mouseIsReleased(){
    this.mCurrentScreen.mouseReleased();
  }

  // Définie l'écran courant comme une nouvelle instance de HelpScreen
  public final void setHelpScreen(){
    this.mCurrentScreen = new HelpScreen(this, mData, mTextures);
  }

  // Définie l'écran courant comme une nouvelle instance de SetupEditorScreen
  public final void setSetupEditorScreen(Level level){
    this.mCurrentScreen = new SetupEditorScreen(this, mData, mTextures, level);
  }

  // Définie l'écran courant comme une nouvelle instance de CreateEditorScreen
  public final void setCreateEditorScreen(){
    this.mCurrentScreen = new CreateEditorScreen(this, mData, mTextures);
  }

  // Définie l'écran courant comme une nouvelle instance de LaunchScreen
  public final void setLaunchScreen() {
    this.mCurrentScreen = new LaunchScreen(this, mData, mTextures);
  }

  // Définie l'écran courant comme une nouvelle instance de ScoreScreen
  public final void setScoreScreen(){
    this.mCurrentScreen = new ScoreScreen(this, mData, mTextures);
  }

  // Définie l'écran courant comme une nouvelle instance de MenuScreen
  public final void setMenuScreen() {
    this.mCurrentScreen = new MenuScreen(this, mData, mTextures);
  }

  // Définie l'écran courant comme une nouvelle instance de LevelSelectionScreen
  public final void setLevelSelectionScreen(){
    this.mCurrentScreen = new LevelSelectionScreen(this, mData, mTextures);
  }

  // Définie l'écran courant comme une nouvelle instance de OnGameScreen
  public final void setOnGameScreen(Level level){
    this.mCurrentScreen = new OnGameScreen(this, mData, mTextures, level);
  }
}
