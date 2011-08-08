package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
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
      private function get GF() : GlobalFlags {
         return GlobalFlags.getInstance();
      }
      
      
      public function FinishExplorationAction() {
         super();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void {
         GF.lockApplication = true;
         var params:FinishExplorationActionParams = FinishExplorationActionParams(cmd.parameters);
         sendMessage(new ClientRMO({"id": params.id}));
      }
      
      public override function result(rmo:ClientRMO) : void {
         super.result(rmo);
         GF.lockApplication = false;
      }
      
      public override function cancel(rmo:ClientRMO) : void {
         super.cancel(rmo);
         GF.lockApplication = false;
      }
   }
}