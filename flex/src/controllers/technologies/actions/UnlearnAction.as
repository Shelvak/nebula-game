package controllers.technologies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import utils.remote.rmo.ClientRMO;

   public class UnlearnAction extends CommunicationAction
   {
      private var techId: int;
      
      public override function applyClientAction(cmd:CommunicationCommand):void
      {
         techId = cmd.parameters.id;
         super.applyClientAction(cmd);
      }
      
      public override function result(rmo:ClientRMO):void
      {
         super.result(rmo);
         ML.technologies.getTechnologyById(techId).level = 0;
         ML.technologies.dispatchTechsChangeEvent();
      }
   }
}