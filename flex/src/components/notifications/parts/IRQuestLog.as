package components.notifications.parts
{
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.QuestLogSkin;
   
   import flash.events.MouseEvent;
   
   import models.ModelLocator;
   import models.notification.parts.QuestLog;
   import models.quest.Quest;
   import models.quest.events.QuestEvent;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.Button;
   import spark.components.DataGroup;
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
      public var lblQuestCompleted: Button;
      
      private function setQuestCompleted() : void
      {
         if (lblQuestCompleted)
         {
            lblQuestCompleted.label = Localizer.string('Notifications', 
               'label.questCompleted', [questLog.quest.title]);
            
            function openFunction (e: MouseEvent): void
            {
               ModelLocator.getInstance().quests.showAndFilter(
                  questLog.quest.status == Quest.STATUS_REWARD_TAKEN, questLog.quest);   
            }
            lblQuestCompleted.addEventListener(MouseEvent.CLICK, openFunction);
         }
      };
      
      [SkinPart(required="true")]
      public var lblNewQuests: Label;
      
      [SkinPart(required="true")]
      public var newQuestsGroup: DataGroup;
      
      private function setNewQuests(e: QuestEvent = null) : void
      {
         if (lblNewQuests && newQuestsGroup) 
         {
            if (questLog.newQuests.length > 0)
            {
               lblNewQuests.visible = true;
               newQuestsGroup.visible = true;
               lblNewQuests.text = Localizer.string('Notifications', 
                  'message.newQuests');
               newQuestsGroup.dataProvider = new ArrayCollection(questLog.newQuests);
            }
            else
            {
               lblNewQuests.visible = false;
               newQuestsGroup.visible = false;
            }
         }
      }
      
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
            setNewQuests();
         }
         fNotificationPartChange = false;
      }
   }
}