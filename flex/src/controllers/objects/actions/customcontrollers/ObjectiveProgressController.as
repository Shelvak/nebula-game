package controllers.objects.actions.customcontrollers
{
   import models.objectives.QuestObjective;
   import models.quest.Quest;
   import models.quest.events.QuestEvent;

   import utils.PropertiesTransformer;
   import utils.logging.Log;


   public class ObjectiveProgressController extends BaseObjectController
   {
      public function ObjectiveProgressController() {
         super();
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         object = PropertiesTransformer.objectToCamelCase(object);
         var pQuest:Quest = ML.quests.findQuestByObjective(object.objectiveId);
         if (pQuest == null)
            throw new Error("Quest with objective id " + object.objectiveId + " was not found");
         var objective:QuestObjective = pQuest.objectives.find(object.objectiveId);
         objective.completed = object.completed;
         pQuest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
      }

      public override function objectDestroyed(
         objectSubclass: String, objectId: int, reason: String): void {
         var quest: Quest = ML.quests.findQuestByProgress(objectId);
         if (quest == null) {
            Log.getMethodLogger(this, "objectDestroyed").warn(
               "Quest with objective progress id {0} was not found", objectId);
            return;
         }
         var objective: QuestObjective = quest.findObjectiveByProgress(objectId);
         if (objective == null) {
            throw new Error("quest objective with progress id " + objectId + " was not found");
         }
         objective.completed = objective.count;
         quest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
      }
   }
}