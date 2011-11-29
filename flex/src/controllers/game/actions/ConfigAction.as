package controllers.game.actions
{
   import config.Config;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import utils.ApplicationLocker;
   import controllers.startup.StartupInfo;
   import controllers.startup.StartupMode;
   
   
   /**
    * Sets configurable static fields for models like Tile, SolarSystem and so on
    * (static fields that represent variations, widths and heights). 
    */	
   public class ConfigAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void {
         Config.setConfig(cmd.parameters.config);
      }
   }
}