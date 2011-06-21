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
      public function JoinAction()
      {
         super();
      }
      
      private var notifId: int;
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         GlobalFlags.getInstance().lockApplication = true;
         var params:JoinActionParams = JoinActionParams(cmd.parameters);
         notifId = params.notificationId;
         sendMessage(new ClientRMO({"notificationId": notifId}));
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         if (cmd.parameters["success"])
         {
            Messenger.show(Localizer.string('Alliances', 'message.joinSuccess'), Messenger.MEDIUM);
            ML.notifications.remove(notifId);
         }
         else
         {
            Messenger.show(Localizer.string('Alliances', 'message.joinFail'), Messenger.MEDIUM);
         }
      }
      
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      
      public override function cancel(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
         super.cancel(rmo);
      }
   }
}