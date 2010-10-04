package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import globalevents.GlobalEvent;
   
   import utils.remote.ServerConnector;
   
   
   
   
   /**
    * Performs logout operation. Sends logout message to the server and then
    * resets applicatio to its initial state.  
    */	
   public class LogoutAction extends CommunicationAction
   {
      /**
       * Sends logout message to the server.
       */      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         ML.player.loggedIn = false;
         if (ServerConnector.getInstance().connected)
         {
            ServerConnector.getInstance().disconnect();
         }
         new GlobalEvent(GlobalEvent.APP_RESET);
      }
   }
}