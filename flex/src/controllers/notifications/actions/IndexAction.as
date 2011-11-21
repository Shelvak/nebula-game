package controllers.notifications.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.notification.Notification;
   
   import mx.collections.ArrayCollection;
   
   import utils.Objects;
   
   
   /**
    * List of all notifications is received after galaxies|select.
    * 
    * <p>
    * Client <<-- Server:
    * <ul>
    *    <li>
    *       <code>notifications</code> - array of generic objects that represent
    *       <code>Notification</code>
    *    </li>
    * </ul>
    * </p>
    */
   public class IndexAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.notifications.removeAll();
         ML.notifications.addAll(
             Objects.fillCollection(
               new ArrayCollection(),
               Notification,
               cmd.parameters.notifications
            )
         );
      }
   }
}