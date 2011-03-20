package models.notification.parts
{
   import utils.locale.Localizer;

   public class QuestCompletedLog extends QuestLog
   {
      public function QuestCompletedLog(params:Object=null)
      {
         super(params, true);
      }
      
      
      override public function get title() : String
      {
         return Localizer.string("Notifications", "title.questCompleted", [quest.title]);
      }
      
      
      override public function get message() : String
      {
         return Localizer.string("Notifications", "message.questCompleted", [quest.title]);
      }
   }
}