import java.util.ArrayList;

class DataDeleguate{
  public Player mCurrentPlayer;
  public ArrayList<Level> mLevels;
  public ArrayList<Player> mPlayers;

  public DataDeleguate(){
    loadLevels();
    loadPlayers();
  }

  // Charge tout les fichiers du dossier Levels et les mets dans l'ArrayList mLevels
  public void loadLevels(){
    mLevels = new ArrayList<Level>();
    File[] files = listFiles(Level.LEVEL_PATH);
    for(int i = 0; i < files.length; i++){
      Level level = new Level(split(files[i].getName(), '.')[0]);
      mLevels.add(level);
    }
  }

  // Charge tout les joueurs du dossier Players et les mets dans l'ArrayList mPlayers
  public void loadPlayers(){
    mPlayers = new ArrayList<Player>();
    File[] files = listFiles(Player.PLAYER_PATH);
    for(int i = 0; i < files.length; i++){
      Player player = new Player(split(files[i].getName(), '.')[0]);
      mPlayers.add(player);
    }
  }

  // Renvoie les niveaux
  public ArrayList<Level> getLevels(){
    return mLevels;
  }

  // Renvoie une arrayList contenant tout les joueurs ayant joué le niveau mis en paramètre
  ArrayList<Player> getPlayersOfLevel(int levelId){
    ArrayList<Player> list = new ArrayList<Player>();
    for(Player player : mPlayers){
      if(player.getTimeAtLevel(mLevels.get(levelId).getname()).toInteger() >= 0){
        println(player.getTimeAtLevel(mLevels.get(levelId).getname()).toInteger());
        // Le joueur a déja joué sur le niveau recherché, l'ajouter au tableau
        list.add(player);
      }
    }
    return list;
  }

  // Défini le joueur courant
  public void setCurrentPlayerTo(String name){
    // Vérifie si le joeur existe déja
    for(Player player : mPlayers){
      if(player.mPlayerName.equals(name)){
        // Le joueur existe déja, on le récupère
        mCurrentPlayer = player;
        return;
      }
    }
    // Le joueur n'existe pas, alors il faut le créer
    mCurrentPlayer = new Player(name);
    mPlayers.add(mCurrentPlayer);
  }

  // renvoie l'instance du joueur courant
  public Player getCurrentplayer(){
    if(this.mCurrentPlayer == null){
      throw new Error("Aucun joueur courant");
    }
    return this.mCurrentPlayer;
  }
}
