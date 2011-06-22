package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.BaseModel;
   import models.player.Player;
   
   
   /**
    * Gets player data. 
    */
   public class ShowAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         ML.player.copyProperties(BaseModel.createModel(Player, cmd.parameters.player));
      }
   }
}