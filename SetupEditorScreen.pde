
public class SetupEditorScreen extends Screen implements ClickListener{
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
    mBackButton.addListener(this);
    mCreateButton.addListener(this);
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
    text("Niveau : " + mCurrentlevel.getname(), width/2, 100.);
    textFont(mTextures.mFont, 18);
    text("Dessinez le niveau", width/2, 150.);
  }
  
  public void onClick(Button src){
    if(src == mBackButton){
      // Le bouton Retour est cliqué, on affiche le menu
      mScreenDeleguate.setMenuScreen();
    } else if(src == mCreateButton){
      // Le bouton créer est cliqué, on créé le niveau et on lance la page de création
      mEditordrawer.saveLevel();
      mData.mLevels.add(mCurrentlevel);
      mScreenDeleguate.setMenuScreen();
    }
    mBackButton.removeListener(this);
    mCreateButton.removeListener(this);
  }

  public void mouseClicked(){
    mBackButton.isClick();
    mCreateButton.isClick();
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
