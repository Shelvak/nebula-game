package components.notifications.parts
{
   import components.achievement.AchievementComp;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.AchievementCompletedSkin;
   import components.notifications.parts.skins.QuestLogSkin;
   
   import flash.events.MouseEvent;
   
   import models.ModelLocator;
   import models.notification.parts.AchievementCompleted;
   import models.notification.parts.QuestLog;
   import models.quest.Quest;
   import models.quest.events.QuestEvent;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.Button;
   import spark.components.DataGroup;
   import spark.components.Label;
   
   import utils.locale.Localizer;
   
   
   public class IRAchievementCompleted extends IRNotificationPartBase
   {
      public function IRAchievementCompleted()
      {
         super();
         setStyle("skinClass", AchievementCompletedSkin);
      };
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      public var lblAbout: Label;
      
      private function setLblAbout() : void
      {
         if (lblAbout)
         {
            lblAbout.text = achievementCompleted.achievement.objectiveText;
         }
      };
      [SkinPart(required="true")]
      public var achievementComp: AchievementComp;
      
      private function setAchievementComp() : void
      {
         if (achievementComp) 
         {
            achievementComp.achievement = achievementCompleted.achievement;
         }
      }
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function get achievementCompleted() : AchievementCompleted
      {
         return notificationPart as AchievementCompleted;
      }
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_NotificationPartChange)
         {
            setLblAbout();
            setAchievementComp();
         }
         f_NotificationPartChange = false;
      }
   }
}