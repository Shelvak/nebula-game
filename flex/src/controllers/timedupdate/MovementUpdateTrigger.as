package controllers.timedupdate
{
   import models.ModelLocator;


   public class MovementUpdateTrigger implements IUpdateTrigger
   {
      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }

      public function update(): void {
         MasterUpdateTrigger.updateList(ML.routes);
         MasterUpdateTrigger.updateList(ML.squadrons);
         // since there are no hostiles routes in ML.routes, we have to update
         // squadron in a planet directly so that jumpsAt time would be updated
         if (ML.latestPlanet != null) {
            MasterUpdateTrigger.updateList(ML.latestPlanet.squadrons);
         }
      }

      public function resetChangeFlags(): void {
         MasterUpdateTrigger.resetChangeFlagsOfList(ML.routes);
         MasterUpdateTrigger.resetChangeFlagsOfList(ML.squadrons);
         if (ML.latestPlanet != null) {
            MasterUpdateTrigger.resetChangeFlagsOfList(ML.latestPlanet.squadrons);
         }
      }
   }
}