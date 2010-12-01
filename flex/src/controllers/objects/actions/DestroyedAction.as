package controllers.objects.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.objects.ObjectClass;
   import controllers.objects.UpdatedReason;
   import controllers.units.OrdersController;
   import controllers.units.SquadronsController;
   
   import globalevents.GPlanetEvent;
   
   import models.building.Building;
   import models.quest.Quest;
   import models.quest.QuestObjective;
   import models.quest.events.QuestEvent;
   
   import mx.collections.ArrayCollection;
   
   import utils.StringUtil;
   
   /**
    *is received after battle for every unit that was destroyed 
    * @author Jho
    * 
    */   
   public class DestroyedAction extends CommunicationAction
   {
      private var ORDERS_CTRL:OrdersController = OrdersController.getInstance();
      private var SQUADS_CTRL:SquadronsController = SquadronsController.getInstance();
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var className:Array = String(cmd.parameters.className).split('::');
         var objectClass:String = StringUtil.firstToLowerCase(className[0]);
         var objectSubclass:String = className.length > 1 ? className[1] : null;
         var objectIds:Array = cmd.parameters.objectIds;
         var reason:String = cmd.parameters.reason;
         
         if (ML.latestPlanet)
         {
            ML.latestPlanet.units.disableAutoUpdate();
         }
         if (objectClass == ObjectClass.UNIT)
         {
            var destroyedUnits:ArrayCollection = ML.units.removeWithIDs(objectIds, reason == UpdatedReason.COMBAT);
            SQUADS_CTRL.destroyEmptySquadrons(destroyedUnits);
            ORDERS_CTRL.cancelOrderIfInvolves(destroyedUnits);
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
         
         if (ML.latestPlanet)
         {
            ML.latestPlanet.units.enableAutoUpdate();
         }
      }
   }
}