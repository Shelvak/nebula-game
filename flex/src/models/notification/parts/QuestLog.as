package models.notification.parts
{
   import models.BaseModel;
   import models.ModelLocator;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   import models.quest.Quest;
   
   
   public class QuestLog extends BaseModel implements INotificationPart
   {
      public function QuestLog(notif:Notification = null)
      {
         super();
         if (notif != null)
         {
            var params: Object = notif.params;
            quest = ModelLocator.getInstance().quests.findQuest(params.finished);
            if (quest == null)
            {
               throw new Error('notification for quest with id ' + params.finished + 
               ' could not be created. Quest not found!');
            }
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
      
      /**
       * No-op.
       */
      public function updateLocationName(id:int, name:String) : void {}
   }
}