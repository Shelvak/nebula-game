package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.Messenger;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Joins an alliance. Can fail if alliance has too much members already.
    * 
    * <p>
    * Client -->> Server: <code>JoinActionParams</code>
    * </p>
    * 
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>success</code> - <code>true</code> if the player has joined an alliance</li>
    * </ul>
    * </p>
    * 
    * @see JoinActionParams
    */
   public class JoinAction extends CommunicationAction
   {
      private function get GF() : GlobalFlags
      {
         return GlobalFlags.getInstance();
      }
      
      
      public function JoinAction()
      {
         super();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         GF.lockApplication = true;
         sendMessage(new ClientRMO({"notificationId": JoinActionParams(cmd.parameters).notificationId}));
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         if (cmd.parameters["success"])
            Messenger.show(Localizer.string('Alliances', 'message.joinSuccess'), Messenger.MEDIUM);
         else
            Messenger.show(Localizer.string('Alliances', 'message.joinFail'), Messenger.MEDIUM);
      }
      
      
      public override function result(rmo:ClientRMO):void
      {
         GF.lockApplication = false;
      }
      
      
      public override function cancel(rmo:ClientRMO):void
      {
         GF.lockApplication = false;
         super.cancel(rmo);
      }
   }
}