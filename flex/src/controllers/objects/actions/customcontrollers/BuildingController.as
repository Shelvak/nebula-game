package controllers.objects.actions.customcontrollers
{
   import globalevents.GPlanetEvent;
   
   import models.building.Building;
   import models.building.events.BuildingEvent;
   import models.factories.BuildingFactory;
   import models.planet.MPlanetObject;

   import utils.Objects;


   public class BuildingController extends BaseObjectController
   {
      public function BuildingController() {
         super();
      }
      
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : * {
         var building:Building;
         if (ML.latestPlanet && ML.latestPlanet.id == object.planetId) {
            var objectOnPoint:MPlanetObject = ML.latestPlanet.getObject(object.x, object.y);
            if (objectOnPoint != null && objectOnPoint is Building) {
               building = Building(objectOnPoint);
               if (building.isGhost)
               {
                  Objects.update(building, object);
                  building.upgradePart.startUpgrade();
               }
               else
               {
                  throw new Error("Can't create building: " + object.type
                          + ", other building: " + Building(objectOnPoint).toString()
                          + "exists on the same point and it is not a ghost");
               }
            }
            else {
               building = BuildingFactory.fromObject(object);
               ML.latestPlanet.build(building);
               building.upgradePart.startUpgrade();
            }
         }
         return building;
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         if (ML.latestPlanet != null && ML.latestPlanet.id == object.planetId) {
            var buildingOld:Building = ML.latestPlanet.getBuildingById(object.id);
            if (buildingOld == null)
               throw new Error("Can't update building " + object.type + ": object has not been found");
            if (buildingOld.upgradeEndsAt && (object.upgradeEndsAt == null))
            {
               buildingOld.upgradePart.forceUpgradeCompleted();
            }
            Objects.update(buildingOld, object);
            buildingOld.dispatchEvent(new BuildingEvent(BuildingEvent.CONSTRUCTION_FINISHED));
            new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
         }
      }
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void {
         if (ML.latestPlanet != null) {
            var building:Building = ML.latestPlanet.getBuildingById(objectId);
            if (building != null) {
//               if (building == ML.selectedBuilding)
//               {
//                  ML.selectedBuilding = null;
//                  SidebarScreensSwitch.getInstance().showPrevious();
//               }
               ML.latestPlanet.removeObject(building);
               new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
            }
         }
      }
   }
}