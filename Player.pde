import java.util.HashMap;

public class Player {
  private final static String PLAYER_PATH = "/players/";
  private final String mPlayerName;
  public HashMap<String, Integer> mScores = new HashMap<String, Integer>();

  public Player(String playerName) {
    mPlayerName = playerName;
    // Il faut vérifier si le joueur existe dans la base
    File[] files = listFiles(PLAYER_PATH);
    for (int i = 0; i < files.length; i++) {
      if (split(files[i].getName(), '.')[0].equals(playerName)) {
        // Le joueur a déja un fichier on récupère ses informations
        String[] file = loadStrings(PLAYER_PATH + playerName + ".txt");
        for (int j = 0; j < file.length; j++) {
          String[] line = split(file[j], ';');
          mScores.put(line[0], Integer.parseInt(line[1]));
        }
        return;
      }
    }
    // Le joueur n'existe pas dans la base, on lui créé un fichier 
    String[] lines = new String[0];
    saveStrings(PLAYER_PATH + playerName + ".txt", lines);
  }

  public String getName() {
    return mPlayerName;
  }

  public void setNewScore(Level level, int time) {
    // Changer la valeur dans la variable
    if (mScores.containsKey(level.getname())) {
      if (getTimeAtLevel(level.getname()).toInteger() > time) {
        // Le joueur viens de battre son score, alors le réécrire
        mScores.replace(level.getname(), time);
        rewritePlayerFile();
        return;
      } else {
        // Rien n'a changé alors ne rien faire
        return;
      }
    }
    // Changer la valeur dans le fichier
    mScores.put(level.getname(), time);
    rewritePlayerFile();
  }

  public void rewritePlayerFile() {
    String[] lines = new String[0];
    for (Map.Entry<String, Integer> score : mScores.entrySet()) {
      lines = append(lines, score.getKey() + ";" + score.getValue());
    }
    saveStrings(PLAYER_PATH + mPlayerName + ".txt", lines);
  }

  public Time getTimeAtLevel(String levelName) {
    if (mScores.get(levelName) == null) {
      return new Time(-1);
    } else {
      return new Time(mScores.get(levelName));
    }
  }
}
