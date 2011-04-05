package tests.chat.models.channel
{
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatChannel;
   import models.chat.message.processors.ChatMessageProcessor;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.object.notNullValue;
   
   
   public class TCMChatChannel_initialization extends TCBaseMChatChannel
   {
      public function TCMChatChannel_initialization()
      {
         super();
      };
      
      
      [Test]
      public function should_instantiate_internal_objects_and_lists() : void
      {
         var processor:ChatMessageProcessor = new ChatMessageProcessor();
         channel = new MChatChannel("galaxy", processor);
         
         assertThat( channel.name, equals ("galaxy") );
         
         assertThat( channel.content, notNullValue() );
         
         assertThat( processor.channel, equals (channel) );
         
         assertThat( channel.members, notNullValue() );
         assertThat( channel.members, arrayWithSize(0) );
      };
   }
}