package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Removes explorable foliage for creds.
    * 
    * <p>Client -->> Server: <code>RemoveFoliageActionParams</code></p>
    */
   public class RemoveFoliageAction extends CommunicationAction
   {
      private function get GF() : GlobalFlags {
         return GlobalFlags.getInstance();
      }
      
      
      public function RemoveFoliageAction() {
         super();
      }
      
      public override function applyClientAction(cmd:CommunicationCommand) : void {
         GF.lockApplication = true;
         var params:RemoveFoliageActionParams = RemoveFoliageActionParams(cmd.parameters);
         sendMessage(new ClientRMO({
            "id": params.planetId,
            "x": params.foliageX,
            "y": params.foliageY
         }));
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