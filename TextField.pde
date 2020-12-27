public class TextField{
  public static final int ONLY_NUMBERS = 1;
  public static final int ONLY_CHARACTERS = 2;
  public static final int NUMBERS_AND_CHARACTERS = 3;
  public static final int OUTLINED = 1;
  public static final int BORDERLESS = 2;
  public static final int RIGHT_ALIGN = 1;
  public static final int CENTER_ALIGN = 2;
  public static final int LEFT_ALIGN = 3;

  private int       mPosX;
  private int       mPosY;
  private int       mWidth;
  private int       mHeight;
  private String    mContent;
  private boolean   mState;
  private int       mFilter;
  private int       mStyle;
  private int       mAlignment;
  private int       mDigitLimit;

  public TextField(int posX, int posY, int width, int height){
    this(posX, posY, width, height, 10);
  }

  public TextField(int posX, int posY, int width, int height, int digitLimit){
    mPosX         = posX;
    mPosY         = posY;
    mWidth        = width;
    mHeight       = height;
    mState        = false;
    mFilter       = NUMBERS_AND_CHARACTERS;
    mStyle        = OUTLINED;
    mAlignment    = CENTER_ALIGN;
    mDigitLimit   = digitLimit;
    mContent      = "";
  }

  public void drawTextField(){
    if(mStyle == OUTLINED){
      // Afficher les rebords de la zone de texte
      fill(0,0);
      strokeWeight(3);
      stroke(255);
      rectMode(CORNER);
      rect(mPosX, mPosY, mWidth, mHeight);
      noStroke();
    }

    fill(255);
    String str = mContent;
    if(second()%2 == 0 && mState){
      str+="|";
    }
    drawText(str);
  }

  private void drawText(String text){
    if(mAlignment == CENTER_ALIGN){
      textAlign(CENTER,CENTER);
      text(text, mPosX + mWidth / 2, mPosY + mHeight / 2);
    } else if(mAlignment == RIGHT_ALIGN){
      textAlign(RIGHT,CENTER);
      text(text, mPosX + mWidth / 2, mPosY + mHeight);
    } else if(mAlignment == LEFT_ALIGN){
      textAlign(LEFT,CENTER);
      text(text, mPosX + mWidth / 2, mPosY);
    }
  }

  // Change l'alignement du texte 
  public void setAlignment(int value){
    if(value >= 1 && value <= 3){
      mAlignment = value;
    } else {
      throw new Error(value + "n'est pas un alignement compatible au TextField");
    }
  }

  // Change le style du champs de texte
  public void setStyle(int value){
    if(value >= 1 && value <= 2){
      mStyle = value;
    } else {
      throw new Error(value + "n'est pas un style compatible au TextField");
    }
  }

  // Redéfinie la position du champs de texte
  public void setPosition(int x, int y){
    mPosX = x;
    mPosY = y;
  }

  // Vérifie si le caractère en paramètre est compatible avec le filtre et l'ajoute en fonction
  public void aKeyWasPressed(char character){
    if(!mState){
      return;
    } else {
      if (character == ENTER){
        //mState = false;
      } else if(character == BACKSPACE && mContent.length() > 0){
        mContent = mContent.substring(0, mContent.length() - 1);
      } else if(!(character == CODED) && mContent.length() < mDigitLimit){
        if(mFilter == NUMBERS_AND_CHARACTERS && character != BACKSPACE && character != '.'){
          mContent += character;
        } else if(mFilter == ONLY_NUMBERS && Character.isDigit(character)){
          mContent += character;
        } else if(mFilter == ONLY_CHARACTERS && Character.isLetter(character)){
          mContent += character;
        }
      }
    }
  }

  // Vérifie si la souris le survole 
  public boolean isMouseOnIt(){
    if(isMouseBetweenPos(mPosX, mPosX + mWidth, mPosY, mPosY + mHeight)){
      cursor(HAND);
      return true;
    } else {
      return false;
    }
  }

  // Renvoi true si la position de la souris est entre les valeurs
  private boolean isMouseBetweenPos(int startX, int endX, int startY, int endY){
    return mouseX > startX
      && mouseX < endX
      && mouseY > startY
      && mouseY < endY;
  }

  public void isClick(){
    if(isMouseOnIt()){
      setActive(true);
    } else {
      setActive(false);
    }
  }

  // Change l'état du champs de texte
  public void setActive(boolean state){
    mState = state;
  }

  // Change le filtre du champs de texte
  public void setFilter(int filterType){
    if(filterType >= 1 && filterType <= 3){
      mFilter = filterType;
    } else {
      throw new Error(filterType + "n'est pas un filtre compatible au TextField");
    }
  }

  // Renvoie le texte écris
  public String getText(){
    return mContent;
  }
}
