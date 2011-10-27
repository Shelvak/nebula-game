package controllers.technologies.actions
   /*
# Pauses upgrading technology
#
# Params:
#   id: Fixnum, id of technology to pause
#
   */
   
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   
   import models.factories.TechnologyFactory;
   import models.technology.Technology;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Used for pausing technology
    */
   public class PauseAction extends CommunicationAction
   {	
      public override function result(rmo:ClientRMO):void
      {
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      public override function cancel(rmo:ClientRMO):void
      {
         super.cancel(rmo);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var temp:Technology = TechnologyFactory.fromObject(cmd.parameters.technology);
         var technology:Technology = ML.technologies.getTechnologyByType(temp.type);
         technology.copyProperties(temp);
         if (temp.pauseRemainder != 0)
            technology.upgradePart.stopUpgrade();
         temp.cleanup();
      }
      
      
   }
}