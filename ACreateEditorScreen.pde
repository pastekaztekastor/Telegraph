
public class CreateEditorScreen extends Screen{
  private ScreenDeleguate   mScreenDeleguate;
  private DataDeleguate     mData;
  private TextureDeleguate  mTextures;
  
  private TextField   mWidthTextField;
  private TextField   mheightTextField;
  private TextButton  mBackButton;
  private TextButton  mCreateButton;

  CreateEditorScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate  = screenDeleguate;
    mData             = dataDeleguate;
    mTextures         = textures;
    mBackButton       = new TextButton(width/2 - 150, height - 50, "retour", 36);
    mCreateButton     = new TextButton(width/2 + 150, height - 50, "créer", 36);
    mWidthTextField   = new TextField(width/2 - 100, height/2 - 60, 200, 50, 2);
    mheightTextField  = new TextField(width/2 - 100, height/2 + 10, 200, 50, 2);
    mWidthTextField.setFilter(TextField.ONLY_NUMBERS);
    mheightTextField.setFilter(TextField.ONLY_NUMBERS);
    mWidthTextField.setActive(true);
    mouseMoved();
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    textFont(mTextures.mFont, 36);
    mWidthTextField.drawTextField();
    mheightTextField.drawTextField();
    mBackButton.drawButton();
    mCreateButton.drawButton();
  }
  
  public void mouseClicked(){
    mWidthTextField.isClick();
    mheightTextField.isClick();
    if(mBackButton.isMouseOnIt()){
      mScreenDeleguate.setMenuScreen();
    } else if(mCreateButton.isMouseOnIt()){
      
    }
  }
  
  public void keyPressed(){
    mWidthTextField.aKeyWasPressed(key); 
    mheightTextField.aKeyWasPressed(key); 
  }
  
  public void mouseMoved(){
    if(!mWidthTextField.isMouseOnIt() 
        && !mheightTextField.isMouseOnIt() 
        && !mBackButton.isMouseOnIt() 
        && !mCreateButton.isMouseOnIt()){
      cursor(ARROW);
    }
  }
  
  public void sizeChanged(){
    mWidthTextField.setPosition(width/2 - 100, height/2 - 60);
    mheightTextField.setPosition(width/2 - 100, height/2);
  }
}
