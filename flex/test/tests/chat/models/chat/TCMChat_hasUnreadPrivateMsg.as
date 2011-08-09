package tests.chat.models.chat
{
   import models.chat.MChatMessage;
   import models.chat.events.MChatEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   
   
   public class TCMChat_hasUnreadPrivateMsg extends TCBaseMChat
   {
      public function TCMChat_hasUnreadPrivateMsg()
      {
         super();
      }
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         ML.player.reset();
         ML.player.id = 1;
         ML.player.name = "mikism";
         chat.initialize(
            {
               "1": ML.player.name,
               "2": "jho",
               "3": "arturaz",
               "4": "tommy"
            },
            {
               "galaxy": [1, 2, 3, 4],
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
      public function should_not_have_unread_private_msg_if_there_is_no_private_chan_open() : void
      {
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      };
      
      
      [Test]
      public function should_not_have_unread_private_msg_if_none_of_private_chan_have_unread_messages() : void
      {
         openPrivateChannels(true);
         chat.selectMainChannel();
         
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      };
      
      
      [Test]
      public function should_not_have_unread_private_msg_when_received_msg_to_visible_chan() : void
      {
         chat.visible = true;
         chat.openPrivateChannel(2);   // jho
         chat.receivePrivateMessage(makePrivateMessage(2, null, "Hi!"));
         
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      };
      
      
      [Test]
      public function should_have_unread_private_msg_when_received_msg_to_invisible_chan() : void
      {
         openPrivateChannels();
         chat.visible = true;
         
         // should be unread msg in "jho"
         assertThat( chat.hasUnreadPrivateMsg, isTrue() );
      };
      
      
      [Test]
      public function should_not_have_unread_private_msg_when_chan_becomes_visible_and_others_do_not_have_unread_msgs() : void
      {
         openPrivateChannels();
         chat.visible = true;
         chat.selectMainChannel();
         chat.selectChannel("jho");
         
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      };
      
      
      [Test]
      public function should_have_unread_private_msg_when_chan_becomes_visible_and_other_chan_has_unread_msg() : void
      {
         openPrivateChannels();
         chat.selectMainChannel();
         chat.visible = true;
         chat.selectChannel("jho");
         
         // should be unread msg in "arturaz"
         assertThat( chat.hasUnreadPrivateMsg, isTrue() );
      };
      
      
      [Test]
      public function should_not_have_unread_msg_when_chan_is_closed_and_others_do_not_have_unread_msgs() : void
      {
         openPrivateChannels();
         chat.selectMainChannel();
         chat.visible = true;
         chat.selectChannel("jho");
         chat.closePrivateChannel("arturaz");
         
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      };
      
      
      [Test]
      public function should_have_unread_msg_when_chan_is_closed_and_another_chan_has_unread_msg() : void
      {
         openPrivateChannels();
         chat.selectMainChannel();
         chat.visible = true;
         chat.closePrivateChannel("arturaz");
         
         // should be unread msg in "jho"
         assertThat( chat.hasUnreadPrivateMsg, isTrue() );
      };
      
      
      [Test]
      public function should_not_have_unread_private_msg_when_chat_becomes_visible_and_other_chans_do_not_have_unread_msgs() : void
      {
         openPrivateChannels();
         chat.visible = true;
         // "jho" still has unread message
         chat.visible = false;
         chat.selectChannel("jho");
         chat.visible = true;
         
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      };
      
      
      [Test]
      public function should_dispatch_HAS_UNREAD_PRIVATE_MSG_CHANGE_when_hasUnreadPrivateMsg_property_changes() : void
      {
         var eventDispatched:Boolean;
         chat.addEventListener(
            MChatEvent.HAS_UNREAD_PRIVATE_MSG_CHANGE,
            function(event:MChatEvent) : void
            {
               eventDispatched = true;
            }
         );
         
         chat.visible = false;
         chat.openPrivateChannel(2);   // jho
         
         eventDispatched = false;
         chat.receivePrivateMessage(makePrivateMessage(2, null, "Hi!"));
         assertThat( eventDispatched, isTrue() );
         
         eventDispatched = false;
         chat.visible = true;
         assertThat( eventDispatched, isTrue() );
      };
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function openPrivateChannels(whenChatVisible:Boolean = false) : void
      {
         chat.visible = whenChatVisible;
         chat.openPrivateChannel(2);   // jho
         chat.receivePrivateMessage(makePrivateMessage(2, null, "Hi!"));
         chat.openPrivateChannel(3);   // arturaz
         chat.receivePrivateMessage(makePrivateMessage(3, null, "Hi!"));
      }
      
      
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