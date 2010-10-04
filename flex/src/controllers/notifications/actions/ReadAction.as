package controllers.notifications.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
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
      private var notif:Notification = null;
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         notif = cmd.parameters.notification;
         sendMessage(new ClientRMO({"id": notif.id}, notif));
      }
      
      
      public override function result() : void
      {
         notif.read = true;
         notif.isNew = false;
         notif = null;
      }
   }
}