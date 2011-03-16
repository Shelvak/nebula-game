package controllers.timedupdate
{
   import models.ModelLocator;
   import models.cooldown.MCooldown;
   
   import utils.datastructures.iterators.IIterator;
   import utils.datastructures.iterators.IIteratorFactory;
   
   
   public class CooldownsUpdateTrigger implements IUpdateTrigger
   {
      private function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      public function CooldownsUpdateTrigger()
      {
      }
      
      
      public function update() : void
      {
         var cooldown:MCooldown;
         
         // cooldown in a planet
         if (cooldownInPlanetAccessible)
         {
            cooldown = ML.latestPlanet.ssObject.cooldown;
            cooldown.update();
            if (cooldown.hasEnded)
            {
               ML.latestPlanet.ssObject.cooldown = null;
            }
         }
         
         // cooldown in solar system
         
         if (cooldownsInSolarSystemAccessible)
         {
            updateListOfCooldowns(IIteratorFactory.getIterator(ML.latestSolarSystem.cooldowns));
         }
         
         // cooldown in galaxy
         if (cooldownsInGalaxyAccessible)
         {
            updateListOfCooldowns(IIteratorFactory.getIterator(ML.latestGalaxy.cooldowns));
         }
      }
      
      
      private function updateListOfCooldowns(it:IIterator) : void
      {
         var cooldown:MCooldown;
         it.reset();
         while (it.hasNext)
         {
            cooldown = it.next();
            cooldown.update();
            if (cooldown.hasEnded)
            {
               it.remove();
            }
         }
      }
      
      
      public function resetChangeFlags() : void
      {
         var cooldown:MCooldown;
         
         // cooldown in a planet
         if (cooldownInPlanetAccessible)
         {
            ML.latestPlanet.ssObject.cooldown.resetChangeFlags();
         }
         
         // cooldown in solar system
         if (cooldownsInSolarSystemAccessible)
         {
            resetChangeFlagsIn(IIteratorFactory.getIterator(ML.latestSolarSystem.cooldowns);
         }
         
         // cooldown in galaxy
         if (cooldownsInGalaxyAccessible)
         {
            resetChangeFlagsIn(IIteratorFactory.getIterator(ML.latestGalaxy.cooldowns);
         }
      }
      
      
      private function resetChangeFlagsIn(it:IIterator) : void
      {
         it.reset();
         while (it.hasNext)
         {
            MCooldown(it.next()).resetChangeFlags();
         }
      }
      
      
      private function get cooldownInPlanetAccessible() : Boolean
      {
         return ML.latestPlanet != null &&
                ML.latestPlanet.ssObject != null &&
                ML.latestPlanet.ssObject.cooldown != null
      }
      
      
      private function get cooldownsInSolarSystemAccessible() : Boolean
      {
         return ML.latestSolarSystem != null;
      }
      
      
      private function get cooldownsInGalaxyAccessible() : Boolean
      {
         return ML.latestGalaxy != null;
      }
   }
}