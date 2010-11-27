package controllers.units.actions
{
   
   import components.notifications.NotificationAlert;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GUnitEvent;
   
   
   /**
    * Used for constructing new building
    */
   public class AttackAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         for each (var alert: NotificationAlert in ML.notificationAlerts)
         {
            if (alert.notif.id == cmd.parameters.notificationId)
            {
               alert.visible = false;
               ML.notificationAlerts.removeItemAt(ML.notificationAlerts.getItemIndex(alert));
               break;
            }
         }
         ML.notifications.show(cmd.parameters.notificationId);
      }
   }
}