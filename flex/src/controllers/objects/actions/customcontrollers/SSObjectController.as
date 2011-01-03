package controllers.objects.actions.customcontrollers
{
   import com.developmentarc.core.utils.SingletonFactory;
   
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
            var result:IList = Collections.filter(list,
               function(ssObject:MSSObject) : Boolean
               {
                  return ssObject.id == planetNew.id;
               }
            );
            return result.length > 0 ? MSSObject(result.getItemAt(0)) : null;
         }
         
         // update planet in current solar system's objects list
         var solarSystem:SolarSystem = ML.latestSolarSystem;
         if (solarSystem && !solarSystem.fake && solarSystem.id == planetNew.solarSystemId)
         {
            planetOld = findExistingPlanet(solarSystem.objects);
            planetOld.copyProperties(planetNew);
         }
         
         // update planet in list of player planets
         var planets:IList = ML.player.planets;
         planetOld = findExistingPlanet(planets);
         if (planetOld)
         {
            // planet does not belong to the player anymore so remove it from the list
            if (!planetNew.isOwnedByCurrent)
            {
               planets.removeItemAt(planets.getItemIndex(planetOld));
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
            // the planet does not belong to the player anymore, so invalidate it
            if (!planetNew.isOwnedByCurrent)
            {
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
      }
   }
}