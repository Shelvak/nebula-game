package controllers.technologies.actions
{
/*
# Starts researching new technology (from level 0)
#
# Params:
#   type: String, i.e. ZetiumExtraction
#   planet_id: Fixnum, planet where to take resources from
#   scientists: Fixnum, how many scientists should we assign
#   speed_up: Boolean, should we speed up the research?
   #
   */
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GTechnologiesEvent;
   
   import models.factories.TechnologyFactory;
   import models.technology.Technology;
   
   /**
    * Used for researching new technology (from level 0)
    */
   public class NewAction extends CommunicationAction
   {
      override public function applyServerAction
         (cmd: CommunicationCommand) :void
      {
         var temp:Technology = TechnologyFactory.fromObject(cmd.parameters.technology);
         var technology:Technology = ML.technologies.getTechnologyByType(temp.type);
         technology.copyProperties(temp);
         technology.upgradePart.startUpgrade();
         temp.cleanup();
         new GTechnologiesEvent(GTechnologiesEvent.UPGRADE_APPROVED);
      }
   }
}