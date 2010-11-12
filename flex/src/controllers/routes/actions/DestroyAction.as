package controllers.routes.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.movement.MSquadron;
   
   import utils.remote.rmo.ClientRMO;
   
   
   public class DestroyAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         sendMessage(new ClientRMO({id: cmd.parameters.id}, cmd.parameters as MSquadron));
      }
   }
}