package controllers.objects.actions.customcontrollers
{
   import globalevents.GPlanetEvent;

   import models.building.Building;
   import models.building.events.BuildingEvent;
   import models.factories.BuildingFactory;
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;

   import utils.Objects;


   public class BuildingController extends BaseObjectController
   {
      public function BuildingController() {
         super();
      }


      public override function objectCreated(objectSubclass: String,
                                             object: Object,
                                             reason: String): * {
         var building: Building;
         if (ML.latestPlanet && ML.latestPlanet.id == object.planetId) {
            const objectOnPoint: MPlanetObject =
                   ML.latestPlanet.getObject(object.x, object.y);
            if (objectOnPoint != null && objectOnPoint is Building) {
               building = Building(objectOnPoint);
               if (building.isGhost) {
                  Objects.update(building, object);
                  building.upgradePart.startUpgrade();
               }
               else {
                  throw new Error(
                     "Can't create building: " + object.type + ", other building: "
                        + Building(objectOnPoint) + "exists on the same point "
                        + "and it is not a ghost");
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


      public override function objectUpdated(objectSubclass: String,
                                             object: Object,
                                             reason: String): void {
         const planet:MPlanet = ML.latestPlanet;
         if (planet != null && planet.id == object.planetId) {
            const buildingOld: Building = planet.getBuildingById(object.id);
            if (buildingOld == null) {
               throw new Error(
                  "Can't update building " + object["type"]
                     + ": object has not been found"
               );
            }
            if (buildingOld.upgradeEndsAt && (object["upgradeEndsAt"] == null)) {
               buildingOld.upgradePart.forceUpgradeCompleted();
            }
            planet.moveBuilding(buildingOld, object["x"], object["y"]);
            Objects.update(buildingOld, object);
            buildingOld.dispatchEvent(
               new BuildingEvent(BuildingEvent.CONSTRUCTION_FINISHED)
            );
            new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, planet);
         }
      }

      public override function objectDestroyed(objectSubclass: String,
                                               objectId: int,
                                               reason: String): void {
         if (ML.latestPlanet != null) {
            const building: Building = ML.latestPlanet.getBuildingById(objectId);
            if (building != null) {
               ML.latestPlanet.removeObject(building);
               new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
            }
         }
      }
   }
}