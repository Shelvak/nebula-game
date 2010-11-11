package controllers.units.actions
{
   
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
         ML.notifications.show(cmd.parameters.notificationId);
      }
   }
}