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

   /**
    * Used for upgrading technology
    */
   public class UpgradeAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
      }
   }
}