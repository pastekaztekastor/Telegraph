
public class HelpScreen extends Screen implements ClickListener{
  private ScreenDeleguate     mScreenDeleguate;
  private DataDeleguate       mData;
  private TextureDeleguate    mTextures;

  private TextButton          mBackButton;

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
    mBackButton        = new TextButton(width/2, height - 50, "retour", 36, mTextures.mLeftSelector);
    mBackButton.addListener(this);
    sizeChanged();
  }

  // Affiche l'écran
  public void drawScreen() {
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawBody();
    mBackButton.drawButton();
    mouseMoved();
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

  // Adapte le texte à la largeur mise en paramètre
  private final String[] adaptToWidth(String[] linesToAdapt, int textSize, int maxWidth){
    textSize(textSize);
    String[] newTable = new String[0];
    for(int i = 0; i < linesToAdapt.length; i++){
      // coupe tout les mots de la ligne dans un nouveau tableau
      String[] words = split(linesToAdapt[i], ' ');
      for(int j = 0; j < words.length; j++){
        // Essaye d'ajouter les mots un par un et compare la taille totale avec la largeur définie
        String str = words[j];
        for(int k = j+1; k < words.length; k++){
          if(textWidth(str + ' ' + words[k]) > maxWidth){
            // Si la taille totale dépasse la largeur, changer de ligne
            break;
          } else {
            str += ' ' + words[k];
          }
          j = k;
        }
        // Ajoute la ligne au tableau contenant toutes les lignes
        newTable = append(newTable, str);
      }
    }
    return newTable;
  }

  // Méthode appelée si un bouton que l'instance écoute est appuyé
  public void onClick(Button src){
    if(src == mBackButton) mScreenDeleguate.setMenuScreen();
    // Supprime l'instance des écouteurs
    mBackButton.removeListener(this);
  }

  public void mouseClicked(){
    // Prévient le bouton qu'un click a été effectué
    mBackButton.isClick();
  }

  public void mouseMoved(){
    // La souris bouge, je préviens mes boutons et mes champs de texte
    // Si la souris n'est sur aucun, je met le curseur par défaut
    if(!mBackButton.isMouseOnIt()){
      cursor(ARROW);
    }
  }

  public void sizeChanged(){
    // Redéfini la position des boutons et la largeur du texte
    mAdaptedText = adaptToWidth(mMainText, 18, width - 50);
    mBackButton.setPosition(width/2, height - 50);
  }
}
