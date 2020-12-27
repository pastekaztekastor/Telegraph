
public class LaunchScreen extends Screen implements ClickListener{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private final TextField mNameTextField;
  private final TextButton mNextButton;

  LaunchScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    mNameTextField = new TextField(width/2 - 170, height/2 - 25, 340, 50, 8);
    mNextButton = new TextButton(width/2, height - 50, "Maxime Maria", 36);
    mNextButton.addListener(this);
    mNextButton.setVisibility(false);
    mNameTextField.setActive(true);
    mNameTextField.setStyle(TextField.BORDERLESS);
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawTiles();
    drawBody();
    mNameTextField.drawTextField();
    mNextButton.drawButton();
  }

  public void onClick(Button src){
    if(src == mNextButton){
      mData.setCurrentPlayerTo(mNameTextField.getText());
      mScreenDeleguate.setMenuScreen();
      mNextButton.removeListener(this);
    }
  }

  private void drawTiles(){
    rectMode(CORNER);
    int tileSize = 56;
    int gap = tileSize / 8;
    mTextures.drawTelegraphTile(width/2 - tileSize - gap, height/4, tileSize);
    mTextures.drawEmptyTile(width/2 + gap, height/4, tileSize);
  }

  private void drawBody(){
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Entre ton pseudo", width/2, height/2 - 64);
    if(mNameTextField.getText().length() > 0 && millis()/100%10 >= 5){
      text("[Appuie sur Max !!]", width/2, height/2 + 64);
    }
  }

  public void sizeChanged(){
    mNameTextField.setPosition(width/2 - 170, height/2 - 25);
  }

  public void mouseMoved(){
    if(!mNextButton.isMouseOnIt()){
      cursor(ARROW);
    }
  }

  public void mouseClicked(){
    mNextButton.isClick();
  }

  public void keyPressed(){
    mNameTextField.aKeyWasPressed(key);
    if(mNameTextField.getText().length() > 0){
      mNextButton.setVisibility(true);
    } else {
      mNextButton.setVisibility(false);
    }
  }
}
