package tests.chat.models.chat
{
   import models.chat.MChatMember;
   import models.chat.MChatMessage;
   import models.chat.events.MChatEvent;
   import models.player.Player;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   
   
   public class TCMChat_hasUnreadAllianceMsg extends TCBaseMChat
   {
      public function TCMChat_hasUnreadAllianceMsg()
      {
         super();
      }
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         ML.player = new Player();
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
      public function should_not_have_unread_alliance_message_if_alliance_channel_is_not_open() : void
      {
         chat.channelJoin("alliance-1", chat.members.getMember(ML.player.id));
         chat.channelLeave("alliance-1", ML.player.id);
         
         assertThat( chat.hasUnreadAllianceMsg, isFalse() );
      };
      
      
      [Test]
      public function should_not_have_unread_alliance_messsage_if_alliance_channel_does_not_have_unread_messages() : void
      {
         chat.visible = true;
         chat.selectAllianceChannel();
         
         assertThat( chat.hasUnreadAllianceMsg, isFalse() );
      };
      
      
      [Test]
      public function should_not_have_unread_alliance_message_when_received_message_and_channel_is_visible() : void
      {
         chat.visible = true;
         chat.selectAllianceChannel();
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hey!", null));
         
         assertThat( chat.hasUnreadAllianceMsg, isFalse() );
      };
      
      
      [Test]
      public function should_have_unread_alliance_message_when_received_message_and_channel_is_invisible() : void
      {
         chat.visible = false;
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hey!", null));
         
         assertThat( chat.hasUnreadAllianceMsg, isTrue() );
      };
      
      
      [Test]
      public function should_not_have_unread_alliance_message_when_channel_becomes_visible() : void
      {
         chat.visible = true;
         chat.selectMainChannel();
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         
         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hey!", null));
         assertThat( chat.hasUnreadAllianceMsg, isTrue() );
         
         chat.selectAllianceChannel();
         assertThat( chat.hasUnreadAllianceMsg, isFalse() );
      };
      
      
      [Test]
      public function should_not_have_unread_ally_msg_when_chat_becomes_visible() : void
      {
         chat.visible = false;
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         chat.selectAllianceChannel()
         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hey!", null));
         chat.visible = true;
         
         assertThat( chat.hasUnreadAllianceMsg, isFalse() );
      };
      
      
      [Test]
      public function should_dispatch_HAS_UNREAD_ALLIANCE_MSG_event_when_hasUnreadAllianceMsg_changes() : void
      {
         var eventDispatched:Boolean;
         chat.addEventListener(
            MChatEvent.HAS_UNREAD_ALLIANCE_MSG_CHANGE,
            function(event:MChatEvent) : void
            {
               eventDispatched = true;
            }
         );
         
         chat.visible = true;
         chat.selectMainChannel();
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         
         eventDispatched = false;
         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hey!", null));
         assertThat( eventDispatched, isTrue() );
         
         eventDispatched = false;
         chat.selectAllianceChannel();
         assertThat( eventDispatched, isTrue() );
      };
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function makeMember(id:int, name:String) : MChatMember
      {
         var member:MChatMember = new MChatMember();
         member.id = id;
         member.name = name;
         return member;
      }
      
      
      private function makeMessage(playerId:int,
                                   playerName:String,
                                   channel:String,
                                   message:String,
                                   time:Date) : MChatMessage
      {
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