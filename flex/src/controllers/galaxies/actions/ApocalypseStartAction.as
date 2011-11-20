package controllers.galaxies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.time.MTimeEventFixedMoment;


   public class ApocalypseStartAction extends CommunicationAction
   {
      public function ApocalypseStartAction() {
         super();
      }

      public override function applyServerAction(cmd: CommunicationCommand): void {
         var params:Object = cmd.parameters;
         ML.latestGalaxy.apocalypseStartEvent =
            MTimeEventFixedMoment.autoCreate(null, params["start"]);
      }
   }
}
