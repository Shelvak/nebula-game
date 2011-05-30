package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
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
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         var params:JoinActionParams = JoinActionParams(cmd.parameters);
         sendMessage(new ClientRMO({"notificationId": params.notificationId}));
      }
   }
}