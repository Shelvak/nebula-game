package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.Messenger;
   
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
         GlobalFlags.getInstance().lockApplication = true;
         var params:InviteActionParams = InviteActionParams(cmd.parameters);
         sendMessage(new ClientRMO({"playerId": params.playerId}));
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
         Messenger.show(Localizer.string('Alliances', 'message.playerInvited'),
            Messenger.MEDIUM);
      }
   }
}