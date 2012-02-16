/**
 * Created by IntelliJ IDEA.
 * User: arturas
 * Date: 2/16/12
 * Time: 11:59 AM
 * To change this template use File | Settings | File Templates.
 */
package controllers.playeroptions.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.player.PlayerOptions;

   public class ShowAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand):void {
         PlayerOptions.loadOptions(cmd.parameters.options);
      }
   }
}
