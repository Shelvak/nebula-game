package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
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
         sendMessage(new ClientRMO({"planetId": params.planetId}));
      }
   }
}