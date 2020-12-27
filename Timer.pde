public class Timer{
  private boolean mState;
  private int mTimeAtPause;
  private int mMillisAtStart;

  public Timer(){
    mState = false;
  }

  // Démarre le timer
  public void start(){
    mState = true;
    mMillisAtStart = millis();
  }

  // Arrète le timer
  public void stop(){
    mTimeAtPause = mMillisAtStart;
    mState = false;
  }

  // Met en pause le timer
  public void pause(){
    if(mState == true){
      mTimeAtPause = millis();
      mState = false;
    }
  }

  // relance le timer
  public void resume(){
    mMillisAtStart += (millis() - mTimeAtPause);
    mState = true;
  }

  // Renvoie le temps
  public Time getTime(){
    return mState ? new Time(millis() - mMillisAtStart) : new Time(mTimeAtPause - mMillisAtStart);
  }
  /*
  public void reset(){

  }
  */
}

public class Time{
  private int mTime;

  public Time(int millis){
    mTime = millis;
  }

  public int toInteger(){
    return mTime;
  }

  public final String toStringFormat(int decimals){
    switch(decimals){
      case 0 :
        return (mTime/1000 + "s");
      case 1 :
        return (mTime/1000 + "." + mTime/100%10+ "s");
      case 2 :
        return (mTime/1000 + "." + mTime/100%10 + mTime/10%10 + "s");
      default :
        return (mTime/1000 + "." + mTime/100%10 + mTime/10%10 + mTime%1000+ "s");
    }
  }
}
