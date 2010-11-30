package models.notification.parts
{
   import utils.Localizer;

   public class NewQuestLog extends QuestLog
   {
      public function NewQuestLog(params:Object=null)
      {
         super(params, false);
      }
      
      
      override public function get title() : String
      {
         return Localizer.string("Notifications", "title.newQuest", [quest.title]);
      }
      
      
      override public function get message() : String
      {
         return Localizer.string("Notifications", "message.newQuest", [quest.title]);
      }
   }
}