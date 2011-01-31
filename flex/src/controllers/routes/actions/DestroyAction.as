package controllers.routes.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.movement.MSquadron;
   
   import utils.remote.rmo.ClientRMO;
   
   
   public class DestroyAction extends CommunicationAction
   {
      private var _squadron:MSquadron;
      
      
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         _squadron = MSquadron(cmd.parameters);
         sendMessage(new ClientRMO({id: cmd.parameters.id}, _squadron));
      }
      
      
      public override function result() : void
      {
         _squadron.flag_stopPending = false;
      }
   }
}