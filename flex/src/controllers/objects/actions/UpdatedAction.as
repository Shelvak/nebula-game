package controllers.objects.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.objects.ObjectClass;
   import controllers.objects.UpdatedReason;
   import controllers.ui.NavigationController;
   import controllers.units.SquadronsController;
   
   import globalevents.GObjectEvent;
   import globalevents.GPlanetEvent;
   
   import models.BaseModel;
   import models.building.Building;
   import models.building.events.BuildingEvent;
   import models.constructionqueueentry.ConstructionQueueEntry;
   import models.factories.BuildingFactory;
   import models.factories.ConstructionQueryEntryFactory;
   import models.factories.SSObjectFactory;
   import models.factories.UnitFactory;
   import models.location.Location;
   import models.map.MapType;
   import models.planet.Planet;
   import models.quest.Quest;
   import models.quest.QuestObjective;
   import models.quest.events.QuestEvent;
   import models.solarsystem.SSObject;
   import models.solarsystem.SolarSystem;
   import models.unit.Unit;
   
   import mx.collections.IList;
   
   import utils.PropertiesTransformer;
   import utils.StringUtil;
   import utils.datastructures.Collections;
   
   /**
    *is received after battle for every unit that was updated 
    * @author Jho
    * 
    */
   public class UpdatedAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var className:Array = String(cmd.parameters.className).split('::');
         var objectClass:String = StringUtil.firstToLowerCase(className[0]);
         var objectSubclass:String = className.length > 1 ? className[1] : null;
         var objects: Array = cmd.parameters.objects;
         var reason:String = cmd.parameters.reason;
         ML.units.disableAutoUpdate();
         for each (var object: Object in objects)
         {
            switch (objectClass)
            {
               case ObjectClass.UNIT:
                  var unit:Unit = UnitFactory.fromObject(object);
                  if (reason == UpdatedReason.COMBAT)
                  {
                     ML.units.addOrUpdate(unit);  
                  }
                  else
                  {
                     ML.units.update(unit);
                  }
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
                  SquadronsController.getInstance().updateRoute(object.id, BaseModel.createModel(Location, object.current));
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
                  var objective: QuestObjective = pQuest.objectives.find(object.objectiveId);
                  objective.completed = object.completed;
                  pQuest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
                  break;
               
               case ObjectClass.SSOBJECT:
                  updatePlanet(object);
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
               ML.units.enableAutoUpdate();
         }
         
      }
      
      
      private function updatePlanet(data:Object) : void
      {
         var planetOld:SSObject;
         var planetNew:SSObject = SSObjectFactory.fromObject(data);
         function findExistingPlanet(list:IList) : SSObject
         {
            var result:IList = Collections.filter(list,
               function(ssObject:SSObject) : Boolean
               {
                  return ssObject.id == planetNew.id;
               }
            );
            return result.length > 0 ? SSObject(result.getItemAt(0)) : null;
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