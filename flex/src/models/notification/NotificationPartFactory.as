package models.notification
{
   import models.notification.parts.*;

   
   /**
    * Static factory that lets you create instances of concrete implementations of
    * <code>INotificationPart</code> interface.
    */
   public class NotificationPartFactory
   {
      /**
       * Maps notification types (events) to their model classes.
       */
      private static const TYPE_TO_CLASS:Object = new Object();
      TYPE_TO_CLASS[NotificationType.NOT_ENOUGH_RESOURCES] = NotEnoughResources;
      TYPE_TO_CLASS[NotificationType.BUILDINGS_DEACTIVATED] = BuildingsDeactivated;
      TYPE_TO_CLASS[NotificationType.COMBAT_LOG] = CombatLog;
      TYPE_TO_CLASS[NotificationType.ACHIEVEMENT_COMPLETED] = AchievementCompleted;
      TYPE_TO_CLASS[NotificationType.QUEST_COMPLETED] = QuestCompletedLog;
      TYPE_TO_CLASS[NotificationType.EXPLORATION_FINISHED] = ExplorationFinished;
      TYPE_TO_CLASS[NotificationType.PLANET_ANNEXED] = PlanetAnnexed;
      TYPE_TO_CLASS[NotificationType.PLANET_PROTECTED] = PlanetProtected;
      TYPE_TO_CLASS[NotificationType.ALLIANCE_INVITATION] =  AllianceInvitation;
      TYPE_TO_CLASS[NotificationType.KICKED_FROM_ALLIANCE] = KickedFromAlliance;
      TYPE_TO_CLASS[NotificationType.ALLIANCE_JOINED] = AllianceJoined;
      TYPE_TO_CLASS[NotificationType.MARKET_OFFER_BOUGHT] = MarketOfferBought;
      TYPE_TO_CLASS[NotificationType.VPS_CONVERTED_TO_CREDS] = CredsConverted;
      
      /**
       * Creates concrete instance of <code>INotificationPart</code> and returns it.
       * 
       * @param type notification type (event). Use values from <code>NotificationType</code>
       * @param data parameters to pass for constructor of concrete <code>INotificationPart</code>
       * implementation class. You should see each concrete class constructor documentation for
       * specifics.
       * 
       * @return instance of <code>INotificationPart</code>
       */
      public static function createPart(notification: Notification) : INotificationPart
      {
         if (notification == null)
         {
            return null;
         }
         return new (TYPE_TO_CLASS[notification.event] as Class)(notification);
      }
   }
}