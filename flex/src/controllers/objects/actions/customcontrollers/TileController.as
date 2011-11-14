package controllers.objects.actions.customcontrollers
{
   import models.ModelLocator;
   import models.folliage.BlockingFolliage;
   import models.planet.MPlanet;
   
   import utils.SingletonFactory;

   public class TileController extends BaseObjectController
   {
      private function get planet() : MPlanet {
         return ModelLocator.getInstance().latestPlanet;
      }
      
      public function TileController() {
         super();
      }
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void {
         if (planet != null) {
            var blockingFoliage:BlockingFolliage = planet.getBlockingFoliageById(objectId);
            if (blockingFoliage != null)
               planet.removeObject(blockingFoliage);
         }
      }
   }
}