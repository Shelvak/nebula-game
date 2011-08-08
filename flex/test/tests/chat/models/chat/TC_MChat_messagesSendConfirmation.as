package tests.chat.models.chat
{
   import asmock.framework.Expect;
   import asmock.framework.SetupResult;
   
   import models.chat.MChatChannelPrivate;
   import models.chat.MChatChannelPublic;
   import models.chat.MChatMessage;
   
   
   public class TC_MChat_messagesSendConfirmation extends TC_BaseMChat
   {
      public function TC_MChat_messagesSendConfirmation()
      {
         super();
      }
      
      
      public override function classesToMock() : Array
      {
         return super.classesToMock().concat(
            MChatChannelPublic,
            MChatChannelPrivate
         );
      };
      
      
      private var channelGalaxy:MChatChannelPublic;
      private var channelFriend:MChatChannelPrivate;
      private var messagePub:MChatMessage;
      private var messagePri:MChatMessage;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         
         channelGalaxy = MChatChannelPublic(mockRepository.createDynamic(MChatChannelPublic, ["galaxy"]));
         SetupResult.forCall(channelGalaxy.name).returnValue("galaxy");
         
         channelFriend = MChatChannelPrivate(mockRepository.createDynamic(MChatChannelPrivate, ["friend"]));
         SetupResult.forCall(channelFriend.name).returnValue("friend");
         
         messagePub = MChatMessage(chat.messagePool.borrowObject());
         messagePub.channel = "galaxy";
         
         messagePri = MChatMessage(chat.messagePool.borrowObject());
         messagePri.channel = "friend";
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         channelGalaxy = null;
         messagePub = null;
         messagePri = null;
      };
      
      
      [Test]
      public function should_delegate_message_send_success_handling_to_channel() : void
      {
         Expect.call(channelGalaxy.messageSendSuccess(messagePub));
         Expect.call(channelFriend.messageSendSuccess(messagePri));
         
         mockRepository.replayAll();
         chat.channels.addChannel(channelGalaxy);
         chat.channels.addChannel(channelFriend);
         chat.messageSendSuccess(messagePub);
         chat.messageSendSuccess(messagePri);
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_delegate_message_send_failure_handling_to_channel() : void
      {
         Expect.call(channelGalaxy.messageSendFailure(messagePub));
         Expect.call(channelFriend.messageSendFailure(messagePri));
         
         mockRepository.replayAll();
         chat.channels.addChannel(channelGalaxy);
         chat.channels.addChannel(channelFriend);
         chat.messageSendFailure(messagePub);
         chat.messageSendFailure(messagePri);
         mockRepository.verifyAll();
      };
   }
}