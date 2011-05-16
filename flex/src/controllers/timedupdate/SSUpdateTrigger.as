package controllers.timedupdate
{
   import models.ModelLocator;
   import models.solarsystem.SolarSystem;
   
   import utils.DateUtil;
   import utils.datastructures.iterators.IIterator;
   import utils.datastructures.iterators.IIteratorFactory;
   
   
   public class SSUpdateTrigger implements IUpdateTrigger
   {
      private function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      public function SSUpdateTrigger()
      {
      }
      
      
      public function update() : void
      {
         if (solarSystemsInGalaxyAccessible)
         {
            var it:IIterator = IIteratorFactory.getIterator(ML.latestGalaxy.solarSystems);
            while (it.hasNext)
            {
               var ss:SolarSystem = SolarSystem(it.next());
               // remove shield protection if it has expired
               if (ss.isShielded && ss.shieldEndsAt.time <= DateUtil.now)
               {
                  ss.shieldOwnerId = 0;
                  ss.shieldEndsAt = null;
               }
               ss.update();
            }
         }
      }
      
      
      public function resetChangeFlags() : void
      {
         if (solarSystemsInGalaxyAccessible)
         {
            var it:IIterator = IIteratorFactory.getIterator(ML.latestGalaxy.solarSystems);
            while (it.hasNext)
            {
               SolarSystem(it.next()).resetChangeFlags();
            }
         }
      }
      
      
      private function get solarSystemsInGalaxyAccessible() : Boolean
      {
         return ML.latestGalaxy != null;
      }
   }
}