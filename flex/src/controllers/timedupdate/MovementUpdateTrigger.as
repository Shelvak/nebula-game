package controllers.timedupdate
{
   import models.ModelLocator;


   public class MovementUpdateTrigger implements IUpdateTrigger
   {
      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }

      public function MovementUpdateTrigger() {
      }

      public function update(): void {
         MasterUpdateTrigger.update(ML.routes);
         MasterUpdateTrigger.update(ML.squadrons);
         // since there are no hostiles routes in ML.routes, we have to update
         // squadron in a planet directly so that jumpsAt time would be updated
         if (ML.latestPlanet != null) {
            MasterUpdateTrigger.update(ML.latestPlanet.squadrons);
         }
      }

      public function resetChangeFlags(): void {
         MasterUpdateTrigger.resetChangeFlags(ML.routes);
         MasterUpdateTrigger.resetChangeFlags(ML.squadrons);
         if (ML.latestPlanet != null) {
            MasterUpdateTrigger.resetChangeFlags(ML.latestPlanet.squadrons);
         }
      }
   }
}