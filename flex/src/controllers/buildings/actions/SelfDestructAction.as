package controllers.buildings.actions
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.building.Building;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for self-destructing building
    */
   public class SelfDestructAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         sendMessage(new ClientRMO({'id': cmd.parameters.model.id,
         'withCreds': cmd.parameters.withCreds}, Building(cmd.parameters.model)));
      }
   }
}