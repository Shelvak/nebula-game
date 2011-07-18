package controllers.objects.actions.customcontrollers
{
   import models.ModelLocator;
   import models.factories.SolarSystemFactory;
   import models.solarsystem.SolarSystem;
   
   import utils.SingletonFactory;
   
   
   public class SolarSystemController extends BaseObjectController
   {
      public static function getInstance() : SolarSystemController {
         return SingletonFactory.getSingletonInstance(SolarSystemController);
      }
      
      public function SolarSystemController() {
         super();
      }
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         var replacementSS:SolarSystem = SolarSystemFactory.fromObject(object);
         ML.latestGalaxy.removeObject(replacementSS); // lookup uses equals()
         ML.latestGalaxy.addObject(replacementSS);
      }
   }
}