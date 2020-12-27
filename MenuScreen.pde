
public class MenuScreen extends Screen implements ClickListener{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private String[] menuContent = {"Jouer", "Scores", "Aide", "Editeur",  "Quitter"};
  private Button[] mButtons;

  public MenuScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
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

  private void drawMenu(){
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
