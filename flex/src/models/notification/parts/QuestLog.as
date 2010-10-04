package models.notification.parts
{
   import models.BaseModel;
   import models.ModelLocator;
   import models.notification.INotificationPart;
   import models.quest.Quest;
   
   
   [ResourceBundle("Notifications")]
   public class QuestLog extends BaseModel implements INotificationPart
   {
      public function QuestLog(params:Object = null, qCompleted: Boolean = false)
      {
         super();
         if (params != null)
         {
            quest = ModelLocator.getInstance().quests.findQuest(params.id);
         }
         completed = qCompleted;
      }
      
      public var completed: Boolean;
      
      public function get title() : String
      {
         throw new Error('this method is abstract');
      }
      
      
      public function get message() : String
      {
         throw new Error('this method is abstract');
      }
      
      
      public var quest: Quest;
   }
}