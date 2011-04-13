package tests.chat.models.chat
{
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatChannel;
   import models.chat.events.MChatEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperty;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   
   
   public class TCMChat_ui extends TCBaseMChat
   {
      public function TCMChat_ui()
      {
         super();
      };
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         chat.initialize({}, {"galaxy": [], "alliance": [], "noobs": []});
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
      };
      
      
      [Test]
      public function should_select_given_channel() : void
      {
         chat.selectChannel("noobs");
         
         assertThat( chat.selectedChannel, chat.channels.getChannel("noobs") );
      };
      
      
      [Test]
      public function should_do_nothing_when_trying_to_select_already_selected_channel() : void
      {
         chat.selectChannel("noobs");
         chat.selectChannel("noobs");
         
         assertThat( chat.selectedChannel, chat.channels.getChannel("noobs") );
      };
      
      
      [Test]
      public function should_dispatch_SLECTED_CHANNEL_CHANGE_event_when_selected_another_channel() : void
      {
         var eventDispatched:Boolean = false;
         chat.addEventListener(
            MChatEvent.SELECTED_CHANNEL_CHANGE,
            function(event:MChatEvent) : void
            {
               eventDispatched = true;
            }
         );
         chat.selectChannel("noobs");
         
         assertThat( eventDispatched, isTrue() );
      };
      
      
      [Test]
      public function should_be_visible_after_chat_has_been_shown() : void
      {
         chat.visible = false;
         chat.screenShowHandler();
         
         assertThat( chat.visible, isTrue() );
      };
      
      
      [Test]
      public function should_not_be_visible_after_chat_has_been_hidden() : void
      {
         chat.visible = true;
         chat.screenHideHandler();
         assertThat( chat.visible, isFalse() );
      };
      
      
      [Test]
      public function when_chat_is_shown_selected_channel_should_be_visible() : void
      {
         chat.visible = false;
         chat.screenShowHandler();
         
         assertThat(chat.selectedChannel.visible, isTrue() );
      };
      
      
      [Test]
      public function when_chat_is_hidden_selected_channel_should_not_be_visible() : void
      {
         chat.visible = true;
         chat.selectedChannel.visible = true;
         chat.screenHideHandler();
         
         assertThat( chat.selectedChannel.visible, isFalse() );
      };
      
      
      [Test]
      public function when_chat_is_visible_and_another_chan_is_selected_old_should_become_invisible_and_new_visible() : void
      {
         chat.screenShowHandler();
         var channelGalaxy:MChatChannel = chat.selectedChannel;
         chat.selectChannel("alliance");
         var channelAlliance:MChatChannel = chat.selectedChannel;
         
         assertThat( channelGalaxy.visible, isFalse() );
         assertThat( channelAlliance.visible, isTrue() );
      };
      
      
      [Test]
      public function when_chat_is_not_visible_and_another_chan_is_selected_both_channels_should_remain_invisible() : void
      {
         chat.screenHideHandler();
         var channelGalaxy:MChatChannel = chat.selectedChannel;
         chat.selectChannel("alliance");
         var channelAlliance:MChatChannel = chat.selectedChannel;
         
         assertThat( channelGalaxy.visible, isFalse() );
         assertThat( channelAlliance.visible, isFalse() );
      };
   }
}