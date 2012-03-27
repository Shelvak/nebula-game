package controllers.timedupdate
{
   import models.ModelLocator;


   public class MovementUpdateTrigger implements IUpdateTrigger
   {
      include "IUpdateTriggerHelperMethods.as";

      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }

      public function update(): void {
         updateList(ML.routes);
         updateList(ML.squadrons);
         // since there are no hostiles routes in ML.routes, we have to update
         // squadron in a planet directly so that jumpsAt time would be updated
         if (ML.latestPlanet != null) {
            updateList(ML.latestPlanet.squadrons);
         }
      }

      public function resetChangeFlags(): void {
         resetChangeFlagsOfList(ML.routes);
         resetChangeFlagsOfList(ML.squadrons);
         if (ML.latestPlanet != null) {
            resetChangeFlagsOfList(ML.latestPlanet.squadrons);
         }
      }
   }
}