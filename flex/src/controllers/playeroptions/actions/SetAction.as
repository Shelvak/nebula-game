package controllers.playeroptions.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import flash.external.ExternalInterface;

   import models.chat.MChat;
   import models.player.PlayerOptions;

   import utils.remote.rmo.ClientRMO;


   public class SetAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand):void {
         var newOptions: Object = PlayerOptions.getOptions();
         sendMessage(new ClientRMO(newOptions));
         PlayerOptions.loadOptions(newOptions, true);
         MChat.getInstance().generateJoinLeaveMsgs =
                     PlayerOptions.chatShowJoinLeave;
         if (ExternalInterface.available) {
            ExternalInterface.call(
               "setLeaveHandler", PlayerOptions.warnBeforeUnload
            );
         }
      }
   }
}
