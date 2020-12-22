public class TextureDeleguate{
  private final PFont mFont;

  private final PImage mRightSelector;
  private final PImage mLeftSelector;

  private final PImage mUpArrow;
  private final PImage mDownArrow;

  private final color mBackgroundColor;
  private final color mTextColor;
  private final color mTextShadowColor;
  private final color mEmptyCellColor;
  private final color mWorkingCellColor;
  private final color mSelectorCellColor;
  private final color mLineColor;
  private final color mLineDotColor;

  public TextureDeleguate(){
    mFont = createFont("SuperLegendBoy.ttf", 32);

    mRightSelector = loadImage("data/selecteur_droit.png");
    mLeftSelector = loadImage("data/selecteur_gauche.png");

    mUpArrow = loadImage("data/up_arrow.png");
    mDownArrow = loadImage("data/down_arrow.png");

    mBackgroundColor = color(5, 5, 5);
    mTextColor = color(255);                                  // 255,211,56
    mTextShadowColor = color(255, 158, 147);                  // Pink
    mEmptyCellColor = color(237, 28, 36);                     // Red
    mWorkingCellColor = color(255);
    mSelectorCellColor = color(5, 255, 71);
    mLineColor = color(18, 43, 255);
    mLineDotColor = color(43, 65, 255);
    // Color palette : #FF050D #FFD338 #FF1F26 #05FF47 #122BFF
  }
  
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

  public void drawEmptyTile(float xPos, float yPos, float tileSize) {
    float tilePad = tileSize / 8.0;
    rectMode(CORNER);
    fill(mEmptyCellColor);
    rect(xPos, yPos, tileSize, tileSize);
    fill(mBackgroundColor);
    rect(xPos + tilePad, yPos + tilePad, tilePad * 6, tilePad * 6);
  }

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

  
