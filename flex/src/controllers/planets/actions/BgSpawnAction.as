package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import utils.remote.rmo.ClientRMO;


   public class BgSpawnAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand) : void {
         var params:BgSpawnActionParams = BgSpawnActionParams(cmd.parameters);
         sendMessage(new ClientRMO({
            "id": params.planetId
         }));
      }
   }
}
