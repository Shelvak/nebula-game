package tests.chat.models.chat
{
   import asmock.framework.Expect;
   import asmock.framework.SetupResult;
   
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatChannelPublic;
   import models.chat.MChatMember;
   import models.chat.MChatMessage;
   
   import org.hamcrest.assertThat;
   
   
   public class TCMChat_publicMessages extends TCBaseMChat
   {
      public function TCMChat_publicMessages()
      {
         super();
      };
      
      
      public override function classesToMock() : Array
      {
         return super.classesToMock().concat(MChatChannelPublic);
      };
      
      
      private var channelGalaxy:MChatChannelPublic;
      private var message:MChatMessage;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         channelGalaxy = MChatChannelPublic(mockRepository.createDynamic(MChatChannelPublic, ["galaxy"]));
         SetupResult.forCall(channelGalaxy.name).returnValue("galaxy");
         message = MChatMessage(chat.messagePool.borrowObject());
         message.channel = "galaxy";
         message.message = "Lets blow something up!";
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         channelGalaxy = null;
         message = null;
      };
      
      
      [Test]
      public function should_set_missing_parameters_on_received_message_and_delegate_handling_to_channel() : void
      {
         var member:MChatMember = new MChatMember();
         member.id = 1;
         member.name = "mikism";
         
         message.playerId = member.id;
         
         Expect.call(channelGalaxy.receiveMessage(message))
            .doAction(function(message:MChatMessage) : void
            {
               assertThat( message.playerName, equals (member.name) );
            });
         
         mockRepository.replayAll();
         chat.channels.addChannel(channelGalaxy);
         chat.channelJoin("galaxy", member);
         chat.receivePublicMessage(message);
         mockRepository.verifyAll();
      };
   }
}