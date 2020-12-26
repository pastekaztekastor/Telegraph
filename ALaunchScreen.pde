
public class LaunchScreen extends Screen{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private String mCurrentName;

  LaunchScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    mCurrentName = "";
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawTiles();
    drawBody();
  }

  void drawTiles(){
    rectMode(CORNER);
    int tileSize = 56;
    int gap = tileSize / 8;
    mTextures.drawTelegraphTile(width/2 - tileSize - gap, height/4, tileSize);
    mTextures.drawEmptyTile(width/2 + gap, height/4, tileSize);
  }

  void drawBody(){
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Entre ton pseudo", width/2, height/2 - 64);
    String str = mCurrentName;
    if(second()%2 == 0){
      str+="|";
    }
    text(str, width/2, height/2);
    if(mCurrentName.length() > 0 && millis()/100%10 >= 5){
      text("[Appuie sur Entrée]", width/2, height/2 + 64);
    }
  }

  void keyPressed(){
    if (key == ENTER && mCurrentName.length() > 0){
      mData.setCurrentPlayerTo(mCurrentName);
      mScreenDeleguate.setMenuScreen();
    } else if(key == BACKSPACE && mCurrentName.length() > 0){
      mCurrentName = mCurrentName.substring(0, mCurrentName.length() - 1);
    } else if(Character.isLetterOrDigit(key)){
      mCurrentName += key;
    }
  }
}
