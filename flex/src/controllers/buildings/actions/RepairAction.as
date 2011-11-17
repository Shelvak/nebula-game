package controllers.buildings.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;

   import models.building.Building;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for repairing building
    */
   public class RepairAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         sendMessage(new ClientRMO({'id': cmd.parameters.id},
                 Building(cmd.parameters)));
      }

      public override function cancel(rmo: ClientRMO): void {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }

      public override function result(rmo: ClientRMO): void {
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}