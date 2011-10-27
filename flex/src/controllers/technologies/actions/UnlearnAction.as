package controllers.technologies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import models.technology.Technology;
   
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
         ML.technologies.getTechnologyById(techId).level = 0;
         ML.technologies.dispatchTechsChangeEvent();
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}