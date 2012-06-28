package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.notification.MFaultEvent;

   import models.notification.MSuccessEvent;

   import models.notification.MTimedEvent;

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

      public function JoinAction()
      {
         super();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         sendMessage(new ClientRMO({"notificationId": JoinActionParams(
                 cmd.parameters).notificationId}));
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         if (cmd.parameters["success"])
            new MSuccessEvent(Localizer.string('Alliances', 'message.joinSuccess'));
         else
            new MFaultEvent(Localizer.string('Alliances', 'message.joinFail'));
      }
   }
}