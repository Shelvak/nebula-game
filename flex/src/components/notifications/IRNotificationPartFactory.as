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
      TYPE_TO_CLASS[NotificationType.NOT_ENOUGH_RESOURCES] = IRNotEnoughResources;
      TYPE_TO_CLASS[NotificationType.COMBAT_LOG] = IRCombatLog;
      TYPE_TO_CLASS[NotificationType.ACHIEVEMENT_COMPLETED] = IRAchievementCompleted;
      TYPE_TO_CLASS[NotificationType.QUEST_COMPLETED] = IRQuestLog;
      TYPE_TO_CLASS[NotificationType.BUILDINGS_DEACTIVATED] = IRBuildingsDeactivated;
      TYPE_TO_CLASS[NotificationType.EXPLORATION_FINISHED] = IRExplorationFinished;
      TYPE_TO_CLASS[NotificationType.PLANET_ANNEXED] = IRPlanetAnnexed;
      TYPE_TO_CLASS[NotificationType.PLANET_PROTECTED] = IRPlanetProtected;
      TYPE_TO_CLASS[NotificationType.ALLIANCE_INVITATION] = IRAllianceInvitation;
      TYPE_TO_CLASS[NotificationType.KICKED_FROM_ALLIANCE] = IRKickedFromAlliance;
      TYPE_TO_CLASS[NotificationType.ALLIANCE_JOINED] = IRAllianceJoined;
      TYPE_TO_CLASS[NotificationType.MARKET_OFFER_BOUGHT] = IRMarketOfferBought;
      TYPE_TO_CLASS[NotificationType.VPS_CONVERTED_TO_CREDS] = IRCredsConverted;
      TYPE_TO_CLASS[NotificationType.ALLIANCE_OWNER_CHANGED] = IRAllianceOwnerChanged;
      
      
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