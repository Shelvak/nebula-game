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
       * Requests player profile information
       * 
       * @eventType players|show_profile
       */ 
      public static const SHOW_PROFILE:String = "players|show_profile";


      /**
       * Requests player vps multiplier to the given player
       *
       * @eventType players|battle_vps_multiplier
       */
      public static const BATTLE_VPS_MULTIPLIER:String = "players|battle_vps_multiplier";
      
      
      /**
       * Converts vip creds to creds
       * 
       * @eventType players|convert_creds
       */ 
      public static const CONVERT_CREDS:String = "players|convert_creds";
      
      
      /**
       * This is sent to the server once when a player opens quests screen from the first time login
       * screen and when player changes portalWithoutAllies property.
       * 
       * @eventType players|edit
       */
      public static const EDIT:String = "players|edit";
      
      public static const VIP:String = "players|vip";

      public static const VIP_STOP:String = "players|vip_stop";
      
      public static const RATINGS:String = "players|ratings";

      public static const RENAME:String = "players|rename";
      
      
      /**
       * @see controllers.players.actions.StatusChangeAction
       */
      public static const STATUS_CHANGE:String = "player|status_change";
      
      
      public function PlayersCommand(type:String, parameters:Object = null, fromServer:Boolean = false)
      {
         super (type, parameters, fromServer);
      }
   }
}