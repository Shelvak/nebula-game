package controllers.timedupdate
{
   import models.ModelLocator;


   public class SolarSystemUpdateTrigger implements IUpdateTrigger
   {
      include "IUpdateTriggerHelperMethods.as";

      private function get solarSystem(): IUpdatable {
         return ModelLocator.getInstance().latestSSMap;
      }

      public function update(): void {
         updateItem(solarSystem);
      }

      public function resetChangeFlags(): void {
         updateItem(solarSystem);
      }
   }
}