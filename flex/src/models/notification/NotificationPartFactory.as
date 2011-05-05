package models.notification
{
   import models.notification.parts.AllianceInvitation;
   import models.notification.parts.BuildingsDeactivated;
   import models.notification.parts.CombatLog;
   import models.notification.parts.ExplorationFinished;
   import models.notification.parts.NotEnoughResources;
   import models.notification.parts.PlanetAnnexed;
   import models.notification.parts.PlanetProtected;
   import models.notification.parts.QuestCompletedLog;

   
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
      with (NotificationType)
      {
         TYPE_TO_CLASS[NOT_ENOUGH_RESOURCES] = NotEnoughResources;
         TYPE_TO_CLASS[BUILDINGS_DEACTIVATED] = BuildingsDeactivated;
         TYPE_TO_CLASS[COMBAT_LOG] = CombatLog;
         TYPE_TO_CLASS[QUEST_COMPLETED] = QuestCompletedLog;
         TYPE_TO_CLASS[EXPLORATION_FINISHED] = ExplorationFinished;
         TYPE_TO_CLASS[PLANET_ANNEXED] = PlanetAnnexed;
         TYPE_TO_CLASS[PLANET_PROTECTED] = PlanetProtected;
         TYPE_TO_CLASS[ALLIANCE_INVITATION] =  AllianceInvitation;
      };
      
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