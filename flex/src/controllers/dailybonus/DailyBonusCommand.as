package controllers.dailybonus
{
   import controllers.CommunicationCommand;
   
   /**
    * Used for daily bonus.
    */  
   public class DailyBonusCommand extends CommunicationCommand
   {
      public static const SHOW:String = "daily_bonus|show";
      public static const CLAIM:String = "daily_bonus|claim";
      
      /**
       * Constructor. 
       */
      public function DailyBonusCommand
         (type: String, parameters: Object = null, fromServer: Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}