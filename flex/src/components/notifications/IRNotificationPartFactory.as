package components.notifications
{
   import components.notifications.parts.IRBuildingsDeactivated;
   import components.notifications.parts.IRCombatLog;
   import components.notifications.parts.IRNotEnoughResources;
   import components.notifications.parts.IRQuestLog;
   
   import models.notification.NotificationType;

   
   /**
    * Static factory that lets you create instances of concrete implementations of
    * <code>INotificationPartIR</code> interface.
    */
   public class IRNotificationPartFactory
   {
      private static const TYPE_TO_CLASS:Object = {
         (String (NotificationType.NOT_ENOUGH_RESOURCES)): IRNotEnoughResources,
         (String (NotificationType.COMBAT_LOG)): IRCombatLog,
         (String (NotificationType.NEW_QUEST)): IRQuestLog,
         (String (NotificationType.QUEST_COMPLETED)): IRQuestLog,
         (String (NotificationType.BUILDINGS_DEACTIVATED)): IRBuildingsDeactivated
      };
      
      
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