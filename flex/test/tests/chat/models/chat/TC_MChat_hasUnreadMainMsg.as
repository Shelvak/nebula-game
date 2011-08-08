package tests.chat.models.chat
{
   import ext.hamcrest.events.causesTarget;
   
   import models.chat.MChat;
   import models.chat.MChatMember;
   import models.chat.MChatMessage;
   import models.chat.events.MChatEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   public class TC_MChat_hasUnreadMainMsg extends TC_BaseMChat
   {
      public function TC_MChat_hasUnreadMainMsg() {
         super();
      }
      
      
      [Before]
      public override function setUp() : void {
         super.setUp();
         ML.player.reset();
         ML.player.id = 1;
         ML.player.name = "mikism";
         chat.initialize(
            {"1": ML.player.name, "2": "jho"},
            {(String(MChat.MAIN_CHANNEL_NAME)): [1], "alliance-1": [], "noobs": []}
         );
      };
      
      
      [Test]
      public function should_not_have_unread_main_msg_if_there_are_no_unread_msgs_in_main_chan() : void {
         chat.visible = true;
         assertThat( chat.hasUnreadMainMsg, isFalse() );
      };
      
      [Test]
      public function should_not_have_unread_main_msg_when_msg_is_received_and_chat_and_main_chan_is_visible() : void {
         chat.visible = true;
         chat.receivePublicMessage(makeMessage(2, "jho", MChat.MAIN_CHANNEL_NAME, "Hey!", null));
         assertThat( chat.hasUnreadMainMsg, isFalse() );
      };
      
      [Test]
      public function should_have_unread_main_msg_when_msg_is_received_and_chat_is_not_visible() : void {
         chat.visible = false;
         chat.receivePublicMessage(makeMessage(2, "jho", MChat.MAIN_CHANNEL_NAME, "Hey!", null));
         assertThat( chat.hasUnreadMainMsg, isTrue() );
      };
      
      [Test]
      public function should_have_unread_main_msg_when_msg_is_received_and_main_chan_is_not_visible() : void {
         chat.visible = true;
         chat.selectAllianceChannel();
         chat.receivePublicMessage(makeMessage(2, "jho", MChat.MAIN_CHANNEL_NAME, "Hey!", null));
         assertThat( chat.hasUnreadMainMsg, isTrue() );
      };
      
      [Test]
      public function should_not_have_unread_main_msg_when_main_chan_becomes_visible() : void {
         chat.visible = false;
         chat.receivePublicMessage(makeMessage(2, "jho", MChat.MAIN_CHANNEL_NAME, "Hey!", null));
         assertThat( chat.hasUnreadMainMsg, isTrue() );
         chat.visible = true;
         assertThat( chat.hasUnreadMainMsg, isFalse() );
         
         chat.selectAllianceChannel();
         chat.receivePublicMessage(makeMessage(2, "jho", MChat.MAIN_CHANNEL_NAME, "Hello!", null));
         assertThat( chat.hasUnreadMainMsg, isTrue() );
         chat.selectMainChannel();
         assertThat( chat.hasUnreadMainMsg, isFalse() );
      };
      
      [Test]
      public function should_dispatch_HAS_UNREAD_MAIN_MSG_CHANGE_event_when_hasUnreadMainMsg_property_changes() : void {
         chat.channelJoin(MChat.MAIN_CHANNEL_NAME, makeMember(2, "jho"));
         chat.visible = false;
         
         assertThat(
            function():void{ chat.receivePublicMessage(makeMessage(2, "jho", MChat.MAIN_CHANNEL_NAME, "Hey!", null)) },
            causesTarget (chat) .toDispatchEvent (MChatEvent.HAS_UNREAD_MAIN_MSG_CHANGE)
         );
         
         assertThat(
            function():void{ chat.visible = true },
            causesTarget (chat) .toDispatchEvent (MChatEvent.HAS_UNREAD_MAIN_MSG_CHANGE)
         );
      };
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function makeMember(id:int, name:String) : MChatMember {
         var member:MChatMember = new MChatMember();
         member.id = id;
         member.name = name;
         return member;
      }
      
      private function makeMessage(playerId:int,
                                   playerName:String,
                                   channel:String,
                                   message:String,
                                   time:Date) : MChatMessage {
         var msg:MChatMessage = MChatMessage(chat.messagePool.borrowObject());
         msg.playerId = playerId;
         msg.playerName = playerName;
         msg.message = message;
         msg.channel = channel;
         msg.time = time;
         return msg;
      }
   }
}