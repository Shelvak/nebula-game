package controllers.game.actions
{
   import config.Config;

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import globalevents.GlobalEvent;


   /**
    * Sets configurable static fields for models like Tile, SolarSystem and so on
    * (static fields that represent variations, widths and heights). 
    */	
   public class ConfigAction extends CommunicationAction
   {
      // TODO: remove this override when we are done with map editor
      public override function applyClientAction(cmd:CommunicationCommand): void {
         new GlobalEvent(GlobalEvent.INITIALIZE_MAP_EDITOR);
      }

      override public function applyServerAction(cmd:CommunicationCommand): void {
         Config.setConfig(cmd.parameters.config);
         // TODO: uncomment when we are done with map editor
         // new GlobalEvent(GlobalEvent.INITIALIZE_MAP_EDITOR);
      }
   }
}