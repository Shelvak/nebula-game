/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 2/16/12
 * Time: 1:18 PM
 * To change this template use File | Settings | File Templates.
 */
package controllers.playeroptions.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.player.PlayerOptions;

   import utils.remote.rmo.ClientRMO;

   public class SetAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand):void {
         sendMessage(new ClientRMO(PlayerOptions.getOptions()));
      }
   }
}
