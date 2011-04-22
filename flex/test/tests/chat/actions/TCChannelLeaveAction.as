package tests.chat.actions
{
   import asmock.framework.Expect;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.ChannelLeaveAction;
   
   
   public class TCChannelLeaveAction extends TCBaseChatAction
   {
      public function TCChannelLeaveAction()
      {
         super();
      };
      
      
      [Test]
      public function should_notify_MChat() : void
      {
         var action:ChannelLeaveAction = new ChannelLeaveAction();
         var params:Object = {
            "chan": "galaxy",
            "pid": 1
         };
         
         Expect.call(MCHAT.channelLeave(params.chan, params.pid));
         
         mockRepository.replayAll();
         action.applyAction(new ChatCommand(ChatCommand.CHANNEL_LEAVE, params, true));
         mockRepository.verifyAll();
      }
   }
}