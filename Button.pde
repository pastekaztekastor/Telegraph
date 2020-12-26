import javax.swing.event.EventListenerList;

abstract interface ClickListener extends EventListener{
  void onClick(Button src);
}

abstract class Button{
  // La position est au centre de l'objet
  protected PVector   mPosition;
  protected float     mWidth;
  protected float     mHeight;
  protected boolean   mIsHovered;
  protected boolean   mIsVisible;

  protected final EventListenerList listeners = new EventListenerList();

  protected Button(float x, float y, float width, float height){
    mPosition   = new PVector(x, y);
    mWidth      = width;
    mHeight     = height;
    mIsHovered  = false;
    mIsVisible  = true;
  }

  abstract void draw();
  
  public void drawButton(){
    if(mIsVisible){
      draw(); 
    }
  }
  
  public void setHitBowWidth(int value){ 
    mWidth = value;
  }
  
  public void setVisibility(boolean value){
    mIsVisible = value; 
  }
  
  public void addListener(ClickListener listener){
    listeners.add(ClickListener.class, listener);
  }
  
  // Supprime le listener mis en paramètre
  public void removeListener(ClickListener listener){
    listeners.remove(ClickListener.class, listener);
  }
  
  // il y a eu un click, vérifier si la souris est sur le bouton, et prévenir les listeners
  public void isClick(){
    if(isMouseOnIt()){
      fireButtonClicked(this);
    }
  }
  
  // Renvoie tout les listeners de type ClickListener
  protected ClickListener[] getClickListeners() {
    return listeners.getListeners(ClickListener.class);
  }
  
  // J'alerte tout mes listeners que le bouton a été cliqué
  protected void fireButtonClicked(Button src){
    for(ClickListener listener : getClickListeners()){
      listener.onClick(src);
    }
  }

  public void setPosition(float x, float y){
    mPosition.x = x;
    mPosition.y = y;
  }

  public boolean isMouseOnIt(){
    if(mIsVisible && isMouseBetweenPos(mPosition.x - mWidth/2, mPosition.x + mWidth/2, mPosition.y - mHeight/2, mPosition.y + mHeight/2)){
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
  public static final int NONE = 0;
  public static final int UP = 1;
  public static final int DOWN = 2;
  public static final int LEFT = 3;
  public static final int RIGHT = 4;
  
  private PImage mImage;
  private int    mMode;

  public ImageButton(float x, float y, PImage image){
    super(x, y, image.width + 20, image.height + 20);
    mImage = image;
    mMode  = NONE;
  }
  
  public void setMode(int mode){
    mMode = mode; 
  }

  public void draw(){
    imageMode(CENTER);
    if(mMode == NONE) image(mImage, mPosition.x, mPosition.y);
    else if(mMode == UP) image(mImage, mPosition.x, mPosition.y - second()%2*10);
    else if(mMode == DOWN) image(mImage, mPosition.x, mPosition.y + second()%2*10);
    else if(mMode == LEFT) image(mImage, mPosition.x - second()%2*10, mPosition.y);
    else if(mMode == RIGHT) image(mImage, mPosition.x + second()%2*10, mPosition.y);
  }
}


public class TextButton extends Button{
  private String mText;
  private int    mFontSize;
  private PImage mLeftArrow;
  private PImage mRightArrow;

  // Le bouton est nu, sans décoration lors du survol
  public TextButton(float x, float y, String text, int fontSize){
    this(x, y, text, fontSize, null, null);
  }

  // Si le bouton est survolé, une flèche apparaitra à gauche
  public TextButton(float x, float y, String text, int fontSize, PImage leftArrow){
    this(x, y, text, fontSize, leftArrow, null);
  }

  // Si le bouton est survolé, une flèche apparaitra à gauche et a droite
  public TextButton(float x, float y, String text, int fontSize, PImage leftArrow, PImage rightArrow){
    super(x, y, 0, fontSize);
    textSize(fontSize);
    mWidth      = textWidth(text);
    mText       = text;
    mFontSize   = fontSize;
    mLeftArrow  = leftArrow;
    mRightArrow = rightArrow;
  }

  public void draw(){
    textSize(mFontSize);
    textAlign(CENTER, CENTER);
    text(mText, mPosition.x, mPosition.y);
    if(mIsHovered){
      if(mLeftArrow != null){
        imageMode(CENTER);
        image(mLeftArrow, mPosition.x - mWidth/2 - mLeftArrow.width - second()%2*10, mPosition.y + 5);
      }
      if(mRightArrow != null){
        imageMode(CENTER);
        image(mRightArrow, mPosition.x + mWidth/2 + mLeftArrow.width + second()%2*10, mPosition.y + 5);
      }
    }
  }
}
