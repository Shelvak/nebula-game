package controllers.players
{
   import controllers.CommunicationCommand;
   
   
   
   
   /**
    * Used for initiating login to the server and logging out from it.
    */	
   public class PlayersCommand extends CommunicationCommand
   {
      /**
       * Dispatch this when you want to login.
       * 
       * @eventType players|login
       */
      public static const LOGIN:String = "players|login";
      
      
      /**
       * Dispach this when you want a user to logout.
       * 
       * @eventType players|logout
       */      
      public static const LOGOUT:String = "players|logout";
      
      
      /**
       * This command comes only from server carrying the reason why a player is
       * beeing disconnected. Don't dispatch it on the client side.
       * 
       * @eventType players|disconnect
       */ 
      public static const DISCONNECT:String = "players|disconnect";
      
      
      /**
       * This command comes only from server carrying all the player data. 
       * Don't dispatch it on the client side.
       * 
       * @eventType players|show
       */ 
      public static const SHOW:String = "players|show";
      
      
      /**
       * This is sent to the server only once when a player opens quests screen from the first time login
       * screen.
       * 
       * @eventType players|edit
       */
      public static const EDIT:String = "players|edit";
      
      
      public static const RATINGS:String = "players|ratings";
      
      
      public function PlayersCommand(type:String, parameters:Object = null, fromServer:Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}