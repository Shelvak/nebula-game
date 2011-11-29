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

   import models.factories.TechnologyFactory;
   import models.technology.Technology;

   /**
    * Used for resuming technology researching
    */
   public class ResumeAction extends CommunicationAction
   {
      
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