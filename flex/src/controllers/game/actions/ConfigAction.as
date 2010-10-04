package controllers.game.actions
{
   import com.developmentarc.core.utils.EventBroker;
   
   import config.Config;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.game.events.GameEvent;
   
   
   /**
    * Sets configurable static fields for models like Tile, SolarSystem and so on
    * (static fields that represent variations, widths and heights). 
    */	
   public class ConfigAction extends CommunicationAction
   {
      override public function applyServerAction (cmd: CommunicationCommand) :void
      {
         Config.setConfig(cmd.parameters.config);
         EventBroker.broadcast(new GameEvent(GameEvent.CONFIG_SET));
      }
   }
}