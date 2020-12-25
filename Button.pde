abstract class Button{
  // La position est au centre de l'objet
  protected PVector   mPosition;
  protected float     mWidth;
  protected float     mHeight;
  protected boolean   mIsHovered;
  
  protected Button(float x, float y, float width, float height){
    mPosition   = new PVector(x, y);
    mWidth      = width;
    mHeight     = height;
    mIsHovered  = false;
  }
  
  abstract void drawButton();
  
  
  public boolean isMouseOnIt(){
    if(isMouseBetweenPos(mPosition.x - mWidth/2, mPosition.x + mWidth/2, mPosition.y - mHeight/2, mPosition.y + mHeight/2)){
      cursor(HAND);
      mIsHovered = true;
      return true;
    } else {
      mIsHovered = false;
      return false;
    }
  }
  
  // Renvoi true si la position de la souris est entre les valeurs
  private boolean isMouseBetweenPos(float startX, float endX, float startY, float endY){
    return mouseX > startX
      && mouseX < endX
      && mouseY > startY
      && mouseY < endY;
  }
}


public class ImageButton extends Button{
  private PImage mImage;
  
  public ImageButton(float x, float y, PImage image){
    super(x, y, image.width, image.height);
    mImage = image;
  }
  
  public void drawButton(){
    
    if(mIsHovered){
      
    }
  }
}


public class TextButton extends Button{
  private String mText;
  private int    mFontSize;

  public TextButton(float x, float y, String text, int fontSize){
    super(x, y, 0, fontSize);
    textSize(fontSize);
    mWidth    = textWidth(text);
    mText     = text;
    mFontSize = fontSize;
  }

  public void drawButton(){
    textSize(mFontSize);
    textAlign(CENTER, CENTER);
    text(mText, mPosition.x, mPosition.y);
    if(mIsHovered){
      
    }
  }
}
