package tests.chat.models.message
{
   import ext.hamcrest.object.equals;
   
   import models.chat.MChat;
   import models.chat.MChatChannel;
   import models.chat.MChatMessage;
   import models.chat.MChatMessageProcessor;
   import models.chat.message.converters.BaseMessageConverter;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperties;
   
   import utils.SingletonFactory;

   public class TCMChatMessageProcessor
   {
      private var channel:MChatChannel;
      private var processor:MChatMessageProcessor;
      private var message:MChatMessage;
      
      
      private function get MCHAT() : MChat
      {
         return MChat.getInstance();
      }
      
      
      [Before]
      public function setUp() : void
      {
         message = new MChatMessage();
         message.time = new Date();
         message.playerId = 1;
         message.playerName = "mikism";
         message.message = "I'm tired";
         message.converter = new BaseMessageConverter();
      };
      
      
      [After]
      public function tearDown() : void
      {
         processor = null;
         channel = null;
         message = null;
         SingletonFactory.clearAllSingletonInstances();
      };
      
      
      [Test]
      public function when_received_new_message_should_add_it_to_channel_content() : void
      {
         processor = new MChatMessageProcessor();
         channel = createChannel(processor);
         
         processor.receiveMessage(message);
         assertThat( channel.content.text.numChildren, equals (1) );
         
         // MChatMessageProcessor must return MChatMessage to the pool
         assertThat( MCHAT.messagePool, hasProperties({
            "numActive": 0,
            "numIdle": 1
         }));
      } 
      
         
      private function createChannel(processor:MChatMessageProcessor) : MChatChannel
      {
         return new MChatChannel(processor);
      }
   }
}