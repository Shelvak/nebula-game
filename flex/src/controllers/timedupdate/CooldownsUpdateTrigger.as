package controllers.timedupdate
{
   import models.ModelLocator;
   import models.cooldown.MCooldown;
   import models.map.MMapSpace;

   import mx.collections.ArrayCollection;


   public class CooldownsUpdateTrigger implements IUpdateTrigger
   {
      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }

      public function update(): void {
         if (cooldownInPlanetAccessible) {
            var cooldown: MCooldown = ML.latestPlanet.ssObject.cooldown;
            cooldown.update();
            if (cooldown.endsEvent.hasOccured) {
               ML.latestPlanet.ssObject.cooldown = null;
            }
         }
         if (cooldownsInSolarSystemAccessible) {
            updateListOfCooldowns(ML.latestSSMap);
         }
         if (cooldownsInGalaxyAccessible) {
            updateListOfCooldowns(ML.latestGalaxy);
         }
      }

      private function updateListOfCooldowns(map: MMapSpace): void {
         var remove: ArrayCollection = new ArrayCollection();
         for each (var cooldown: MCooldown in map.cooldowns) {
            cooldown.update();
            if (cooldown.endsEvent.hasOccured) {
               remove.addItem(cooldown);
            }
         }
         if (cooldownsInSolarSystemAccessible) {
            MasterUpdateTrigger.update(ML.latestSSMap.cooldowns);
         }
         if (cooldownsInGalaxyAccessible) {
            MasterUpdateTrigger.update(ML.latestGalaxy.cooldowns);
         }
         map.removeAllObjects(remove);
      }

      public function resetChangeFlags(): void {
         if (cooldownInPlanetAccessible) {
            ML.latestPlanet.ssObject.cooldown.resetChangeFlags();
         }
         if (cooldownsInSolarSystemAccessible) {
            MasterUpdateTrigger.resetChangeFlags(ML.latestSSMap.cooldowns);
         }
         if (cooldownsInGalaxyAccessible) {
            MasterUpdateTrigger.resetChangeFlags(ML.latestGalaxy.cooldowns);
         }
      }

      private function get cooldownInPlanetAccessible(): Boolean {
         return ML.latestPlanet != null &&
                   ML.latestPlanet.ssObject != null &&
                   ML.latestPlanet.ssObject.cooldown != null
      }

      private function get cooldownsInSolarSystemAccessible(): Boolean {
         return ML.latestSSMap != null;
      }

      private function get cooldownsInGalaxyAccessible(): Boolean {
         return ML.latestGalaxy != null;
      }
   }
}