package controllers.objects.actions.customcontrollers
{
   import utils.SingletonFactory;
   
   import controllers.ui.NavigationController;
   
   import models.factories.SSObjectFactory;
   import models.map.MapType;
   import models.planet.Planet;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SolarSystem;
   
   import mx.collections.IList;
   
   import utils.datastructures.Collections;

   
   public class SSObjectController extends BaseObjectController
   {
      public static function getInstance() : SSObjectController
      {
         return SingletonFactory.getSingletonInstance(SSObjectController);
      }
      
      
      public function SSObjectController()
      {
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void
      {
         var planetOld:MSSObject;
         var planetNew:MSSObject = SSObjectFactory.fromObject(object);
         function findExistingPlanet(list:IList) : MSSObject
         {
            return Collections.findFirstEqualTo(list, planetNew);
         }
         
         // update planet in current solar system's objects list
         var solarSystem:SolarSystem = ML.latestSolarSystem;
         if (solarSystem && !solarSystem.fake && solarSystem.id == planetNew.solarSystemId)
         {
            planetOld = findExistingPlanet(solarSystem.naturalObjects);
            planetOld.copyProperties(planetNew);
         }
         
         // update planet in list of player planets
         var planets:IList = ML.player.planets;
         planetOld = findExistingPlanet(planets);
         if (planetOld)
         {
            // planet does not belong to the player anymore so remove it from the list
            if (!planetNew.belongsToPlayer)
            {
               planets.removeItemAt(planets.getItemIndex(planetOld));
               planetOld.cleanup();
            }
            // otherwise just update
            else
            {
               planetOld.copyProperties(planetNew);
            }
         }
         
         // update current planet
         var planet:Planet = ML.latestPlanet;
         if (planet && !planet.fake && planet.id == planetNew.id)
         {
            // the planet is not visible to the player anymore, so invalidate it
            if (!planetNew.viewable)
            {
               ML.latestPlanet.setFlag_destructionPending();
               ML.latestPlanet = null;
               if (ML.activeMapType == MapType.PLANET)
               {
                  NavigationController.getInstance().toSolarSystem(solarSystem.id);
               }
            }
            // otherwise just update SSObject inside it
            else
            {
               planet.ssObject.copyProperties(planetNew);
            }
         }
         
         planetNew.cleanup();
      }
   }
}