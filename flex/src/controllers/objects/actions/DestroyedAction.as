package controllers.objects.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.objects.ObjectClass;
   import controllers.objects.UpdatedReason;
   import controllers.units.SquadronsController;
   
   import globalevents.GPlanetEvent;
   import globalevents.GUnitEvent;
   
   import models.building.Building;
   import models.movement.MSquadron;
   import models.quest.Quest;
   import models.quest.QuestObjective;
   import models.quest.events.QuestEvent;
   import models.unit.Unit;
   
   import utils.PropertiesTransformer;
   import utils.StringUtil;
   
   /**
    *is received after battle for every unit that was destroyed 
    * @author Jho
    * 
    */   
   public class DestroyedAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var className:Array = String(cmd.parameters.className).split('::');
         var objectClass:String = StringUtil.firstToLowerCase(className[0]);
         var objectSubclass:String = className.length > 1 ? className[1] : null;
         var objectIds:Array = cmd.parameters.objectIds;
         var reason:String = cmd.parameters.reason;
         
         if (objectClass == ObjectClass.UNIT)
         {
            if (reason == UpdatedReason.LOADED)
            {
               if (ML.latestPlanet != null)
               {
                  var loadedUnits: Array = [];
                  for each (var unitId: int in objectIds)
                  {
                     var dUnit: Unit = ML.latestPlanet.getUnitById(unitId);
                     if (dUnit != null)
                        ML.latestPlanet.units.removeExact(dUnit);
                     loadedUnits.push(dUnit);
                  }
                  if (loadedUnits.length != 0)
                  {
                     new GUnitEvent(GUnitEvent.UNITS_LOADED, loadedUnits);
                  }
                  ML.latestPlanet.dispatchUnitRefreshEvent(); 
               }
            }
            else
            {
               if (ML.latestPlanet != null)
               {
                  ML.latestPlanet.removeUnits(objectIds);
                  ML.latestPlanet.dispatchUnitRefreshEvent(); 
               }
               else
               {
                  SquadronsController.getInstance().removeUnitsFromSquadronsById(objectIds);
               }
            }
            
         }
         else
         {
            for each (var objectId: int in objectIds)
            {
               switch (objectClass)
               {
                  case ObjectClass.BUILDING:
                     if (ML.latestPlanet != null)
                     {
                        var destroyedBuilding: Building = ML.latestPlanet.getBuildingById(objectId);
                        if (destroyedBuilding != null)
                        {
                           ML.latestPlanet.removeObject(destroyedBuilding);
                           new GPlanetEvent(GPlanetEvent.BUILDINGS_CHANGE, ML.latestPlanet);
                        }
                     }
                     break;
                  
                  case ObjectClass.ROUTE:
                     SquadronsController.getInstance().stopSquadron(objectId);
                     break;
                  
                  case ObjectClass.OBJECTIVE_PROGRESS:
                     var quest: Quest = ML.quests.findQuestByProgress(objectId);
                     if (quest == null) 
                     {
                        throw new Error("quest with objective id "+objectId+" was not found");
                     }
                     var objective: QuestObjective = quest.findObjectiveByProgress(objectId);
                     if (objective == null)
                     {
                        throw new Error("quest objective with id "+objectId+" was not found");
                     }
                     objective.completed = objective.count;
                     quest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
                     break;
                  
                  case ObjectClass.NOTIFICATION:
                     ML.notifications.remove(objectId);
                     break;
                  
                  default:
                     throw new Error("object class "+objectClass+" not found!");
                     break;
               }
            }
         }
      }
   }
}