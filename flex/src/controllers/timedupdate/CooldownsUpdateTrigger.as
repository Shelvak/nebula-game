package controllers.timedupdate
{
   import models.ModelLocator;
   import models.cooldown.MCooldown;
   import models.map.MMapSpace;
   
   import mx.collections.ArrayCollection;
   
   
   public class CooldownsUpdateTrigger implements IUpdateTrigger
   {
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      public function CooldownsUpdateTrigger() {
      }
      
      public function update() : void {
         var cooldown:MCooldown;
         if (cooldownInPlanetAccessible) {
            cooldown = ML.latestPlanet.ssObject.cooldown;
            cooldown.update();
            if (cooldown.hasEnded) {
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
      
      private function updateListOfCooldowns(map:MMapSpace) : void {
         var cooldown:MCooldown;
         var remove:ArrayCollection = new ArrayCollection();
         for each (cooldown in map.cooldowns) {
            cooldown.update();
            if (cooldown.hasEnded) {
               remove.addItem(cooldown);
            }
         }
         map.removeAllObjects(remove);
      }
      
      public function resetChangeFlags() : void {
         var cooldown:MCooldown;
         if (cooldownInPlanetAccessible) {
            ML.latestPlanet.ssObject.cooldown.resetChangeFlags();
         }
         if (cooldownsInSolarSystemAccessible) {
            resetChangeFlagsIn(ML.latestSSMap);
         }
         if (cooldownsInGalaxyAccessible) {
            resetChangeFlagsIn(ML.latestGalaxy);
         }
      }
      
      private function resetChangeFlagsIn(map:MMapSpace) : void {
         for each (var cooldown:MCooldown in map.cooldowns) {
            cooldown.resetChangeFlags();
         }
      }
      
      private function get cooldownInPlanetAccessible() : Boolean {
         return ML.latestPlanet != null &&
                ML.latestPlanet.ssObject != null &&
                ML.latestPlanet.ssObject.cooldown != null
      }
      
      private function get cooldownsInSolarSystemAccessible() : Boolean {
         return ML.latestSSMap != null;
      }
      
      private function get cooldownsInGalaxyAccessible() : Boolean {
         return ML.latestGalaxy != null;
      }
   }
}