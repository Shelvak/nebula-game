package controllers.units.actions
{

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.notification.Notification;

   /**
    * Used for constructing new building
    */
   public class AttackAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         for each (var alert: Notification in ML.notificationAlerts)
         {
            if (alert.id == cmd.parameters.notificationId)
            {
               ML.notificationAlerts.removeItemAt(ML.notificationAlerts.getItemIndex(alert));
               break;
            }
         }
         ML.notifications.show(cmd.parameters.notificationId, true);
      }
   }
}