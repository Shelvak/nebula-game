package controllers.players
{
   import controllers.CommunicationCommand;
   
   
   
   
   /**
    * Used for initiating login to the server and logging out from it.
    */	
   public class PlayersCommand extends CommunicationCommand
   {
      /**
       * Dispatch this when you want the client to connect with the server
       * and user to login.
       * 
       * @eventType login
       */
      public static const LOGIN:String = "players|login";
      
      /**
       * Dispach this when you want a user to logout and the client disconnect
       * from the server.
       * 
       * @eventType logout
       */      
      public static const LOGOUT:String = "players|logout";
      
      /**
       * This command comes only from server carrying the reason why a player is
       * beeing disconnected. Don't dispatch it on the client side.
       * 
       * @eventType disconnect
       */ 
      public static const DISCONNECT:String = "players|disconnect";
      
      /**
       * This command comes only from server carrying all the player data. 
       * Don't dispatch it on the client side.
       * 
       * @eventType playersShow
       */ 
      public static const SHOW:String = "players|show";
      
      
      public static const RATINGS:String = "players|ratings";
      
      
      
      
      /**
       * Constructor.
       */	   
      public function PlayersCommand
            (type: String,
             parameters: Object = null,
             fromServer: Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}