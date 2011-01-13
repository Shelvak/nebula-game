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
   
   import globalevents.GTechnologiesEvent;
   
   import models.factories.TechnologyFactory;
   import models.technology.Technology;
   
   
   /**
    * Used for pausing technology
    */
   public class PauseAction extends CommunicationAction
   {	
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         var temp:Technology = TechnologyFactory.fromObject(cmd.parameters.technology);
         var technology:Technology = ML.technologies.getTechnologyByType(temp.type);
         technology.copyProperties(temp);
         if (temp.pauseRemainder != 0)
            technology.upgradePart.stopUpgrade();
         temp.cleanup();
         new GTechnologiesEvent(GTechnologiesEvent.PAUSE_APPROVED);
      }
      
      
   }
}