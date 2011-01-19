package controllers.objects.actions.customcontrollers
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import globalevents.GPlanetEvent;
   
   import models.building.Building;
   import models.building.events.BuildingEvent;
   import models.factories.BuildingFactory;
   import models.planet.PlanetObject;
   
   
   public class BuildingController extends BaseObjectController
   {
      public static function getInstance() : BuildingController
      {
         return SingletonFactory.getSingletonInstance(BuildingController);
      }
      
      
      public function BuildingController()
      {
         super();
      }
      
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : void
      {
         var building:Building = BuildingFactory.fromObject(object);
         if (ML.latestPlanet && ML.latestPlanet.id == building.planetId)
         {
            var objectOnPoint:PlanetObject = ML.latestPlanet.getObject(building.x, building.y);
            if (objectOnPoint != null && objectOnPoint is Building)
            {
               var ghost:Building = Building(objectOnPoint);
               ghost.copyProperties(building);
               ghost.upgradePart.startUpgrade();
            }
            else
            {
               ML.latestPlanet.build(building);
               building.upgradePart.startUpgrade();
            }
         }
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void
      {
         var buildingNew:Building = BuildingFactory.fromObject(object);
         if (ML.latestPlanet && ML.latestPlanet.id == buildingNew.planetId)
         {
            var buildingOld:Building = ML.latestPlanet.getBuildingById(buildingNew.id);
            if (buildingOld == null)
            {
               throw new Error("Can't update building " + buildingNew + ": object has not been found");
            }
            if (buildingOld.upgradeEndsAt && !buildingNew.upgradeEndsAt)
            {
               buildingOld.upgradePart.forceUpgradeCompleted();
            }
            buildingOld.copyProperties(buildingNew);
            buildingOld.dispatchEvent(new BuildingEvent(BuildingEvent.CONSTRUCTION_FINISHED));
            new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
         }
         buildingNew.cleanup();
      }
      
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void
      {
         if (ML.latestPlanet != null)
         {
            var building:Building = ML.latestPlanet.getBuildingById(objectId);
            if (building != null)
            {
               if (building == ML.selectedBuilding)
               {
                  ML.selectedBuilding = null;
               }
               ML.latestPlanet.removeObject(building);
               new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
            }
         }
      }
   }
}