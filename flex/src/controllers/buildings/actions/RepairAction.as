package controllers.buildings.actions
{

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

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
   }
}