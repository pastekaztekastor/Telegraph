
public class OnGameScreen extends Screen{
  private final ScreenDeleguate mScreenDeleguate;
  private final DataDeleguate mData;
  private final TextureDeleguate mTextures;
  
  private final LevelDrawer mLeveldrawer;
  private final Level mCurrentlevel;

  OnGameScreen(ScreenDeleguate screenDeleguate, DataDeleguate dataDeleguate, TextureDeleguate textures, Level level){
    mScreenDeleguate = screenDeleguate;
    mData = dataDeleguate;
    mTextures = textures;
    mCurrentlevel = level;
    mLeveldrawer = new LevelDrawer(dataDeleguate, textures, level);
  }

  void drawScreen(){
    background(mTextures.mBackgroundColor);
    drawHeader();
    mLeveldrawer.draw();
    drawFooter();
  }

  private void drawHeader(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Temps", width/2, 50);
    text("Actuel", width/2 - gap, 100);
    text(mLeveldrawer.getScore().toStringFormat(2), width/2 - gap, 150);
    text("Meilleur", width/2 + gap, 100);
    text(mData.getCurrentplayer().getTimeAtLevel(mCurrentlevel.getname()).toStringFormat(2), width/2 + gap, 150);
  }

  private void drawFooter(){
    int gap = 150;
    textFont(mTextures.mFont, 36);
    textAlign(CENTER, CENTER);
    fill(mTextures.mTextColor);
    text("Sortir", width/2 - gap, height - 50);
    text("Relancer", width/2 + gap, height - 50);
    if(isHoveringButtonID() == 1){
      int selectorGap = (int)textWidth("Sortir") / 2 + 30 + second()%2*10;
      imageMode(CENTER);
      image(mTextures.mLeftSelector, width/2 - gap - selectorGap, height - 48);
      image(mTextures.mRightSelector, width/2 - gap + selectorGap, height - 48);
    } else if (isHoveringButtonID() == 2){
      int selectorGap = (int)textWidth("Relancer") / 2 + 30 + second()%2*10;
      imageMode(CENTER);
      image(mTextures.mLeftSelector, width/2 + gap - selectorGap, height - 48);
      image(mTextures.mRightSelector, width/2 + gap + selectorGap, height - 48);
    }
  }

  private int isHoveringButtonID(){
    if(mouseY > height - 70 && mouseY < height - 30){
      if(mouseX > width/2 - 300 &&  mouseX < width/2){
        // la souris est sur le bouton retour
        return 1; 
      } else if( mouseX > width/2 && mouseX < width/2 + 300){
        // la souris est sur le bouton relancer
        return 2; 
      }
    }
    return -1;
  }

  void mouseReleased(){
    mLeveldrawer.mouseReleased();
  }

  void mouseDragged(){
    mLeveldrawer.mouseDragged();
  }
  
  void mouseClicked(){
    if (isHoveringButtonID() != -1){
      // La souris est sur un bouton
      if(isHoveringButtonID() == 1){
        // Revenir a la selection des niveaux
        mScreenDeleguate.setLevelSelectionScreen();
      } else if(isHoveringButtonID() == 2){
        // Relancer la partie
        mLeveldrawer.resetGame();
      }
    }
  }

  void mousePressed(){
    mLeveldrawer.mousePressed();
  }

  void sizeChanged(){
    mLeveldrawer.setSize();
  }
}
