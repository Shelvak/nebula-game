package controllers.timedupdate
{
   import models.ModelLocator;
   import models.solarsystem.MSolarSystem;


   public class SSUpdateTrigger implements IUpdateTrigger
   {
      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }

      public function SSUpdateTrigger() {
      }

      public function update(): void {
         if (solarSystemsInGalaxyAccessible) {
            for each (var ss: MSolarSystem in ML.latestGalaxy.solarSystems) {
            }
         }
      }

      public function resetChangeFlags(): void {
         if (solarSystemsInGalaxyAccessible) {
            MasterUpdateTrigger.resetChangeFlags(ML.latestGalaxy.solarSystems);
         }
      }

      private function get solarSystemsInGalaxyAccessible(): Boolean {
         return ML.latestGalaxy != null;
      }
   }
}