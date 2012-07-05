package controllers.objects.actions.customcontrollers
{
   import controllers.startup.StartupInfo;

   import models.objectives.QuestObjective;
   import models.quest.Quest;
   import models.quest.events.QuestEvent;

   import utils.PropertiesTransformer;
   import utils.logging.Log;


   public final class ObjectiveProgressController extends BaseObjectController
   {
      public function ObjectiveProgressController() {
         super();
      }


      public override function objectUpdated(
         objectSubclass: String, object: Object, reason: String): void
      {
         object = PropertiesTransformer.objectToCamelCase(object);
         var objectiveId: int = object["objectiveId"];
         var pQuest: Quest = ML.quests.findQuestByObjective(objectiveId);
         if (pQuest == null) {
            if (StartupInfo.relaxedServerMessagesHandlingMode) {
               Log.getMethodLogger(this, "objectUpdated").warn(
                  "Server wanted to update progress of a quest {0} but it was not found. "
                     + "Ignoring because application has not been fully initialized.",
                  objectiveId);
               return;
            }
            else {
               throw new Error("Quest with objective id " + objectiveId + " was not found");
            }
         }
         var objective: QuestObjective = pQuest.objectives.find(objectiveId);
         objective.completed = object["completed"];
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