package controllers.units.actions
{

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.notifications.EventsController;

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
         EventsController.getInstance().removeNotificationEvent(
            cmd.parameters.notification.id);
         ML.notifications.show(cmd.parameters.notification.id, true);
      }
   }
}