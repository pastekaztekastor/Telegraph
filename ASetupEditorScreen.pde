
public class SetupEditorScreen extends Screen{
  private final ScreenDeleguate   mScreenDeleguate;
  private final DataDeleguate     mData;
  private final TextureDeleguate  mTextures;
  
  private final Level mCurrentlevel;
  private final LevelDrawer mLeveldrawer;
  private TextButton  mBackButton;
  private TextButton  mCreateButton;
 
  public SetupEditorScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures, Level level){
    mScreenDeleguate  = screenDeleguate;
    mData             = dataDeleguate;
    mTextures         = textures;
    mCurrentlevel     = level;
    mLeveldrawer      = new LevelDrawer(dataDeleguate, textures, level);
    mBackButton       = new TextButton(width/2 - 150, height - 50, "Retour", 36, mTextures.mLeftSelector);
    mCreateButton     = new TextButton(width/2 + 150, height - 50, "Créer", 36, mTextures.mLeftSelector);
  }
  
  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mLeveldrawer.draw();
    fill(mTextures.mTextColor);
    mBackButton.drawButton();
    mCreateButton.drawButton();
  }
  
  public void mouseClicked(){
    if(mBackButton.isMouseOnIt()){
      // Le bouton Retour est cliqué, on affiche le menu
      mScreenDeleguate.setMenuScreen();
    } else if(mCreateButton.isMouseOnIt()){
      // Le bouton créer est cliqué, on créé le niveau et on lance la page de création
      
    }
  }

  void mouseReleased(){
    mLeveldrawer.mouseReleased();
  }

  void mouseDragged(){
    mLeveldrawer.mouseDragged();
  }
  
  void mousePressed(){
    mLeveldrawer.mousePressed();
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
    mLeveldrawer.setSize();
  }
}
