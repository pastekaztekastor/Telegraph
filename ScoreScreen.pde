import java.util.*;

public class ScoreScreen extends Screen{
  private ScreenDeleguate     mScreenDeleguate;
  private DataDeleguate       mData;
  private TextureDeleguate    mTextures;
  
  private boolean             mOnBackButton;
  
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
  
  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawScores();
    drawBackbutton();
  }
  
  void drawScores(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Tableau des scores", width/2, 200);
    text("Joueur", width/2 - gap, height/2 - 150);
    text("Score", width/2 + gap, height/2 - 150);

    // Affichage des fleches haut et bas
    tint(255, 127);
    if(mCurrentFirstDisplayedPlayer > 0){
      image(mTextures.mUpArrow, width/2 - gap, height/2 - 98 + second()%2*10);
    }
    if(mCurrentFirstDisplayedPlayer + 5 < mPlayersToDisplay.size()){
      image(mTextures.mDownArrow, width/2 - gap, height/2 - 48 + 250 - second()%2*10);
    }
    tint(255, 255);

    for(int i = 0; i < 5 && mCurrentFirstDisplayedPlayer + i < mPlayersToDisplay.size(); i++){
      // Affichage du nom du joueur
      text(mPlayersToDisplay.get(i).getName(), width/2 - gap, height/2 - 50 + i * 50);

      // Affichage du temps
      text(mPlayersToDisplay.get(i).getTimeAtLevel(mCurrentDisplayedLevelName).toStringFormat(2), width/2 + gap, height/2 - 50 + i * 50);
    }
  }
  
  private void drawBackbutton(){
    String word = "retour";
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text(word, width/2, height - 50);
    if(mOnBackButton){
      image(mTextures.mLeftSelector, width/2 - (int)textWidth(word) / 2 - 30 - second()%2*10, height - 48);
    }
  }
  
  private boolean isOnBackButton(){
     return mouseX > width / 2 - 100
      && mouseX < width / 2 + 100
      && mouseY > height - 70
      && mouseY < height - 30;
  }
  
  private void refreshList(){
    mCurrentDisplayedLevelName = mData.mLevels.get(mCurrentDisplayedLevelID).mLevelName;
    mPlayersToDisplay = mData.getPlayersOfLevel(mCurrentDisplayedLevelID);
    sortListByBestPlayer();
  }
  
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
    if(isOnBackButton()){
      mScreenDeleguate.setMenuScreen();
    }
  }
  
  void mouseMoved(){
    mOnBackButton = isOnBackButton();
  }
}
