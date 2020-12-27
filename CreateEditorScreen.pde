
public class CreateEditorScreen extends Screen implements ClickListener{
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
    mWidthTextField   = new TextField(width/2 - 100, height/2 - 105, 200, 50, 2);
    mHeightTextField  = new TextField(width/2 - 100, height/2 + 25, 200, 50, 2);
    mNameTextField    = new TextField(width/2 - 170, height/2 + 155, 340, 50, 8);
    
    // J'enregistre l'objet courant comme écouteur
    mBackButton.addListener(this);
    mCreateButton.addListener(this);
    
    // Je paramètre les champs de texte
    mWidthTextField.setFilter(TextField.ONLY_NUMBERS);
    mHeightTextField.setFilter(TextField.ONLY_NUMBERS);
    mNameTextField.setFilter(TextField.NUMBERS_AND_CHARACTERS);
    mWidthTextField.setActive(true);
    
    // J'actualise le curseur
    mouseMoved();
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawBody();
    drawErrorMessage();
  }
  
  private void drawBody(){
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    text("Largeur du niveau", width/2, height/2 - 130);
    mWidthTextField.drawTextField();
    text("hauteur du niveau", width/2, height/2);
    mHeightTextField.drawTextField();
    text("Nom du niveau", width/2, height/2 + 130);
    mNameTextField.drawTextField();
    mBackButton.drawButton();
    mCreateButton.drawButton();
  }
  
  private void drawErrorMessage(){
    fill(mTextures.mErrorColor);
    textAlign(CENTER, CENTER);
    textFont(mTextures.mFont, 18);
    text(mErrorMessage, width/2, height - 100); 
  }
  
  public void onClick(Button src){
    if(src == mBackButton){
      // Le bouton Retour est cliqué, on affiche le menu
      mScreenDeleguate.setMenuScreen();
    } else if(src == mCreateButton){
      // Le bouton créer est cliqué, on créé le niveau et on lance la page de création
      // Il faut vérifier que le nom choisis n'existe pas déja
      if(mWidthTextField.getText().length() == 0 || mHeightTextField.getText().length() == 0 || mNameTextField.getText().length() == 0){
        mErrorMessage = "Tu dois remplir tout les champs";
        return;
      }
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
    // La page est changée, j'enlève les listeners
    mBackButton.removeListener(this);
    mCreateButton.removeListener(this);
  }
  
  public void mouseClicked(){
    mWidthTextField.isClick();
    mHeightTextField.isClick();
    mNameTextField.isClick();
    mCreateButton.isClick();
    mBackButton.isClick();
  }
  
  public void keyPressed(){
    // Une touche est préssée, je préviens les champs de texte
    mWidthTextField.aKeyWasPressed(key); 
    mHeightTextField.aKeyWasPressed(key); 
    mNameTextField.aKeyWasPressed(key);
  }
  
  public void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    // Si la souris n'est sur aucun, je met le curseur par défaut
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
    mWidthTextField.setPosition(width/2 - 100, height/2 - 105);
    mHeightTextField.setPosition(width/2 - 100, height/2 + 25);
    mNameTextField.setPosition(width/2 - 170, height/2 + 155);
    mBackButton.setPosition(width/2 - 150, height - 50);
    mCreateButton.setPosition(width/2 + 150, height - 50);
  }
}
