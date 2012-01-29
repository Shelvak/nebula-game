package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   
   import models.player.Player;
   
   import utils.DateUtil;
   import utils.Objects;
   
   
   /**
    * Gets player data. 
    */
   public class ShowAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand) : void {
         const player:Object = cmd.parameters["player"];
         const allianceCooldown:String = player["allianceCooldownEndsAt"];
         ML.player.copyProperties(Objects.create(Player, player));
         ML.player.allianceCooldownId = player["allianceCooldownId"];
         if (allianceCooldown != null) {
            ML.player.allianceCooldown.occuresAt = DateUtil.parseServerDTF(allianceCooldown);
         }
      }
   }
}