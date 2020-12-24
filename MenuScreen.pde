
public class MenuScreen extends Screen{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private int mSelectedMenu;
  private String[] menuContent = {"Jouer", "Scores", "Aide", "Editeur", "Crédits", "Quitter"};

  MenuScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    mSelectedMenu = 0;
    mouseMoved();
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    mTextures.drawTitle();
    drawMenu(menuContent, mSelectedMenu);
  }

  void drawMenu(String[] menuContent, int selectedMenu){
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    for(int i = 0; i < menuContent.length; i++){
      text(menuContent[i], width/2, height/2 - 100 + i * 50);
      if(i == selectedMenu){
        int gap = (int)textWidth(menuContent[i]) / 2 + 30 + second()%2*10;
        imageMode(CENTER);
        image(mTextures.mLeftSelector, width/2 - gap, height/2 - 95 + i * 50);
        image(mTextures.mRightSelector, width/2 + gap, height/2 - 95 + i * 50);
      }
    }
  }

  void keyPressed(){
    if (key == CODED) {
      if (keyCode == UP && mSelectedMenu > 0) {
        mSelectedMenu--;
      } else if (keyCode == DOWN && mSelectedMenu < menuContent.length -1) {
        mSelectedMenu++;
      }
    }
    if (key == ENTER){
      changeScreen();
    }
  }

  void changeScreen(){
    switch(mSelectedMenu){
      case 0 :
        // Jouer
        mScreenDeleguate.setLevelSelectionScreen();
        break;
      case 1 :
        // Score board
        mScreenDeleguate.setScoreScreen();
        break;
      case 2 :
        // Help
        mScreenDeleguate.setHelpScreen();
        break;
      case 3 :
        // Editor
        println("Editor");
        break;
      case 4 :
        // Credits
        println("Credits");
        break;
      case 5 :
        // Credits
        mScreenDeleguate.setLaunchScreen();
        println("Quitter");
    }
  }

  int isHoveringMenuItemId(){
    for(int i = 0; i < menuContent.length; i++){
      if(mouseX > width / 2 - 200
        && mouseX < width / 2 + 200
        && mouseY > height/2 - 120 + i * 50
        && mouseY < height/2 - 80 + i * 50){
          return i;
      }
    }
    return -1;
  }

  void mouseClicked(){
    if(isHoveringMenuItemId() != -1){
      mSelectedMenu = isHoveringMenuItemId();
      changeScreen();
    }
  }

  void mouseMoved(){
    if(isHoveringMenuItemId() != -1){
      mSelectedMenu = isHoveringMenuItemId();
      // Afficher curseur de sélection
      cursor(HAND);
    } else {
      // Afficher curseur basique
      cursor(ARROW);
    }
  }
}
