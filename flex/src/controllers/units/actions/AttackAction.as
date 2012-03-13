package controllers.units.actions
{

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.factories.NotificationFactory;

   import models.notification.Notification;

   /**
    * Used for constructing new building
    */
   public class AttackAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         NotificationFactory.fromObject(cmd.parameters.notification);
         for each (var alert: Notification in ML.notificationAlerts)
         {
            if (alert.id == cmd.parameters.notification.id)
            {
               ML.notificationAlerts.removeItemAt(ML.notificationAlerts.getItemIndex(alert));
               break;
            }
         }
         ML.notifications.show(cmd.parameters.notification.id, true);
      }
   }
}