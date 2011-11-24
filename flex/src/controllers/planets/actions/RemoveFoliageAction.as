package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import utils.remote.rmo.ClientRMO;

   /**
    * Removes explorable foliage for creds.
    * 
    * <p>Client -->> Server: <code>RemoveFoliageActionParams</code></p>
    */
   public class RemoveFoliageAction extends CommunicationAction
   {
      public function RemoveFoliageAction() {
         super();
      }
      
      public override function applyClientAction(cmd:CommunicationCommand) : void {
         var params:RemoveFoliageActionParams = RemoveFoliageActionParams(cmd.parameters);
         sendMessage(new ClientRMO({
            "id": params.planetId,
            "x": params.foliageX,
            "y": params.foliageY
         }));
      }
   }
}