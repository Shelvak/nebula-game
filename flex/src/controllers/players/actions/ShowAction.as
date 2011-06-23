package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.BaseModel;
   import models.player.Player;
   
   import utils.DateUtil;
   
   
   /**
    * Gets player data. 
    */
   public class ShowAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         var player:Object = cmd.parameters["player"];
         var allianceCooldown:String = player["allianceCooldownEndsAt"];
         ML.player.copyProperties(BaseModel.createModel(Player, player));
         if (allianceCooldown != null)
            ML.player.allianceCooldown.occuresAt = DateUtil.parseServerDTF(allianceCooldown);
      }
   }
}