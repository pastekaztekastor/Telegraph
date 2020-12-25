import java.util.ArrayList;

public class Level{
  String mLevelName;
  int[][] mLevelMatrix;

  public Level(File filePath){
    String[] file = loadStrings("/levels/" + filePath.getName());
    String name = split(filePath.getName(), '.')[0];

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
        mLevelMatrix[i][j] = 0;
      }
    }
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
