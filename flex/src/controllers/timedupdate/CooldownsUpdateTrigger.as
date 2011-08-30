package controllers.timedupdate
{
   import models.ModelLocator;
   import models.cooldown.MCooldown;
   
   import utils.datastructures.iterators.IIterator;
   import utils.datastructures.iterators.IIteratorFactory;
   
   
   public class CooldownsUpdateTrigger implements IUpdateTrigger
   {
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      
      public function CooldownsUpdateTrigger() {
      }
      
      
      public function update() : void {
         if (cooldownInPlanetAccessible) {
            var cooldown:MCooldown = ML.latestPlanet.ssObject.cooldown;
            cooldown.update();
            if (cooldown.endsEvent.hasOccured)
               ML.latestPlanet.ssObject.cooldown = null;
         }
         if (cooldownsInSolarSystemAccessible)
            updateListOfCooldowns(ML.latestSolarSystem.cooldowns);
         if (cooldownsInGalaxyAccessible)
            updateListOfCooldowns(ML.latestGalaxy.cooldowns);
      }
      
      
      private function updateListOfCooldowns(list:*) : void {
         var it:IIterator = IIteratorFactory.getIterator(list);
         while (it.hasNext) {
            var cooldown:MCooldown = it.next();
            cooldown.update();
            if (cooldown.endsEvent.hasOccured)
               it.remove();
         }
      }
      
      public function resetChangeFlags() : void {
         if (cooldownInPlanetAccessible)
            ML.latestPlanet.ssObject.cooldown.resetChangeFlags();
         if (cooldownsInSolarSystemAccessible)
            MasterUpdateTrigger.resetChangeFlags(ML.latestSolarSystem.cooldowns);
         if (cooldownsInGalaxyAccessible)
            MasterUpdateTrigger.resetChangeFlags(ML.latestGalaxy.cooldowns);
      }
      
      
      private function get cooldownInPlanetAccessible() : Boolean {
         return ML.latestPlanet != null &&
                ML.latestPlanet.ssObject != null &&
                ML.latestPlanet.ssObject.cooldown != null
      }
      
      private function get cooldownsInSolarSystemAccessible() : Boolean {
         return ML.latestSolarSystem != null;
      }
      
      private function get cooldownsInGalaxyAccessible() : Boolean {
         return ML.latestGalaxy != null;
      }
   }
}