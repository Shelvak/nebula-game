package controllers.alliances.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.Messenger;

   import models.player.PlayerMinimal;

   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;


   /**
    * Gives away alliance ownership to other player.
    *
    * He must:
    * <ul>
    *    <li>Be a member of same alliance.</li>
    *    <li>Have sufficient alliance technology level.</li>
    * </ul>
    *
    * <p>
    * Client -->> Server: <code>GiveAwayActionParams</code>
    * </p>
    * 
    * <p>
    * Client <<-- Server
    * <ul>
    *    <li><code>status</code> - 'success' or 'technology_level_too_low'</li>
    * </ul>
    * </p>
    *
    * @see GiveAwayActionParams
    */
   public class GiveAwayAction extends CommunicationAction
   {
      private var lastPlayer:PlayerMinimal = null;

      public override function applyClientAction(cmd: CommunicationCommand): void {
         var params:GiveAwayActionParams = GiveAwayActionParams(cmd.parameters);
         sendMessage(new ClientRMO({"playerId": params.player.id}, null, params));
         lastPlayer = params.player;
      }

      public override function applyServerAction(cmd: CommunicationCommand): void {
         const status:String = cmd.parameters["status"];
         switch (status) {
            
            case "success":
               // Intentionally left empty: do nothing here
               break;

            case "technology_level_too_low":
               Messenger.show(
                  getString("giveAway.message.techLevelTooLow", [lastPlayer.name])
               );
               break;

            default:
               throw new Error(
                  "Received unsupported status value '" + status
                     + "' from the server"
               );
         }
         lastPlayer = null;
      }

      private function getString(property: String,
                                 parameters: Array = null): String {
         return Localizer.string("Alliances", property, parameters);
      }
   }
}
