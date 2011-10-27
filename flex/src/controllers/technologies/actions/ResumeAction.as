package controllers.technologies.actions
   /*
   # Resumes paused technology
   #
   # Params:
   #   id: Fixnum, id of technology to upgrade
   #   scientists: Fixnum, how many scientists should we assign
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
    * Used for resuming technology researching
    */
   public class ResumeAction extends CommunicationAction
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
      
      override public function applyServerAction
         (cmd: CommunicationCommand) :void{
         var temp: Technology = TechnologyFactory.fromObject(cmd.parameters.technology);
         var technology:Technology = ML.technologies.getTechnologyByType(temp.type);
         technology.copyProperties(temp);
         technology.upgradePart.startUpgrade();
         temp.cleanup();
      }
      
      
   }
}