import java.util.*;

public class ScoreScreen extends Screen{
  private ScreenDeleguate     mScreenDeleguate;
  private DataDeleguate       mData;
  private TextureDeleguate    mTextures;
  
  private int                 mOnButtonID;
  
  private int                 mCurrentDisplayedLevelID;
  private ArrayList<Player>   mPlayersToDisplay;
  private String              mCurrentDisplayedLevelName;
  private int                 mCurrentFirstDisplayedPlayer;
  
  public ScoreScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures) {
    mScreenDeleguate             = screenDeleguate;
    mData                        = dataDeleguate;
    mTextures                    = textures;
    mCurrentDisplayedLevelID     = 0;
    mCurrentFirstDisplayedPlayer = 0;
    refreshList();
  }
  
  // Affiche l'écran complet
  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawScores();
    drawBackbutton();
  }
  
  // Affiche le corps de la page (les scores et les flèches)
  void drawScores(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    imageMode(CENTER);
    fill(mTextures.mTextColor);
    text("Tableau des scores", width/2, 200);
    text("Joueur", width/2 - gap, height/2 - 150);
    text("Score", width/2 + gap, height/2 - 150);

    // Affichage des fleches haut et bas
    tint(255, 127);
    if(mCurrentFirstDisplayedPlayer > 0){
      image(mTextures.mUpArrow, width/2, height/2 - 98 + second()%2*10);
    }
    if(mCurrentFirstDisplayedPlayer + 5 < mPlayersToDisplay.size()){
      image(mTextures.mDownArrow, width/2, height/2 - 48 + 250 - second()%2*10);
    }
    tint(255, 255);

    for(int i = 0; i < 5 && mCurrentFirstDisplayedPlayer + i < mPlayersToDisplay.size(); i++){
      // Affichage du temps
      textAlign(CENTER, CENTER);
      text(mPlayersToDisplay.get(i).getTimeAtLevel(mCurrentDisplayedLevelName).toStringFormat(2), width/2 + gap, height/2 - 50 + i * 50);
      
      // Affichage du nom du joueur
      textAlign(LEFT, CENTER);
      text((mCurrentFirstDisplayedPlayer + i + 1)+ " " + mPlayersToDisplay.get(i).getName(), width/2 - gap - 140, height/2 - 50 + i * 50);
    }
    
    // Affichage du nom du niveau courrant
    textAlign(CENTER, CENTER);
    text("Niveau " + mCurrentDisplayedLevelName, width/2, height/2 + 250);
    
    // Affichage des fleches gauche et droite
    tint(255, 127);
    if(mCurrentDisplayedLevelID > 0){
      image(mTextures.mLeftArrow, width/2 - textWidth("Niveau " + mCurrentDisplayedLevelName)/2 - 20 - second()%2*10, height/2 + 250 );
    }
    if(mCurrentDisplayedLevelID < mData.mLevels.size() - 1){
      image(mTextures.mRightArrow, width/2 + textWidth("Niveau " + mCurrentDisplayedLevelName)/2 + 20 + second()%2*10, height/2 + 250 );
    }
    tint(255, 255);
    
  }
  
  // Affiche le bouton retour
  private void drawBackbutton(){
    String word = "retour";
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text(word, width/2, height - 50);
    if(mOnButtonID == 5){
      image(mTextures.mLeftSelector, width/2 - (int)textWidth(word) / 2 - 30 - second()%2*10, height - 48);
    }
  }
  
  // Renvoi un ID différent de -1 si la souris est sur un bouton (flèche ou bouton retour)
  private int isOnButton(){
    if(mCurrentFirstDisplayedPlayer > 0 
                && isMouseBetweenPos(width / 2 - 20, width / 2 + 20, height/2 - 120, height/2 - 80)){
      // La souris est sur la flèche du haut
      return 1;
    } else if(mCurrentFirstDisplayedPlayer + 5 != mPlayersToDisplay.size()
                && isMouseBetweenPos(width / 2 - 20, width / 2 + 20, height/2 + 180, height/2 + 220)){
      // La souris est sur la flèche du bas
      return 2;
    } else if(mCurrentDisplayedLevelID > 0 
                && isMouseBetweenPos(0, width/2 - 10, height/2 + 230, height/2 + 270)){
      // La souris est sur la flèche de gauche
      return 3;
    } else if(mCurrentDisplayedLevelID < mData.mLevels.size() - 1 
                && isMouseBetweenPos(width/2 + 10, width, height/2 + 230, height/2 + 270)){
      // La souris est sur la flèche de droite
      return 4;
    } else if(isMouseBetweenPos(width / 2 - 100, width / 2 + 100, height - 70, height - 30)){
      // La souris est sur le bouton retour
      return 5;
    }
    return -1; 
  }
  
  // Renvoi true si la position de la souris est entre les valeurs
  private boolean isMouseBetweenPos(int startX, int endX, int startY, int endY){
    return mouseX > startX
      && mouseX < endX
      && mouseY > startY
      && mouseY < endY;
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

  void mouseClicked(){
    switch(isOnButton()){
      case 1 :
        // Click sur la flèche up
        mCurrentFirstDisplayedPlayer--;
        mouseMoved();
        break;
      case 2 :
        // Click sur la flèche down
        mCurrentFirstDisplayedPlayer++;
        mouseMoved();
        break;
      case 3 :
        // Click sur la flèche left
        mCurrentDisplayedLevelID--;
        mCurrentFirstDisplayedPlayer = 0;
        refreshList();
        mouseMoved();
        break;
      case 4 :
        // Click sur la flèche right
        mCurrentDisplayedLevelID++;
        mCurrentFirstDisplayedPlayer = 0;
        refreshList();
        mouseMoved();
        break;
      case 5 :
        // Click sur le bouton retour
        mScreenDeleguate.setMenuScreen();
        break;
    }
  }
  
  void mouseMoved(){
    int id = isOnButton();
    if(id != -1){
      // Afficher curseur de sélection
      cursor(HAND);
    } else {
      // Afficher curseur basique
      cursor(ARROW);
    }
    mOnButtonID = isOnButton();
  }
}
