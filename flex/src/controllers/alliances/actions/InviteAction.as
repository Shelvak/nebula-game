package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.notification.MSuccessEvent;

   import models.notification.MTimedEvent;

   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Invites a person to join alliance. You can only invite a person if you see his occupied planet.
    * Battleground planets do not count.
    * 
    * <p>
    * Client -->> Server: <code>InviteActionParams</code>
    * </p>
    * 
    * @see InviteActionParams
    */
   public class InviteAction extends CommunicationAction
   {
      public function InviteAction()
      {
         super();
      }
      
      
      override public function applyClientAction(cmd:CommunicationCommand) : void
      {
         var params:InviteActionParams = InviteActionParams(cmd.parameters);
         sendMessage(new ClientRMO({"playerId": params.playerId}));
      }
      
      public override function result(rmo:ClientRMO):void
      {
         super.result(rmo);
         new MSuccessEvent(Localizer.string('Alliances', 'message.playerInvited'));
      }
   }
}