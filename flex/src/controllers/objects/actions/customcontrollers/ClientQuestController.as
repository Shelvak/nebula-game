package controllers.objects.actions.customcontrollers
{
   import models.factories.QuestFactory;
   import models.quest.MMainQuestLine;
   import models.quest.Quest;
   import models.quest.events.QuestEvent;
   
   
   public class ClientQuestController extends BaseObjectController
   {
      public function ClientQuestController() {
         super();
      }
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : * {
         var oldQuest: Quest = ML.quests.find(object.id);
         if (oldQuest != null)
         {
            return oldQuest;
         }
         var quest:Quest = QuestFactory.fromObject(object);
         ML.quests.addItem(quest);
         quest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
         /* open tutorial if quest is main quest */
         if (quest.isMainQuest && quest.status == Quest.STATUS_STARTED) {
            MMainQuestLine.getInstance().openCurrentUncompletedQuest();
         }
         return quest;
      }
   }
}