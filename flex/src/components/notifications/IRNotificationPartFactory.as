package components.notifications
{
   import components.notifications.parts.*;
   
   import models.notification.NotificationType;

   
   /**
    * Static factory that lets you create instances of concrete implementations of
    * <code>INotificationPartIR</code> interface.
    */
   public class IRNotificationPartFactory
   {
      private static const TYPE_TO_CLASS:Object = new Object();
      with (NotificationType)
      {
         TYPE_TO_CLASS[NOT_ENOUGH_RESOURCES] = IRNotEnoughResources;
         TYPE_TO_CLASS[COMBAT_LOG] = IRCombatLog;
         TYPE_TO_CLASS[ACHIEVEMENT_COMPLETED] = IRAchievementCompleted;
         TYPE_TO_CLASS[QUEST_COMPLETED] = IRQuestLog;
         TYPE_TO_CLASS[BUILDINGS_DEACTIVATED] = IRBuildingsDeactivated;
         TYPE_TO_CLASS[EXPLORATION_FINISHED] = IRExplorationFinished;
         TYPE_TO_CLASS[PLANET_ANNEXED] = IRPlanetAnnexed;
         TYPE_TO_CLASS[PLANET_PROTECTED] = IRPlanetProtected;
         TYPE_TO_CLASS[ALLIANCE_INVITATION] = IRAllianceInvitation;
         TYPE_TO_CLASS[KICKED_FROM_ALLIANCE] = IRKickedFromAlliance;
         TYPE_TO_CLASS[ALLIANCE_JOINED] = IRAllianceJoined;
      }
      
      
      /**
       * Creates concrete instance of <code>IIRNotificationPart</code> and returns it.
       * 
       * @param type notification type (event). Use values from <code>NotificationType</code>
       * 
       * @return instance of <code>IIRNotificationPart</code>
       */
      public static function createPartIR(type:int) : IIRNotificationPart
      {
         return new (TYPE_TO_CLASS[type] as Class)();
      }
   }
}