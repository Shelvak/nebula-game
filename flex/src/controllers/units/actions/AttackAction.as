package controllers.units.actions
{
   
   import components.notifications.NotificationAlert;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import globalevents.GUnitEvent;
   
   import models.notification.Notification;
   
   import utils.remote.rmo.ClientRMO;
   
   
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
         ML.notifications.show(cmd.parameters.notificationId);
      }
      
      override public function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      override public function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}