import java.util.*;

class DataDeleguate{
  public Player mCurrentPlayer;
  public ArrayList<Level> mLevels;
  public ArrayList<Player> mPlayers;

  DataDeleguate(){
    loadLevels();
    loadPlayers();
  }

  void loadLevels(){
    mLevels = new ArrayList<Level>();
    File[] files = listFiles("/levels");
    for(int i = 0; i < files.length; i++){
      Level level = new Level(files[i]);
      mLevels.add(level);
    }
  }

  void loadPlayers(){
    mPlayers = new ArrayList<Player>();
    File[] files = listFiles("/players");
    for(int i = 0; i < files.length; i++){
      //println(split(files[i].getName(), '.')[0]);
      Player player = new Player(split(files[i].getName(), '.')[0]);
      mPlayers.add(player);
    }
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

  void setCurrentPlayerTo(String name){
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
  
  Player getCurrentplayer(){
    if(this.mCurrentPlayer == null){
      throw new Error("Aucun joueur courant");
    }
    return this.mCurrentPlayer;
  }
}
