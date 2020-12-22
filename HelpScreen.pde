
public class HelpScreen extends Screen {
  private ScreenDeleguate     mScreenDeleguate;
  private DataDeleguate       mData;
  private TextureDeleguate    mTextures;

  private boolean             mOnBackButton;

  private String[]            mAdaptedText;
  private String[]            mMainText = { "Chaque niveau comporte une grille remplie de stations télégraphiques.",
                                            "Suite à la dernière éruption du Piton de la Fournaise-Niels, certaines sont déconnectées.",
                                            "Pour les reconnecter, tu disposes d'un fil.",
                                            "Clique sur une station pour le commencer et déplace ta souris en maintenant le clic pour le continuer.",
                                            "Le passage d'un fil change l'état de la station.",
                                            "Mais attention, si un fil passe sur une station déjà connectée, cela brouille son signal et la station se déconnecte." };

  HelpScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures) {
    mScreenDeleguate   = screenDeleguate;
    mData              = dataDeleguate;
    mTextures          = textures;
    mAdaptedText       = new String[0];
    sizeChanged();
  }

  public void drawScreen() {
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawBody();
    drawBackbutton();
  }

  private void drawBody() {
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Aide générale", width/2, 200);

    textFont(mTextures.mFont, 18);
    textAlign(LEFT, CENTER);
    text("Station connectée", width/2 + 10, 240 + 48/2);
    text("Station déconnectée", width/2 + 10, 240 + 48 / 2 + 48/8 + 48);
    mTextures.drawEmptyTile(width/2 - 55, 240, 48);
    mTextures.drawTelegraphTile(width/2 - 55, 240 + 48 + 48/8, 48);

    textAlign(CENTER, CENTER);
    for(int i = 0; i < mAdaptedText.length; i++){
      text(mAdaptedText[i], width/2, 370 + i * 30);
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

  private final String[] adaptToWidth(String[] linesToAdapt, int textSize, int maxWidth){
    textSize(textSize);
    String[] newTable = new String[0];
    for(int i = 0; i < linesToAdapt.length; i++){
      String[] words = split(linesToAdapt[i], ' ');
      for(int j = 0; j < words.length; j++){
        String str = words[j];;
        for(int k = j+1; k < words.length; k++){
          if(textWidth(str + ' ' + words[k]) > maxWidth){
            break;
          } else {
            str += ' ' + words[k];
          }
          j = k;
        }
        newTable = append(newTable, str);
      }
    }
    return newTable;
  }

  private boolean isOnBackButton(){
     return mouseX > width / 2 - 100
      && mouseX < width / 2 + 100
      && mouseY > height - 70
      && mouseY < height - 30;
  }

  void sizeChanged(){
    mAdaptedText = adaptToWidth(mMainText, 18, width - 50);
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
