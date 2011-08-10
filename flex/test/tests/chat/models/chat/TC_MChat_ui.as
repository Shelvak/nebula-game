package tests.chat.models.chat
{
   import ext.hamcrest.object.equals;
   
   import models.chat.MChat;
   import models.chat.MChatChannel;
   import models.chat.MChatMessage;
   import models.chat.events.MChatEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.text.startsWith;
   
   
   public class TC_MChat_ui extends TC_BaseMChat
   {
      public function TC_MChat_ui()
      {
         super();
      };
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         ML.player.reset();
         ML.player.id = 1;
         ML.player.name = "mikism";
         chat.initialize(
            {
               "1": ML.player.name
            },
            {
               "galaxy": [1],
               "alliance-1": [],
               "noobs": []
            }
         );
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
         chat.selectChannel("alliance-1");
         var channelAlliance:MChatChannel = chat.selectedChannel;
         
         assertThat( channelGalaxy.visible, isFalse() );
         assertThat( channelAlliance.visible, isTrue() );
      };
      
      
      [Test]
      public function when_chat_is_not_visible_and_another_chan_is_selected_both_chans_should_remain_invisible() : void
      {
         chat.screenHideHandler();
         var channelGalaxy:MChatChannel = chat.selectedChannel;
         chat.selectChannel("alliance-1");
         var channelAlliance:MChatChannel = chat.selectedChannel;
         
         assertThat( channelGalaxy.visible, isFalse() );
         assertThat( channelAlliance.visible, isFalse() );
      };
      
      
      [Test]
      public function should_select_main_channel() : void
      {
         chat.selectChannel("noobs");
         chat.selectMainChannel();
         
         assertThat( chat.selectedChannel, notNullValue() );
         assertThat( chat.selectedChannel.name, equals (MChat.MAIN_CHANNEL_NAME) );
      };
      
      
      [Test]
      public function should_select_alliance_channel() : void
      {
         chat.selectAllianceChannel();
         
         assertThat( chat.selectedChannel, notNullValue() );
         assertThat( chat.selectedChannel.name, startsWith(MChat.ALLIANCE_CHANNEL_PREFIX) );
      };
      
      
      [Test]
      public function selectAllianceChannel_should_do_nothing_if_there_is_no_alliance_channel_open() : void
      {
         chat.channels.removeChannel(chat.channels.getChannel("alliance-1"));
         chat.selectAllianceChannel();
         
         assertThat( chat.selectedChannel, notNullValue() );
         assertThat( chat.selectedChannel.name, equals (MChat.MAIN_CHANNEL_NAME) );
      };
      
      
      [Test]
      public function should_select_first_private_channel_with_unread_messages() : void
      {
         chat.visible = true;
         chat.receivePrivateMessage(makePrivateMessage(2, "jho", "Go to hell!"));
         chat.receivePrivateMessage(makePrivateMessage(3, "arturaz", "Git it back"));
         chat.selectChannel("jho");
         chat.selectChannel(MChat.MAIN_CHANNEL_NAME);
         
         chat.selectFirstPrivateChannel();
         
         assertThat( chat.selectedChannel, notNullValue() );
         assertThat( chat.selectedChannel.name, equals ("arturaz") );
      };
      
      
      [Test]
      public function should_select_first_private_channel_if_none_have_unread_messages() : void
      {
         chat.visible = true;
         chat.receivePrivateMessage(makePrivateMessage(2, "jho", "Go to hell!"));
         chat.receivePrivateMessage(makePrivateMessage(3, "arturaz", "Git it back"));
         chat.selectChannel("jho");
         chat.selectChannel("arturaz");
         chat.selectChannel(MChat.MAIN_CHANNEL_NAME);
         
         chat.selectFirstPrivateChannel();
         
         assertThat( chat.selectedChannel, notNullValue() );
         assertThat( chat.selectedChannel.name, equals ("jho") );
      };
      
      
      [Test]
      public function selectFirstPrivateChannel_should_do_nothing_if_there_is_no_private_channel_open() : void
      {
         chat.visible = true;
         chat.selectFirstPrivateChannel();
         
         assertThat( chat.selectedChannel, notNullValue() );
         assertThat( chat.selectedChannel.name, equals (MChat.MAIN_CHANNEL_NAME) );
      };
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function makePrivateMessage(playerId:int, playerName:String, message:String) : MChatMessage
      {
         var msg:MChatMessage = MChatMessage(chat.messagePool.borrowObject());
         msg.playerId = playerId;
         msg.playerName = playerName;
         msg.message = message;
         return msg;
      }
   }
}