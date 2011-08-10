package controllers.objects.actions.customcontrollers
{
   import models.factories.SolarSystemFactory;
   import models.solarsystem.SolarSystem;
   
   
   public class SolarSystemController extends BaseObjectController
   {
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