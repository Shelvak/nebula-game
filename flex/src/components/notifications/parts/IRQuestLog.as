package components.notifications.parts
{
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.QuestLogSkin;
   
   import flash.events.MouseEvent;
   
   import models.ModelLocator;
   import models.notification.parts.QuestLog;
   import models.quest.Quest;
   import models.quest.events.QuestEvent;
   
   import spark.components.Button;
   import spark.components.Label;
   
   import utils.locale.Localizer;
   
   
   public class IRQuestLog extends IRNotificationPartBase
   {
      public function IRQuestLog()
      {
         super();
         setStyle("skinClass", QuestLogSkin);
      };
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      public var lblQuestCompleted: Label;
      
      private function setQuestCompleted(e: QuestEvent = null) : void
      {
         if (lblQuestCompleted)
         {
            lblQuestCompleted.text = Localizer.string('Notifications', 'label.claimReward');
            lblQuestCompleted.visible = (questLog.completed && (questLog.quest.status == Quest.STATUS_COMPLETED));
            questLog.quest.addEventListener(QuestEvent.STATUS_CHANGE, setQuestCompleted);
         }
      };
      
      
      [SkinPart(required="true")]
      public var openButton:Button;
      private function setOpenButton() : void
      {
         if (openButton)
         {
            openButton.label = Localizer.string('Notifications', 'label.openQuests');
            var openFunction: Function;
            if (questLog.quest.status == Quest.STATUS_REWARD_TAKEN)
            {
               openFunction = function (e: MouseEvent): void
               {
                  ModelLocator.getInstance().quests.showAndFilter(true, questLog.quest);   
               }
            }
            else
            {
               openFunction = function (e: MouseEvent): void
               {
                  ModelLocator.getInstance().quests.showAndFilter(false, questLog.quest);
               }
            }
            openButton.addEventListener(MouseEvent.CLICK, openFunction);
         }
      };
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function get questLog() : QuestLog
      {
         return notificationPart as QuestLog;
      }
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (fNotificationPartChange)
         {
            setQuestCompleted();
            setOpenButton();
         }
         fNotificationPartChange = false;
      }
   }
}