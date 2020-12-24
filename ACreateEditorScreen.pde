
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
    drawBody();
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
      text("[Appui sur Entrée]", width/2, height/2 + 64);
    }
  }
}

public class TextField{
  public static final int ONLY_NUMBERS = 1;
  public static final int ONLY_CHARACTERS = 2;
  public static final int NUMBERS_AND_CHARACTERS = 1;
  int       mWidth;
  int       mHeight;
  int       mPosX;
  int       mPosY;
  String    mContent;
  boolean   mState;
  int       mFilter;
  
  public TextField(){
    mFilter = TextField.NUMBERS_AND_CHARACTERS;
  }
  
  public void aKeyWasPressed(){
    if(!mState){
      return;
    } else {
      if (key == ENTER){
        mState = false;
      } else if(key == BACKSPACE){
        mContent = mContent.substring(0, mContent.length() - 1);
      } else if(Character.isLetterOrDigit(key)){
        if(mFilter == NUMBERS_AND_CHARACTERS){
          mContent += key;
        } else if(mFilter == ONLY_NUMBERS && Character.isDigit(key)){
          mContent += key;
        } else {
          mContent += key;
        }
      }
    }
  }
  
  public void setActive(boolean state){
    mState = state;
  }
  
  public void setFilter(int filterType){
    
  }
  
  public String getText(){
    return mContent;
  }
}
