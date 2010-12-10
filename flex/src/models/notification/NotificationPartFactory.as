package models.notification
{
   import models.notification.parts.NotEnoughResources;
   import models.notification.parts.BuildingsDeactivated;
   import models.notification.parts.CombatLog;
   import models.notification.parts.NewQuestLog;
   import models.notification.parts.QuestCompletedLog;
   import models.notification.parts.ExplorationFinished;

   
   /**
    * Static factory that lets you create instances of concrete implementations of
    * <code>INotificationPart</code> interface.
    */
   public class NotificationPartFactory
   {
      /**
       * Maps notification types (events) to their model classes.
       */ 
      private static const TYPE_TO_CLASS:Object = {
         (String (NotificationType.NOT_ENOUGH_RESOURCES)): NotEnoughResources,
         (String (NotificationType.BUILDINGS_DEACTIVATED)): BuildingsDeactivated,
         (String (NotificationType.COMBAT_LOG)): CombatLog,
         (String (NotificationType.NEW_QUEST)): NewQuestLog,
         (String (NotificationType.QUEST_COMPLETED)): QuestCompletedLog,
         (String (NotificationType.EXPLORATION_FINISHED)): ExplorationFinished
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
      public static function createPart(type:int, data:Object) : INotificationPart
      {
         if (data == null)
         {
            return null;
         }
         return new (TYPE_TO_CLASS[type] as Class)(data);
      }
   }
}