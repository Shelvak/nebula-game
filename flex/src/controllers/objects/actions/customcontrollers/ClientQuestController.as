package controllers.objects.actions.customcontrollers
{
   import models.factories.QuestFactory;
   import models.quest.Quest;
   import models.quest.events.QuestEvent;
   
   
   public class ClientQuestController extends BaseObjectController
   {
      public function ClientQuestController() {
         super();
      }
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : void {
         var quest:Quest = QuestFactory.fromObject(object);
         ML.quests.addItem(quest);
         quest.dispatchEvent(new QuestEvent(QuestEvent.STATUS_CHANGE));
      }
   }
}