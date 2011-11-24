package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import utils.remote.rmo.ClientRMO;

   /**
    * Immediately finishes exploration mission for creds.
    * 
    * <p>Client -->> Server: <code>FinishExplorationActionParams</code><p/>
    * 
    * @see FinishExplorationActionParams
    */
   public class FinishExplorationAction extends CommunicationAction
   {
      public function FinishExplorationAction() {
         super();
      }
      
      public override function applyClientAction(cmd:CommunicationCommand) : void {
         var params:FinishExplorationActionParams = FinishExplorationActionParams(cmd.parameters);
         sendMessage(new ClientRMO({"id": params.planetId}));
      }
   }
}