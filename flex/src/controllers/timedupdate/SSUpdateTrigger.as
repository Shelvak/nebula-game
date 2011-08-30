package controllers.timedupdate
{
   import models.ModelLocator;
   import models.solarsystem.SolarSystem;
   
   import utils.DateUtil;
   
   
   public class SSUpdateTrigger implements IUpdateTrigger
   {
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      public function SSUpdateTrigger() {
      }
      
      
      public function update() : void {
         if (solarSystemsInGalaxyAccessible) {
            for each (var ss:SolarSystem in ML.latestGalaxy.solarSystems) {
               // remove shield protection if it has expired
               if (ss.isShielded && ss.shieldEndsAt.time <= DateUtil.now) {
                  ss.shieldOwnerId = 0;
                  ss.shieldEndsAt = null;
               }
               ss.update();
            }
         }
      }
      
      public function resetChangeFlags() : void {
         if (solarSystemsInGalaxyAccessible)
            MasterUpdateTrigger.resetChangeFlags(ML.latestGalaxy.solarSystems);
      }
      
      private function get solarSystemsInGalaxyAccessible() : Boolean {
         return ML.latestGalaxy != null;
      }
   }
}