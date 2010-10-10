package controllers.objects.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.objects.ObjectClass;
   import controllers.objects.UpdatedReason;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import flash.profiler.profile;
   
   import globalevents.GObjectEvent;
   import globalevents.GPlanetEvent;
   import globalevents.GUnitEvent;
   
   import models.BaseModel;
   import models.building.Building;
   import models.building.events.BuildingEvent;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.factories.BuildingFactory;
   import models.factories.ConstructionQueryEntryFactory;
   import models.factories.PlanetFactory;
   import models.factories.UnitFactory;
   import models.location.Location;
   import models.map.MapType;
   import models.planet.Planet;
   import models.quest.Quest;
   import models.quest.QuestObjective;
   import models.quest.events.QuestEvent;
   import models.solarsystem.SolarSystem;
   import models.unit.Unit;
   
   import utils.PropertiesTransformer;
   import utils.StringUtil;
   import utils.profiler.Profiler;
   
   /**
    *is received after battle for every unit that was updated 
    * @author Jho
    * 
    */   
   public class UpdatedAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         Profiler.start("updating objects " + cmd.parameters.className);
         var className:Array = String(cmd.parameters.className).split('::');
         var objectClass:String = StringUtil.firstToLowerCase(className[0]);
         var objectSubclass:String = className.length > 1 ? className[1] : null;
         var objects: Array = cmd.parameters.objects;
         var refreshUnits: Boolean = false;
         var reason:String = cmd.parameters.reason;
         var unloadedUnits: Array = [];
         for each (var object: Object in objects)
         {
            switch (objectClass)
            {
               case ObjectClass.UNIT:
                  Profiler.start("updating unit");
                  Profiler.start("creating unit");
                  var newUnit: Unit = UnitFactory.fromObject(object);
                  Profiler.end();
                  if (reason == UpdatedReason.UNLOADED)
                  {
                     unloadedUnits.push(newUnit);
                  }
                  else
                  {
                     Profiler.start("adding unit")
                     if (ML.latestPlanet != null)
                     {
                        ML.latestPlanet.units.addItem(newUnit);
                     }
                     Profiler.end();
                  }
                  refreshUnits = true;
                  Profiler.end();
                  break;
               
               case ObjectClass.BUILDING:
                  if (object != null)
                  {
                     var temp:Building = BuildingFactory.fromObject(object);
                     if (ML.latestPlanet && ML.latestPlanet.id == temp.planetId)
                     {
                        var targetBuilding: Building = ML.latestPlanet.getBuildingById(temp.id);
                        if (targetBuilding == null)
                        {
                           throw new Error ("building with id "+temp.id+" not found");
                        }
                        if ((targetBuilding.upgradeEndsAt != null) && (temp.upgradeEndsAt == null))
                           targetBuilding.upgradePart.forceUpgradeCompleted();
                        targetBuilding.copyProperties(temp);
                        targetBuilding.dispatchEvent(new BuildingEvent(BuildingEvent.CONSTRUCTION_FINISHED));
                        new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
                        targetBuilding.dispatchQueryChangeEvent();
                     }
                  }
                  break;
               
               case ObjectClass.ROUTE:
                  SquadronsController.getInstance().updateFriendlySquadron(object.id, BaseModel.createModel(Location, object.current));
                  break;
               
               case ObjectClass.QUEST_PROGRESS:
                  object = PropertiesTransformer.objectToCamelCase(object);
                  var quest: Quest = ML.quests.findQuest(object.questId);
                  if (quest == null)
                  {
                     throw new Error("quest with id "+object.questId+" was not found");
                  }
                  quest.status = object.status;
                  quest.completed = object.completed;
                  quest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
                  break;
               
               case ObjectClass.OBJECTIVE_PROGRESS:
                  object = PropertiesTransformer.objectToCamelCase(object);
                  var pQuest: Quest = ML.quests.findQuestByObjective(object.objectiveId);
                  if (pQuest == null)
                  {
                     throw new Error("quest with objective id "+object.objectiveId+" was not found");
                  }
                  var objective: QuestObjective = pQuest.objectives.findModel(object.objectiveId);
                  objective.completed = object.completed;
                  pQuest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
                  break;
               
               case ObjectClass.PLANET:
                  var planet:Planet = PlanetFactory.fromObject(object);
                  var ss:SolarSystem = ML.latestSolarSystem;
                  if (ss && !ss.fake && ss.id == planet.solarSystemId)
                  {
                     Planet(ss.planets.findModel(planet.id)).copyProperties(planet);
                     if (ML.activeMapType == MapType.PLANET && ML.latestPlanet.id == planet.id && !planet.isOwnedByCurrent)
                     {
                        ML.latestPlanet = null;
                        NavigationController.getInstance().toSolarSystem(ss.id);
                     }
                  }
                  break;
               
               case ObjectClass.CONSTRUCTION_QUEUE_ENTRY:
                  var tempQuery:ConstructionQueueEntry = ConstructionQueryEntryFactory.fromObject(object);
                  var constructor: Building = ML.latestPlanet.getBuildingById(tempQuery.constructorId);
                  constructor.constructionQueueEntries.addItem(tempQuery); 
                  constructor.dispatchQueryChangeEvent();
                  new GObjectEvent(GObjectEvent.OBJECT_APROVED);
                  break;
               
               default:
                  throw new Error("object class "+objectClass+" not found!");
                  break;
            }
         }
         if (unloadedUnits.length != 0)
         {
            new GUnitEvent(GUnitEvent.UNITS_UNLOADED, unloadedUnits);
         }
         if (refreshUnits)
         {
            Profiler.start("refreshing units");
            ML.latestPlanet.dispatchUnitRefreshEvent();
            Profiler.end();
         }
         Profiler.end();
      }
   }
}