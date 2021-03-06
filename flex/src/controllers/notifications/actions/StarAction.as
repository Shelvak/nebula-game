package controllers.notifications.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.notification.Notification;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Marks or unmarks given <code>Notification</code> as starred.
    * <p>
    * Client -->> Server<br/>
    * <ul>
    *    <li><code>notification</code> - instance of <code>Notification</code> to mark</li>
    *    <li>
    *       <code>mark</code> - <code>true</code> if given notification should be starred or
    *       <code>false</code> otherwise
    *    </li>
    * </ul>
    * </p>
    */
   public class StarAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         var notif:Notification = cmd.parameters.notification;
         sendMessage(new ClientRMO({"id": notif.id, "mark": cmd.parameters.mark}, notif));
      }
      
      
      public override function result(rmo:ClientRMO) : void
      {
         super.result(rmo);
         Notification(rmo.model).starred = rmo.parameters.mark;
      }
   }
}