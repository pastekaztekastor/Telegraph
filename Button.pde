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

  // Liste des listeners
  protected final     EventListenerList mListeners;

  protected Button(float x, float y, float width, float height){
    mListeners   = new EventListenerList();
    mPosition   = new PVector(x, y);
    mWidth      = width;
    mHeight     = height;
    mIsHovered  = false;
    mIsVisible  = true;
  }

  protected abstract void draw();

  public void drawButton(){
    if(mIsVisible){
      draw();
    }
  }

  // Change la visibilité du bouton
  public void setVisibility(boolean value){
    mIsVisible = value;
  }

  // Ajoute l'objet en paramètre comme écouteur des évènements du bouton
  public void addListener(ClickListener listener){
    mListeners.add(ClickListener.class, listener);
  }

  // Supprime le listener mis en paramètre
  public void removeListener(ClickListener listener){
    mListeners.remove(ClickListener.class, listener);
  }

  // il y a eu un click, vérifier si la souris est sur le bouton, et prévenir les listeners
  public void isClick(){
    if(isMouseOnIt()){
      fireButtonClicked(this);
    }
  }

  // Renvoie tout les listeners de type ClickListener
  protected ClickListener[] getClickListeners() {
    return mListeners.getListeners(ClickListener.class);
  }

  // J'alerte tout mes listeners que le bouton a été cliqué
  protected void fireButtonClicked(Button src){
    for(ClickListener listener : getClickListeners()){
      listener.onClick(src);
    }
  }

  // Change la position du bouton
  public void setPosition(float x, float y){
    mPosition.x = x;
    mPosition.y = y;
  }

  // Renvoie vrai si la souris est sur sa "hitbox"
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
  public static final int NONE   = 0;
  public static final int UP     = 1;
  public static final int DOWN   = 2;
  public static final int LEFT   = 3;
  public static final int RIGHT  = 4;

  private PImage mImage;
  private int    mMode;

  public ImageButton(float x, float y, PImage image){
    super(x, y, image.width + 20, image.height + 20);
    mImage = image;
    mMode  = NONE;
  }

  // Définit le mode d'animation du bouton
  public void setMode(int mode){
    mMode = mode;
  }

  // Dessine le bouton
  protected void draw(){
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
  private PImage mLeftSelector;
  private PImage mRightSelector;

  // Le bouton est nu, sans décoration lors du survol
  public TextButton(float x, float y, String text, int fontSize){
    this(x, y, text, fontSize, null, null);
  }

  // Si le bouton est survolé, une flèche apparaitra à gauche
  public TextButton(float x, float y, String text, int fontSize, PImage leftSelector){
    this(x, y, text, fontSize, leftSelector, null);
  }

  // Si le bouton est survolé, une flèche apparaitra à gauche et a droite
  public TextButton(float x, float y, String text, int fontSize, PImage leftSelector, PImage rightSelector){
    super(x, y, 0, fontSize);
    textSize(fontSize);
    mWidth      = textWidth(text);
    mText       = text;
    mFontSize   = fontSize;
    mLeftSelector  = leftSelector;
    mRightSelector = rightSelector;
  }

  // Change le texte du bouton
  public void setText(String text){
    textSize(mFontSize);
    mWidth      = textWidth(text);
    mText = text;
  }

  // Dessine le bouton
  protected void draw(){
    textSize(mFontSize);
    textAlign(CENTER, CENTER);
    text(mText, mPosition.x, mPosition.y);
    if(mIsHovered){
      if(mLeftSelector != null){
        imageMode(CENTER);
        image(mLeftSelector, mPosition.x - mWidth/2 - mLeftSelector.width - second()%2*10, mPosition.y + 5);
      }
      if(mRightSelector != null){
        imageMode(CENTER);
        image(mRightSelector, mPosition.x + mWidth/2 + mRightSelector.width + second()%2*10, mPosition.y + 5);
      }
    }
  }
}
