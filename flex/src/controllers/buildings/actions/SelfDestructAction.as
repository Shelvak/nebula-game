package controllers.buildings.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import models.building.Building;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for self-destructing building
    */
   public class SelfDestructAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         GlobalFlags.getInstance().lockApplication = true;
         sendMessage(new ClientRMO({'id': cmd.parameters.model.id,
         'withCreds': cmd.parameters.withCreds}, Building(cmd.parameters.model)));
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}