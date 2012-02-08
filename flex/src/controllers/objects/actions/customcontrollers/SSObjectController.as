package controllers.objects.actions.customcontrollers
{
   import controllers.ui.NavigationController;

   import models.Owner;

   import models.factories.SSObjectFactory;
   import models.location.ILocationUser;
   import models.map.MMapSolarSystem;
   import models.map.MapType;
   import models.planet.MPlanet;
   import models.solarsystem.MSSObject;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;

   import utils.Objects;

   import utils.datastructures.Collections;

   
   public class SSObjectController extends BaseObjectController
   {
      public function SSObjectController() {
         super();
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         var planetOld:MSSObject;
         //var planetNew:MSSObject = SSObjectFactory.fromObject(object);
         function findExistingPlanet(list:IList) : MSSObject {
            return Collections.findFirst(list, function (item: MSSObject): Boolean
            {
               return item.id == object.id;
            });
         }
         
         // update planet in current solar system's objects list
         var ssMap:MMapSolarSystem = ML.latestSSMap;
         if (ssMap != null
                && !ssMap.fake
                && ssMap.id == object.solarSystemId) {
            planetOld = findExistingPlanet(ssMap.naturalObjects);
            Objects.update(planetOld, object);
         }
         
         // update planet in list of player planets
         var planets:IList = ML.player.planets;
         planetOld = findExistingPlanet(planets);
         if (planetOld != null) {
            // planet does not belong to the player anymore so remove it
            // from the list
            if (object.status != Owner.PLAYER) {
               planets.removeItemAt(planets.getItemIndex(planetOld));
               planetOld.cleanup();
            }
            // otherwise just update
            else {
               Objects.update(planetOld, object);
            }
         }
         
         // update current planet
         var planet:MPlanet = ML.latestPlanet;
         var nameChanged:Boolean =
                planet != null && planet.ssObject.name != object.name;
         if (planet != null && !planet.fake && planet.id == object.id) {
            // the planet is not visible to the player anymore, so invalidate it
            if (!object.viewable) {
               ML.latestPlanet.setFlag_destructionPending();
               ML.latestPlanet = null;
               if (ML.activeMapType == MapType.PLANET)
                  NavigationController.getInstance().toSolarSystem(ssMap.id);
            }
            // otherwise just update SSObject inside it
            else {
               Objects.update(planetOld, object);
            }
         }
         
         // update all location models if name has changed
         if (nameChanged) {
            var allLocUsers:ArrayCollection = new ArrayCollection();
            allLocUsers.addAll(ML.squadrons);
            allLocUsers.addAll(ML.routes);
            allLocUsers.addAll(ML.notifications);
            for each (var locUser:ILocationUser in allLocUsers) {
               locUser.updateLocationName(object.id, object.name);
            }
         }
      }
   }
}