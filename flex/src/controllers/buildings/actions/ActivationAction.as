package controllers.buildings.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GBuildingEvent;
   
   import models.building.Building;
   import models.factories.BuildingFactory;
   
   import utils.remote.rmo.ClientRMO;
   
   
   
   
   /**
    * Used for activating/deactivating building
    */
   public class ActivationAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         sendMessage(new ClientRMO({'id': cmd.parameters.id}, cmd.parameters as Building));
      }
   }
}