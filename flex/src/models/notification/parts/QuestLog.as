package models.notification.parts
{
   import models.BaseModel;
   import models.ModelLocator;
   import models.notification.INotificationPart;
   import models.quest.Quest;
   
   
   public class QuestLog extends BaseModel implements INotificationPart
   {
      public function QuestLog(params:Object = null)
      {
         super();
         if (params != null)
         {
            quest = ModelLocator.getInstance().quests.findQuest(params.finished);
            newQuests = [];
            for each (var qId: int in params.started)
            {
               newQuests.push(ModelLocator.getInstance().quests.findQuest(qId));
            }
         }
      }
      
      public var newQuests: Array;
      
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