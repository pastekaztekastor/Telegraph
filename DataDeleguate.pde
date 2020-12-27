import java.util.ArrayList;

class DataDeleguate{
  public Player mCurrentPlayer;
  public ArrayList<Level> mLevels;
  public ArrayList<Player> mPlayers;

  public DataDeleguate(){
    loadLevels();
    loadPlayers();
  }

  public void loadLevels(){
    mLevels = new ArrayList<Level>();
    File[] files = listFiles("/levels");
    for(int i = 0; i < files.length; i++){
      Level level = new Level(files[i]);
      mLevels.add(level);
    }
  }

  public void loadPlayers(){
    mPlayers = new ArrayList<Player>();
    File[] files = listFiles("/players");
    for(int i = 0; i < files.length; i++){
      Player player = new Player(split(files[i].getName(), '.')[0]);
      mPlayers.add(player);
    }
  }

  public ArrayList<Level> getLevels(){
    return mLevels;
  }

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

  public void setCurrentPlayerTo(String name){
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

  public Player getCurrentplayer(){
    if(this.mCurrentPlayer == null){
      throw new Error("Aucun joueur courant");
    }
    return this.mCurrentPlayer;
  }
}
