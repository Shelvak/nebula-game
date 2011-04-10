package tests.chat.models.chat
{
   import ext.hamcrest.object.equals;
   
   import models.player.Player;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.core.allOf;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   
   
   
   public class TCMChat_closeChannel extends TCBaseMChat
   {
      public function TCMChat_closeChannel()
      {
         super();
      };
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         ML.player = new Player();
         ML.player.id = 1;
         ML.player.name = "mikism";
         chat.initialize(
            {
               "1": "mikism",
               "2": "jho",
               "3": "arturaz",
               "4": "tommy",
               "5": "pacifist"
            },
            {
               "galaxy": [1, 2, 3, 4, 5],
               "alliance": [1, 2, 4]
            }
         );
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
      };
      
      
      [Test]
      public function should_not_remove_public_channel_and_ignore() : void
      {
         chat.closePrivateChannel("galaxy");
         assertThat( chat.channels, arrayWithSize (2) );
      };
      
      
      [Test]
      public function should_remove_private_channel() : void
      {
         chat.openPrivateChannel(2);
         chat.selectChannel("galaxy");
         assertThat( chat.channels, arrayWithSize (3) );
         
         chat.closePrivateChannel("jho");
         
         assertThat( chat.channels, arrayWithSize (2) );
         assertThat( chat.channels.getChannel("jho"), nullValue() );
      };
      
      
      [Test]
      public function should_select_next_channel_when_selected_channel_is_closed() : void
      {
         chat.openPrivateChannel(2);   // jho
         chat.openPrivateChannel(3);   // arturaz
         chat.selectChannel("jho");
         
         chat.closePrivateChannel("jho");
         
         assertThat( chat.channels, arrayWithSize (3) );
         assertThat( chat.selectedChannel, notNullValue() );
         assertThat( chat.selectedChannel.name, equals ("arturaz") );
      };
      
      
      [Test]
      public function should_select_last_channel_when_last_channel_was_selected_and_then_closed() : void
      {
         chat.openPrivateChannel(2);   // jho
         
         chat.closePrivateChannel("jho");
         
         assertThat( chat.channels, arrayWithSize (2) );
         assertThat( chat.selectedChannel, notNullValue() );
         assertThat( chat.selectedChannel.name, equals ("alliance") );
      };
   }
}