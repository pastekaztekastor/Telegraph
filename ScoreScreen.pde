import java.util.*;

public class ScoreScreen extends Screen implements ClickListener{
  private ScreenDeleguate     mScreenDeleguate;
  private DataDeleguate       mData;
  private TextureDeleguate    mTextures;

  private int                 mCurrentDisplayedLevelID;
  private ArrayList<Player>   mPlayersToDisplay;
  private String              mCurrentDisplayedLevelName;
  private int                 mCurrentFirstDisplayedPlayer;

  private ImageButton mUpButton;
  private ImageButton mDownButton;
  private ImageButton mLeftButton;
  private ImageButton mRightButton;
  private TextButton  mBackButton;


  public ScoreScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures) {
    mScreenDeleguate             = screenDeleguate;
    mData                        = dataDeleguate;
    mTextures                    = textures;
    mCurrentDisplayedLevelID     = 0;
    mCurrentFirstDisplayedPlayer = 0;

    mBackButton = new TextButton(width/2, height - 50, "Retour", 36, mTextures.mLeftSelector);
    mUpButton = new ImageButton(width/2 , height/2 - 98, mTextures.mUpArrow);
    mDownButton = new ImageButton(width/2 , height/2 + 202, mTextures.mDownArrow);
    mLeftButton = new ImageButton(width/2 - 30 - textWidth("Niveau " + mCurrentDisplayedLevelName)/2, height/2 + 250, mTextures.mLeftArrow);
    mRightButton = new ImageButton(width/2 + 30 + textWidth("Niveau " + mCurrentDisplayedLevelName)/2, height/2 + 250, mTextures.mRightArrow);

    mUpButton.addListener(this);
    mDownButton.addListener(this);
    mLeftButton.addListener(this);
    mRightButton.addListener(this);
    mBackButton.addListener(this);

    mUpButton.setMode(ImageButton.UP);
    mDownButton.setMode(ImageButton.DOWN);
    mLeftButton.setMode(ImageButton.LEFT);
    mRightButton.setMode(ImageButton.RIGHT);
    refreshList();
    updateButtons();
  }

  public void onClick(Button src){
    if(src == mUpButton){
      mCurrentFirstDisplayedPlayer--;
    } else if(src == mDownButton){
      mCurrentFirstDisplayedPlayer++;
    } else if(src == mLeftButton){
      mCurrentDisplayedLevelID--;
      mCurrentFirstDisplayedPlayer = 0;
      refreshList();
    } else if(src == mRightButton){
      mCurrentDisplayedLevelID++;
      mCurrentFirstDisplayedPlayer = 0;
      refreshList();
    } else if(src == mBackButton){
      mBackButton.removeListener(this);
      mUpButton.removeListener(this);
      mDownButton.removeListener(this);
      mLeftButton.removeListener(this);
      mRightButton.removeListener(this);
      mScreenDeleguate.setMenuScreen();
    }
    updateButtons();
    updateButtonsPosition();
    refreshList();
  }

  // Change la visibilité des boutons en fonction de ce qui est affiché
  private void updateButtons(){
    if(mCurrentFirstDisplayedPlayer > 0){
      mUpButton.setVisibility(true);
    } else {
      mUpButton.setVisibility(false);
    }
    if(mCurrentFirstDisplayedPlayer + 5 < mPlayersToDisplay.size()){
      mDownButton.setVisibility(true);
    } else {
      mDownButton.setVisibility(false);
    }
    if(mCurrentDisplayedLevelID > 0 ){
      mLeftButton.setVisibility(true);
    } else {
      mLeftButton.setVisibility(false);
    }
    if(mCurrentDisplayedLevelID < mData.mLevels.size() - 1 ){
      mRightButton.setVisibility(true);
    } else {
      mRightButton.setVisibility(false);
    }
  }

  // Affiche l'écran complet
  public void drawScreen(){
    mouseMoved();
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawScores();
    mUpButton.drawButton();
    mDownButton.drawButton();
    mLeftButton.drawButton();
    mRightButton.drawButton();
    mBackButton.drawButton();
  }

  // Affiche le corps de la page (les scores et les flèches)
  private void drawScores(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    imageMode(CENTER);
    fill(mTextures.mTextColor);
    text("Tableau des scores", width/2, 200);
    text("Joueur", width/2 - gap, height/2 - 150);
    text("Score", width/2 + gap, height/2 - 150);
    for(int i = 0; i < 5 && mCurrentFirstDisplayedPlayer + i < mPlayersToDisplay.size(); i++){
      // Affichage du nom du joueur
      textAlign(LEFT, CENTER);
      text((mCurrentFirstDisplayedPlayer + i + 1)+ " " + mPlayersToDisplay.get(i).getName(), width/2 - gap - 140, height/2 - 50 + i * 50);
      // Affichage du temps
      textAlign(CENTER, CENTER);
      text(mPlayersToDisplay.get(mCurrentFirstDisplayedPlayer + i).getTimeAtLevel(mCurrentDisplayedLevelName).toStringFormat(2), width/2 + gap, height/2 - 50 + i * 50);
    }
    // Affichage du nom du niveau courrant
    textAlign(CENTER, CENTER);
    text("Niveau " + mCurrentDisplayedLevelName, width/2, height/2 + 250);
  }

  // Actualise les variables qui me permettent l'affichage de la page
  private void refreshList(){
    mCurrentDisplayedLevelName = mData.mLevels.get(mCurrentDisplayedLevelID).mLevelName;
    mPlayersToDisplay = mData.getPlayersOfLevel(mCurrentDisplayedLevelID);
    sortListByBestPlayer();
  }

  // Tri la liste de mes joueurs en fonction de leur temps sur le niveau affiché
  private void sortListByBestPlayer(){
    for(int i = 0; i < mPlayersToDisplay.size(); i++){
      for(int j = i; j < mPlayersToDisplay.size(); j++){
        if(mPlayersToDisplay.get(j).getTimeAtLevel(mCurrentDisplayedLevelName).toInteger() < mPlayersToDisplay.get(i).getTimeAtLevel(mCurrentDisplayedLevelName).toInteger()){
          Collections.swap(mPlayersToDisplay, i, j);
        }
      }
    }
  }

  public void mouseClicked(){
    mUpButton.isClick();
    mDownButton.isClick();
    mLeftButton.isClick();
    mRightButton.isClick();
    mBackButton.isClick();
  }

  public void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    // Si la souris n'est sur aucun, je met le curseur par défaut
    if(!mUpButton.isMouseOnIt()
        && !mDownButton.isMouseOnIt()
        && !mLeftButton.isMouseOnIt()
        && !mRightButton.isMouseOnIt()
        && !mBackButton.isMouseOnIt()){
      cursor(ARROW);
    }
  }
  
  private void updateButtonsPosition(){
    mBackButton.setPosition(width/2, height - 50);
    mUpButton.setPosition(width/2 , height/2 - 98);
    mDownButton.setPosition(width/2 , height/2 + 202);
    mLeftButton.setPosition(width/2 - 30 - textWidth("Niveau " + mCurrentDisplayedLevelName)/2, height/2 + 250);
    mRightButton.setPosition(width/2 + 30 + textWidth("Niveau " + mCurrentDisplayedLevelName)/2, height/2 + 250);
  }

  public void sizeChanged(){
    updateButtonsPosition();
  }
}
