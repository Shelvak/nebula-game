package models.notification.parts
{
   import models.BaseModel;
   import models.achievement.MAchievement;
   import models.factories.AchievementFactory;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   
   import utils.locale.Localizer;
   
   
   public class AchievementCompleted extends BaseModel implements INotificationPart
   {
      /**
       * # EVENT_ACHIEVEMENT_COMPLETED = 3
       * #
       * # params = {
       * # :achievement => Quest#get_achievement
       * # }
       * @param notif
       * @return 
       * 
       */      
      public function AchievementCompleted(notif:Notification = null)
      {
         super();
         if (notif != null)
         {
            achievement = AchievementFactory.fromObject(notif.params.achievement);
         }
      }
      
      
      public function get title() : String
      {
         return Localizer.string("Notifications", "title.achievementCompleted");
      }
      
      
      public function get message() : String
      {
         return Localizer.string("Notifications", "message.achievementCompleted");
      }
      
      public var achievement:MAchievement;
      
      /**
       * No-op.
       */
      public function updateLocationName(id:int, name:String) : void {}
   }
}