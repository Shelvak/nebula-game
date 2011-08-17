package controllers.objects.actions.customcontrollers
{
   import models.quest.Quest;
   import models.quest.events.QuestEvent;
   
   import utils.PropertiesTransformer;
   
   
   public class QuestProgressController extends BaseObjectController
   {
      public function QuestProgressController() {
         super();
      }
      
      
      public override function objectUpdated(objectSubclass:String, object:Object, reason:String) : void {
         object = PropertiesTransformer.objectToCamelCase(object);
         var quest:Quest = ML.quests.findQuest(object.questId);
         if (quest == null)
            throw new Error("Quest with id " + object.questId + " was not found");
         quest.status = object.status;
         quest.completed = object.completed;
         quest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
      }
   }
}