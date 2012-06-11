package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.chat.MChat;
   import models.player.PlayerMinimal;
   import models.solarsystem.MSolarSystem;


   /**
    * Renames player in chat and home system owner
    */
   public class RenameAction extends CommunicationAction
   {
      override public function applyServerAction(cmd: CommunicationCommand): void {
         const playerId: int = cmd.parameters.id;
         const playerName: String = cmd.parameters.name;
         // Change name if it is our update.
         if (playerId == ML.player.id) {
            ML.player.name = playerName;
         }
         MChat.getInstance().renameMember(playerId, playerName);
         // TODO: move this to Galaxy and somehow generify this player renaming?
         for each (var ss: MSolarSystem in ML.latestGalaxy.solarSystems) {
            const player: PlayerMinimal = ss.player;
            if (player != null && player.id == playerId) {
               player.name = playerName;
            }
         }
      }
   }
}
