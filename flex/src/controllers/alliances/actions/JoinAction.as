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
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
         Messenger.show(Localizer.string('Alliances', 'message.joined'),
            Messenger.MEDIUM);
         ML.notifications.remove(notifId);
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}