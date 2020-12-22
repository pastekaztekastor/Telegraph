
public class MenuScreen extends Screen{
  private ScreenDeleguate mScreenDeleguate;
  private DataDeleguate mData;
  private TextureDeleguate mTextures;

  private int mSelectedMenu;
  private String[] menuContent = {"jouer", "Scores", "Aide", "Editeur", "Crédits"};

  MenuScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    mSelectedMenu = 0;
  }

  public void drawScreen(){
    background(mTextures.mBackgroundColor);
    drawTitle();
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

  void drawTitle(){
    textFont(mTextures.mFont, 64);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextShadowColor);
    text("Telegraph", width/2+4, 84);
    fill(mTextures.mTextColor);
    text("Telegraph", width/2, 80);
  }

  void keyPressed(){
    if (key == CODED) {
      if (keyCode == UP && mSelectedMenu >= 1) {
        mSelectedMenu--;
      } else if (keyCode == DOWN && mSelectedMenu <= 3) {
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
        println("Score board");
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
    }
  }
}
