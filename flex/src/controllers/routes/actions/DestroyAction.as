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
         sendMessage(new ClientRMO({id: cmd.parameters.id}, MSquadron(cmd.parameters)));
      }
      
      
      public override function result(rmo:ClientRMO) : void
      {
         MSquadron(rmo.model).flag_stopPending = false;
      }
      
      
      public override function cancel(rmo:ClientRMO) : void
      {
         super.cancel(rmo);
         MSquadron(rmo.model).flag_stopPending = false;
      }
   }
}