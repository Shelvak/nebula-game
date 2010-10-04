package controllers.technologies.actions

   /*
# Upgrades existing technology
#
# Params:
#   id: Fixnum, id of technology to upgrade
#   planet_id: Fixnum, planet where to take resources from
#   scientists: Fixnum, how many scientists should we assign
#   speed_up: Boolean, should we speed up the research?
   #
   */
   
{
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import globalevents.GTechnologiesEvent;
   
   import models.factories.TechnologyFactory;
   import models.technology.Technology;
   
   
   /**
    * Used for upgrading technology
    */
   public class UpgradeAction extends CommunicationAction
   {	
      
      override public function applyServerAction
         (cmd: CommunicationCommand) :void{
         var temp: Technology = TechnologyFactory.fromObject(cmd.parameters.technology);
         ML.technologies.getTechnologyByType(temp.type).copyProperties(temp);
         ML.technologies.getTechnologyByType(temp.type).upgradePart.startUpgrade();
         new GTechnologiesEvent(GTechnologiesEvent.UPGRADE_APPROVED);
      }
      
      
   }
}