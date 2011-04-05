package tests.chat.models.message
{
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatChannel;
   import models.chat.MChatMessage;
   import models.chat.message.processors.ChatMessageProcessor;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperties;
   
   
   public class TCChatMessageProcessor extends TCBaseChatMessageProcessor
   {
      private var channel:MChatChannel;
      private var processor:ChatMessageProcessor;
      private var message:MChatMessage;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         message = MChatMessage(MCHAT.messagePool.borrowObject());
         message.time = new Date();
         message.playerId = 1;
         message.playerName = "mikism";
         message.message = "I'm tired";
         processor = new ChatMessageProcessor();
         channel = new MChatChannel("galaxy", processor);
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         processor = null;
         channel = null;
         message = null;
      };
      
      
      [Test]
      public function when_received_new_message_should_add_it_to_channel_content() : void
      {
         processor.receiveMessage(message);
         
         assertThat( channel.content.text.numChildren, equals (1) );
         
         // MChatMessageProcessor must return MChatMessage to the pool
         assertThat( MCHAT.messagePool, hasProperties({
            "numActive": 0,
            "numIdle": 1
         }));
      };
      
      
      [Test]
      public function when_a_message_sent_was_rejected_should_return_it_to_the_pool_and_do_nothing() : void
      {
         processor.messageSendFailure(message);
         
         assertThat(channel.content.text.numChildren, equals (0) );
         
         // MChatMessageProcessor must return MChatMessage to the pool
         assertThat( MCHAT.messagePool, hasProperties({
            "numActive": 0,
            "numIdle": 1
         }));
      };
      
      
      [Test]
      public function when_message_has_successfully_been_posted_should_add_it_to_channel_content() : void
      {
         processor.messageSendSuccess(message);
         
         assertThat( channel.content.text.numChildren, equals (1) );
         
         // MChatMessageProcessor must return MChatMessage to the pool
         assertThat( MCHAT.messagePool, hasProperties({
            "numActive": 0,
            "numIdle": 1
         }));
      };
   }
}