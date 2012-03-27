package controllers.timedupdate
{
   import models.ModelLocator;


   public class GalaxyUpdateTrigger implements IUpdateTrigger
   {
      include "IUpdateTriggerHelperMethods.as";

      private function get galaxy(): IUpdatable {
         return ModelLocator.getInstance().latestGalaxy;
      }

      public function update(): void {
         updateItem(galaxy);
      }

      public function resetChangeFlags(): void {
         resetChangeFlagsOf(galaxy);
      }
   }
}
