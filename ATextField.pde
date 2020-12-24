
public class TextField{
  public static final int ONLY_NUMBERS = 1;
  public static final int ONLY_CHARACTERS = 2;
  public static final int NUMBERS_AND_CHARACTERS = 3;
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
  
  public void aKeyWasPressed(char character){
    if(!mState){
      return;
    } else {
      if (character == ENTER){
        mState = false;
      } else if(character == BACKSPACE){
        mContent = mContent.substring(0, mContent.length() - 1);
      } else if(Character.isLetterOrDigit(character)){
        if(mFilter == NUMBERS_AND_CHARACTERS){
          mContent += character;
        } else if(mFilter == ONLY_NUMBERS && Character.isDigit(character)){
          mContent += character;
        } else {
          mContent += character;
        }
      }
    }
  }
  
  public void setActive(boolean state){
    mState = state;
  }
  
  public void setFilter(int filterType){
    if(filterType >= 1 && filterType <= 3){
      
    } else {
      throw new Error(filterType + "n'est pas un filtre compatible au TextField"); 
    }
  }
  
  public String getText(){
    return mContent;
  }
}
