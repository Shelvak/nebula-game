package controllers.planets.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import utils.remote.rmo.ClientRMO;


   public class ReinitiateCombatAction extends CommunicationAction
   {
      override public function applyClientAction(cmd: CommunicationCommand): void {
         const params: ReinitiateCombatActionParams = ReinitiateCombatActionParams(cmd.parameters);
         sendMessage(new ClientRMO({"id": params.planetId}));
      }
   }
}
