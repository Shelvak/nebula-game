package controllers.technologies.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import globalevents.GCreditEvent;
   
   import models.factories.TechnologyFactory;
   import models.technology.Technology;
   
   import utils.remote.rmo.ClientRMO;
   
   /**
    * Used for accelerating technologies upgrade process
    */
   public class AccelerateAction extends CommunicationAction
   {
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function applyServerAction(cmd:CommunicationCommand):void
      {
         var temp:Technology = TechnologyFactory.fromObject(cmd.parameters.technology);
         var technology:Technology = ML.technologies.getTechnologyByType(temp.type);
         technology.upgradePart.stopUpgrade();
         technology.copyProperties(temp);
         if (technology.upgradeEndsAt != null)
         {
            technology.upgradePart.startUpgrade();
         }
         temp.cleanup();
      }
      
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}