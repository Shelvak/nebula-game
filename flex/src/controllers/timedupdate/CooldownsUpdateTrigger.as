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
         if (planetAccessible) {
            const cooldown: MCooldown = ML.latestPlanet.ssObject.cooldown;
            cooldown.update();
            if (cooldown.endsEvent.hasOccured) {
               ML.latestPlanet.ssObject.cooldown = null;
            }
         }
         if (solarSystemAccessible) {
            updateListOfCooldowns(ML.latestSSMap);
         }
         if (galaxyAccessible) {
            updateListOfCooldowns(ML.latestGalaxy);
         }
      }

      private function updateListOfCooldowns(map: MMapSpace): void {
         const remove: ArrayCollection = new ArrayCollection();
         for each (var cooldown: MCooldown in map.cooldowns) {
            cooldown.update();
            if (cooldown.endsEvent.hasOccured) {
               remove.addItem(cooldown);
            }
         }
         if (solarSystemAccessible) {
            MasterUpdateTrigger.updateList(ML.latestSSMap.cooldowns);
         }
         if (galaxyAccessible) {
            MasterUpdateTrigger.updateList(ML.latestGalaxy.cooldowns);
         }
         map.removeAllObjects(remove);
      }

      public function resetChangeFlags(): void {
         if (planetAccessible) {
            MasterUpdateTrigger.resetChangeFlagsOf(ML.latestPlanet.ssObject.cooldown);
         }
         if (solarSystemAccessible) {
            MasterUpdateTrigger.resetChangeFlagsOfList(ML.latestSSMap.cooldowns);
         }
         if (galaxyAccessible) {
            MasterUpdateTrigger.resetChangeFlagsOfList(ML.latestGalaxy.cooldowns);
         }
      }

      private function get planetAccessible(): Boolean {
         return ML.latestPlanet != null && ML.latestPlanet.ssObject != null;
      }

      private function get solarSystemAccessible(): Boolean {
         return ML.latestSSMap != null;
      }

      private function get galaxyAccessible(): Boolean {
         return ML.latestGalaxy != null;
      }
   }
}