package tests.chat.actions
{
   import asmock.framework.Expect;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.ChannelJoinAction;
   
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatMember;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperties;
   
   
   public class TC_ChannelJoinAction extends TC_BaseChatAction
   {
      public function TC_ChannelJoinAction()
      {
         super();
      };
      
      
      [Test]
      public function should_create_chat_member_and_notify_MChat() : void
      {
         var action:ChannelJoinAction = new ChannelJoinAction();
         var params:Object = {
            "chan": "galaxy",
            "pid": 1,
            "name": "mikism"
         };
         
         Expect.call(MCHAT.channelJoin(null, null))
            .ignoreArguments()
            .doAction(function(channel:String, member:MChatMember) : void
            {
               assertThat( channel, equals (params.chan) );
               assertThat( member, hasProperties ({
                  "id": params.pid,
                  "name": params.name
               }));
            });
         
         mockRepository.replayAll();
         action.applyAction(new ChatCommand(ChatCommand.CHANNEL_JOIN, params, true));
         mockRepository.verifyAll();
      };
   }
}