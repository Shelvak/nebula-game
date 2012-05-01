/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 4/20/12
 * Time: 5:02 PM
 * To change this template use File | Settings | File Templates.
 */
package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.chat.MChat;
   import models.solarsystem.MSolarSystem;


   /**
    * Renames player in chat and home system owner
    */
   public class RenameAction extends CommunicationAction
   {
      override public function applyServerAction(cmd:CommunicationCommand) : void {
         var playerId: int = cmd.parameters.id;
         var playerName: String = cmd.parameters.name;
         // Change name if it is our update.
         if (playerId == ML.player.id) {
            ML.player.name = playerName;
         }
         MChat.getInstance().members.getMember(playerId).name = playerName;
         for each (var obj: Object in ML.latestGalaxy.naturalObjects)
         {
            if (obj is MSolarSystem && MSolarSystem(obj).player.id == playerId)
            {
               MSolarSystem(obj).player.name = playerName;
            }
         }
      }
   }
}
