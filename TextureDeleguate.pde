public class TextureDeleguate{
  public final PFont mFont;

  public final PImage mRightSelector;
  public final PImage mLeftSelector;

  public final PImage mUpArrow;
  public final PImage mDownArrow;
  public final PImage mLeftArrow;
  public final PImage mRightArrow;

  public final PImage mAward;

  public final color mBackgroundColor;
  public final color mTextColor;
  public final color mErrorColor;
  public final color mTextShadowColor;
  public final color mEmptyCellColor;
  public final color mWorkingCellColor;
  public final color mSelectorCellColor;
  public final color mLineColor;
  public final color mLineDotColor;

  public TextureDeleguate(){
    // Charge toutes les textures, polices d'écritures, et couleurs
    mFont = createFont("SuperLegendBoy.ttf", 32);

    mRightSelector = loadImage("data/selecteur_droit.png");
    mLeftSelector = loadImage("data/selecteur_gauche.png");

    mUpArrow = loadImage("data/up_arrow.png");
    mDownArrow = loadImage("data/down_arrow.png");
    mLeftArrow = loadImage("data/left_arrow.png");
    mRightArrow = loadImage("data/right_arrow.png");

    mAward = loadImage("data/award.png");

    mBackgroundColor = color(5, 5, 5);
    mTextColor = color(255);                                  // 255,211,56
    mErrorColor = color(237, 28, 36);
    mTextShadowColor = color(255, 158, 147);                  // Pink
    mEmptyCellColor = color(237, 28, 36);                     // Red
    mWorkingCellColor = color(255);
    mSelectorCellColor = color(5, 255, 71);
    mLineColor = color(18, 43, 255);
    mLineDotColor = color(43, 65, 255);
    // Color palette : #FF050D #FFD338 #FF1F26 #05FF47 #122BFF
  }

  // Affiche le titre du jeu
  public void drawTitle(){
    textFont(mFont, 64);
    textAlign(CENTER, CENTER);
    fill(mTextShadowColor);
    text("Telegraph", width/2+4, 84);
    fill(mTextColor);
    text("Telegraph", width/2, 80);
  }

  // Affiche une case bkanche avec un point au milieu sensé représenté une station déconnectée
  public void drawTelegraphTile(float xPos, float yPos, float tileSize) {
    float tilePad = tileSize / 8.0;
    rectMode(CORNER);
    fill(mWorkingCellColor);
    rect(xPos, yPos, tileSize, tileSize);
    fill(mBackgroundColor);
    rect(xPos + tilePad, yPos + tilePad, tilePad * 6, tilePad * 6);
    fill(mWorkingCellColor);
    rect(xPos + tilePad * 3, yPos + tilePad * 3, tilePad * 2, tilePad * 2);
  }

  // Affiche une case rouge sensé représenter une station connectée
  public void drawEmptyTile(float xPos, float yPos, float tileSize) {
    float tilePad = tileSize / 8.0;
    rectMode(CORNER);
    fill(mEmptyCellColor);
    rect(xPos, yPos, tileSize, tileSize);
    fill(mBackgroundColor);
    rect(xPos + tilePad, yPos + tilePad, tilePad * 6, tilePad * 6);
  }

  // Affiche le sélecteur de case vert
  public void drawSelectorTile(float xPos, float yPos, float tileSize) {
    float tilePad = tileSize / 10.0;
    float cornerSize = tilePad*3 - second()%2*tilePad;
    float gap = tileSize / 2;
    rectMode(CORNER);
    fill(mSelectorCellColor);
    rect(xPos, yPos, cornerSize, cornerSize);
    rect(xPos + tileSize-cornerSize, yPos, cornerSize, cornerSize);
    rect(xPos, yPos + tileSize-cornerSize, cornerSize, cornerSize);
    rect(xPos + tileSize-cornerSize, yPos + tileSize-cornerSize, cornerSize, cornerSize);
  }
}
