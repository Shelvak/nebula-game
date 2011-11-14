package controllers.objects.actions.customcontrollers
{
   import models.factories.SolarSystemFactory;
   import models.galaxy.Galaxy;
   import models.solarsystem.MSolarSystem;
   
   
   public class SolarSystemController extends BaseObjectController
   {
      public function SolarSystemController() {
         super();
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         var replacementSS:MSolarSystem = SolarSystemFactory.fromObject(object);
         var galaxy:Galaxy = ML.latestGalaxy;
         galaxy.removeObject(replacementSS); // lookup uses equals()
         galaxy.addObject(replacementSS);
         galaxy.refreshSolarSystemsWithPlayer();
      }
   }
}