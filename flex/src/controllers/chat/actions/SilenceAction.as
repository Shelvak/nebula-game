package controllers.chat.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;

   import models.chat.MChat;

   import utils.DateUtil;


   public class SilenceAction extends CommunicationAction
   {
      override public function applyServerAction(cmd: CommunicationCommand): void {
         MChat.getInstance().silenced.occuresAt =
            DateUtil.parseServerDTF(cmd.parameters["until"]);
      }
   }
}
