package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.connection.ConnectionManager;
   
   import utils.StringUtil;

   
   /**
    * Shows appropriate popupup when user is about to be disconnected by the server.
    */
   public class DisconnectAction extends CommunicationAction
   {
      private static const REESTABLISHING: String = 'reestablishing';
      override public function applyServerAction(cmd:CommunicationCommand) : void {
         var reason:String = cmd.parameters.reason;
         if (reason == null || reason == REESTABLISHING)
            return;
         reason = StringUtil.underscoreToCamelCaseFirstLower(reason);
         ConnectionManager.getInstance().serverWillDisconnect(reason);
      }
   }
}