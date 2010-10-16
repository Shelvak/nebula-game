package models.notification.parts
{
   public class NewQuestLog extends QuestLog
   {
      public function NewQuestLog(params:Object=null)
      {
         super(params, false);
      }
      
      
      override public function get title() : String
      {
         return RM.getString("Notifications", "title.newQuest", [quest.title]);
      }
      
      
      override public function get message() : String
      {
         return RM.getString("Notifications", "message.newQuest", [quest.title]);
      }
   }
}