import java.util.ArrayList;

public class Level{
  private final static String LEVEL_PATH = "/levels/";
  String mLevelName;
  int[][] mLevelMatrix;

  public Level(String name){
    String[] file = loadStrings(LEVEL_PATH + name + ".txt");
    mLevelMatrix = new int[file.length][split(file[0],' ').length];

    for(int i = 0; i < file.length; i++){
      String[] line = split(file[i],' ');
      for(int j = 0; j < line.length; j++){
        mLevelMatrix[i][j] = Integer.parseInt(line[j]);
      }
    }
    mLevelName = name;
  }

  public Level(int width, int height, String name){
    mLevelName = name;
    mLevelMatrix = new int[height][width];
    for(int i = 0 ; i < height; i++){
      for(int j = 0; j < width; j++){
        mLevelMatrix[i][j] = 1;
      }
    }
  }

  public void generateLevelFile(int[][] mPathMatrix){
    mLevelMatrix = mPathMatrix;
    String[] lines = new String[mPathMatrix.length];
    for(int i = 0 ; i < mPathMatrix.length; i++){
      lines[i] = "";
      for(int j = 0; j < mPathMatrix[i].length; j++){
        lines[i] += String.valueOf(mPathMatrix[i][j]);
        if(j != mPathMatrix[i].length - 1){
          lines[i] += ' ';
        }
      }
    }
    saveStrings(LEVEL_PATH + mLevelName + ".txt", lines);
  }

  public int getWidth(){
    return mLevelMatrix[0].length;
  }

  public int getHeight(){
    return mLevelMatrix.length;
  }

  public String getname(){
    return mLevelName;
  }
  
  public int getValueAt(int x, int y){
    return mLevelMatrix[y][x];
  }
}
