
public class CreateEditorScreen extends Screen{
  private final ScreenDeleguate   mScreenDeleguate;
  private final DataDeleguate     mData;
  private final TextureDeleguate  mTextures;
  
  private TextField   mWidthTextField;
  private TextField   mHeightTextField;
  private TextField   mNameTextField;
  private TextButton  mBackButton;
  private TextButton  mCreateButton;
  private String      mErrorMessage;

  CreateEditorScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate  = screenDeleguate;
    mData             = dataDeleguate;
    mTextures         = textures;
    mErrorMessage     = "";
    mBackButton       = new TextButton(width/2 - 150, height - 50, "Retour", 36, mTextures.mLeftSelector);
    mCreateButton     = new TextButton(width/2 + 150, height - 50, "Créer", 36, mTextures.mLeftSelector);
    mWidthTextField   = new TextField(width/2 - 100, height/2 - 60, 200, 50, 2);
    mHeightTextField  = new TextField(width/2 - 100, height/2 + 10, 200, 50, 2);
    mNameTextField    = new TextField(width/2 - 100, height/2 + 80, 200, 50, 10);
    mWidthTextField.setFilter(TextField.ONLY_NUMBERS);
    mHeightTextField.setFilter(TextField.ONLY_NUMBERS);
    mNameTextField.setFilter(TextField.NUMBERS_AND_CHARACTERS);
    mWidthTextField.setActive(true);
    mouseMoved();
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    textFont(mTextures.mFont, 36);
    mWidthTextField.drawTextField();
    mHeightTextField.drawTextField();
    mNameTextField.drawTextField();
    mBackButton.drawButton();
    mCreateButton.drawButton();
    drawErrorMessage();
  }
  
  private void drawErrorMessage(){
    fill(mTextures.mErrorColor);
    textAlign(CENTER, CENTER);
    textFont(mTextures.mFont, 18);
    text(mErrorMessage, width/2, height - 100); 
  }
  
  public void mouseClicked(){
    mWidthTextField.isClick();
    mHeightTextField.isClick();
    mNameTextField.isClick();
    if(mBackButton.isMouseOnIt()){
      // Le bouton Retour est cliqué, on affiche le menu
      mScreenDeleguate.setMenuScreen();
    } else if(mCreateButton.isMouseOnIt()){
      // Le bouton créer est cliqué, on créé le niveau et on lance la page de création
      // Il faut vérifier que le nom choisis n'existe pas déja
      int levelWidth  = Integer.parseInt(mWidthTextField.getText());
      int levelHeight = Integer.parseInt(mHeightTextField.getText());
      if(levelWidth < 2 || levelWidth > 25 || levelHeight < 2 || levelHeight > 25){
        mErrorMessage = "La taille du niveau doit etre entre 2 et 25";
        return;
      }
      for(Level level : mData.mLevels){
        if(level.getname().toLowerCase().equals(mNameTextField.getText().toLowerCase())){
          // Le nom choisis existe déja, afficher un message d'erreur;
          mErrorMessage = "Le nom choisis existe déja";
          return;
        }
      }
      Level level = new Level(levelWidth, levelHeight, mNameTextField.getText());
      mScreenDeleguate.setSetupEditorScreen(level);
    }
  }
  
  public void keyPressed(){
    // Une touche est préssée, je préviens les champs de texte
    mWidthTextField.aKeyWasPressed(key); 
    mHeightTextField.aKeyWasPressed(key); 
    mNameTextField.aKeyWasPressed(key);
  }
  
  public void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    if(!mWidthTextField.isMouseOnIt() 
        && !mHeightTextField.isMouseOnIt()
        && !mNameTextField.isMouseOnIt()
        && !mBackButton.isMouseOnIt() 
        && !mCreateButton.isMouseOnIt()){
      cursor(ARROW);
    }
  }
  
  public void sizeChanged(){
    // La taille de la fenetre change, je recalcule les positions des boutons et champs de texte
    mWidthTextField.setPosition(width/2 - 100, height/2 - 60);
    mHeightTextField.setPosition(width/2 - 100, height/2);
    mNameTextField.setPosition(width/2 - 100, height/2 + 80);
    mBackButton.setPosition(width/2 - 150, height - 50);
    mCreateButton.setPosition(width/2 + 150, height - 50);
  }
}
