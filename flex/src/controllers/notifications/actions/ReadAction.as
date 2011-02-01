package controllers.notifications.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import models.notification.Notification;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Marks notification as read.
    * 
    * <p>
    * Client -->> Server:</br>
    * <ul>
    *    <li><code>notification</code> - instance of <code>Notification</code> to mark as read</li>
    * </ul>
    * </p>
    */
   public class ReadAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         GlobalFlags.getInstance().lockApplication = true;
         var notifs:Array = cmd.parameters.notifications;
         var ids:Array = [];
         for each (var notification: Notification in notifs)
         {
            ids.push(notification.id);
         }
         sendMessage(new ClientRMO({"ids": ids}, notifs[0], {"notifs": notifs}));
      }
      
      
      public override function result(rmo:ClientRMO) : void
      {
         for each (var notification:Notification in rmo.additionalParams.notifs)
         {
            notification.read = true;
            notification.isNew = false;
         }
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}