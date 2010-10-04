package controllers.game
{
   import controllers.CommunicationCommand;
   
   
   
   
   /**
    * General game commands.
    */   
   public class GameCommand extends CommunicationCommand
   {
      
      /**
       * This command is received after login to set configuration: variations,
       * widths and heights of various buildings and similar stuff.
       *  
       * @eventType config 
       */
      public static const CONFIG: String = "config";
      
      
      
      
      /**
       * Constructor. 
       */      
      public function GameCommand
         (type: String, parameters: Object = null, fromServer: Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}