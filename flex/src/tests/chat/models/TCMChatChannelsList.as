package tests.chat.models
{
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatChannel;
   import models.chat.MChatChannelsList;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.throws;
   
   
   public class TCMChatChannelsList
   {
      private var channel:MChatChannel;
      private var list:MChatChannelsList;
      
      
      [Before]
      public function setUp() : void
      {
         channel = new MChatChannel("galaxy");
         list = new MChatChannelsList();
         list.addChannel(channel);
      };
      
      
      [After]
      public function tearDown() : void
      {
         channel = null;
         list = null;
      }
      
      
      [Test]
      public function should_add_channel_to_list() : void
      {
         assertThat( list, arrayWithSize (1) );
         assertThat( list, hasItem (channel) );
         assertThat( list.getChannel(channel.name), equals (channel) );
      };
      
      
      [Test]
      public function should_throw_error_if_channel_is_already_in_the_channel() : void
      {
         var clone:MChatChannel = cloneChannel(channel);
         
         assertThat( function():void{ list.addChannel(clone) }, throws (ArgumentError) );
      };
      
      
      [Test]
      public function should_remove_channel_from_list() : void
      {
         list.removeChannel(cloneChannel(channel));
         
         assertThat( list, arrayWithSize (0) );
      };
      
      
      [Test]
      public function should_throw_error_if_channel_to_remove_not_found() : void
      {
         assertThat(
            function():void{ list.removeChannel(new MChatChannel("alliance")) },
            throws (ArgumentError)
         );
      };
      
      
      private function cloneChannel(channel:MChatChannel) : MChatChannel
      {
         return new MChatChannel(channel.name);;
      }
   }
}