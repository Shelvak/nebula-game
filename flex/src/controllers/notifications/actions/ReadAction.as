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
      private var notifs:Array = null;
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         GlobalFlags.getInstance().lockApplication = true;
         notifs = cmd.parameters.notifications;
         var ids: Array = [];
         for each (var notification: Notification in notifs)
         {
            ids.push(notification.id);
         }
         sendMessage(new ClientRMO({"ids": ids}, notifs[0]));
      }
      
      
      public override function result() : void
      {
         for each (var notification: Notification in notifs)
         {
            notification.read = true;
            notification.isNew = false;
         }
         notifs = null;
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}