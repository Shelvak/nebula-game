package controllers.playeroptions.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import flash.external.ExternalInterface;

   import models.chat.MChat;

   import models.player.PlayerOptions;


   public class ShowAction extends CommunicationAction
   {
      public override function applyServerAction(cmd:CommunicationCommand):void {
         PlayerOptions.loadOptions(cmd.parameters.options);
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
