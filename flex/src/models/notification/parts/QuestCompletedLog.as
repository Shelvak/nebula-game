package models.notification.parts
{
   import utils.locale.Localizer;

   public class QuestCompletedLog extends QuestLog
   {
      public function QuestCompletedLog(params:Object=null)
      {
         super(params);
      }
      
      
      override public function get title() : String
      {
         return Localizer.string("Notifications", "title.questCompleted");
      }
      
      
      override public function get message() : String
      {
         return Localizer.string("Notifications", "message.questCompleted", [quest.title]);
      }
   }
}