package controllers.galaxies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import models.time.MTimeEventFixedMoment;


   public class ApocalypseAction extends CommunicationAction
   {
      public function ApocalypseAction() {
         super();
      }

      public override function applyServerAction(cmd: CommunicationCommand): void {
         var params:Object = cmd.parameters;
         ML.latestGalaxy.apocalypseStartEvent =
            MTimeEventFixedMoment.autoCreate(null, params["start"]);
      }
   }
}
