package controllers.objects.actions.customcontrollers
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import models.quest.Quest;
   import models.quest.QuestObjective;
   import models.quest.events.QuestEvent;
   
   import utils.PropertiesTransformer;
   
   
   public class ObjectiveProgressController extends BaseObjectController
   {
      public static function getInstance() : ObjectiveProgressController
      {
         return SingletonFactory.getSingletonInstance(ObjectiveProgressController);
      }
      
      
      public function ObjectiveProgressController()
      {
         super();
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void
      {
         object = PropertiesTransformer.objectToCamelCase(object);
         var pQuest:Quest = ML.quests.findQuestByObjective(object.objectiveId);
         if (pQuest == null)
         {
            throw new Error("Quest with objective id " + object.objectiveId + " was not found");
         }
         var objective:QuestObjective = pQuest.objectives.find(object.objectiveId);
         objective.completed = object.completed;
         pQuest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
      }
      
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void
      {
         var quest:Quest = ML.quests.findQuestByProgress(objectId);
         if (quest == null) 
         {
            throw new Error("Quest with objective progress id " + objectId + " was not found");
         }
         var objective:QuestObjective = quest.findObjectiveByProgress(objectId);
         if (objective == null)
         {
            throw new Error("quest objective with progress id " + objectId + " was not found");
         }
         objective.completed = objective.count;
         quest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
      }
   }
}