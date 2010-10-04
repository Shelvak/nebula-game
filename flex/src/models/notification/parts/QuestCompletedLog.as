package models.notification.parts
{
   public class QuestCompletedLog extends QuestLog
   {
      public function QuestCompletedLog(params:Object=null)
      {
         super(params, true);
      }
      
      
      override public function get title() : String
      {
            return RM.getString("Notifications", "title.questCompleted", [quest.title]);
      }
      
      
      override public function get message() : String
      {
            return RM.getString("Notifications", "message.questCompleted", [quest.title]);
      }
   }
}