package tests.chat.models.chat
{
   import ext.hamcrest.object.equals;

   import models.chat.MChatMember;
   import models.chat.MChatMessage;
   import models.chat.events.MChatEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.nullValue;

   import tests.chat.classes.IChatJSCallbacksInvokerMock;


   public class TC_MChat_hasUnreadAllianceMsg extends TC_BaseMChat
   {
      private var jsCallbacksInvoker: IChatJSCallbacksInvokerMock;

      [Before]
      public override function setUp(): void {
         super.setUp();
         ML.player.reset();
         ML.player.id = 1;
         ML.player.name = "mikism";
         jsCallbacksInvoker = new IChatJSCallbacksInvokerMock();
         chat.initialize(
            jsCallbacksInvoker,
            {
               "1": ML.player.name
            },
            {
               "galaxy":     [1],
               "alliance-1": [],
               "noobs":      []
            }
         );
      }
      
      
      [Test]
      public function should_not_have_unread_alliance_message_if_alliance_channel_is_not_open(): void {
         chat.channelJoin("alliance-1", chat.members.getMember(ML.player.id));
         chat.channelLeave("alliance-1", ML.player.id);
         assertThat( chat.hasUnreadAllianceMsg, isFalse() );
      }

      [Test]
      public function should_not_have_unread_alliance_message_if_alliance_channel_does_not_have_unread_messages(): void {
         chat.visible = true;
         chat.selectAllianceChannel();
         assertThat( chat.hasUnreadAllianceMsg, isFalse() );
      }

      [Test]
      public function should_not_have_unread_alliance_message_when_received_message_and_channel_is_visible() : void {
         chat.visible = true;
         chat.selectAllianceChannel();
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hey!", null));
         assertThat(chat.hasUnreadAllianceMsg, isFalse());
      }

      [Test]
      public function should_have_unread_alliance_message_when_received_message_and_channel_is_invisible(): void {
         chat.visible = false;
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hey!", null));
         assertThat( chat.hasUnreadAllianceMsg, isTrue() );
      }

      [Test]
      public function should_not_have_unread_alliance_message_when_channel_becomes_visible(): void {
         chat.visible = true;
         chat.selectMainChannel();
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         
         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hey!", null));
         assertThat( chat.hasUnreadAllianceMsg, isTrue() );
         
         chat.selectAllianceChannel();
         assertThat( chat.hasUnreadAllianceMsg, isFalse() );
      }

      [Test]
      public function should_not_have_unread_ally_msg_when_chat_becomes_visible(): void {
         chat.visible = false;
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         chat.selectAllianceChannel();
         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hey!", null));
         chat.visible = true;
         assertThat( chat.hasUnreadAllianceMsg, isFalse() );
      }

      [Test]
      public function should_dispatch_HAS_UNREAD_ALLIANCE_MSG_event_when_hasUnreadAllianceMsg_changes(): void {
         var eventDispatched: Boolean;
         chat.addEventListener(
            MChatEvent.HAS_UNREAD_ALLIANCE_MSG_CHANGE,
            function (event: MChatEvent): void {
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
      }

      [Test]
      public function numUnreadAllianceMessages_channelNotOpen(): void {
         chat.visible = true;
         chat.channelJoin("alliance-1", chat.members.getMember(ML.player.id));
         chat.channelLeave("alliance-1", ML.player.id);
         assertThat(
            "should not have unread alliance messages",
            chat.numUnreadAllianceMessages, equals (0)
         );
      }

      [Test]
      public function numUnreadAllianceMessages_channelOpenAndVisible(): void {
         chat.visible = true;
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         chat.selectAllianceChannel();
         assertThat(
            "should not have unread alliance messages at start",
            chat.numUnreadAllianceMessages, equals (0)
         );

         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hi", null));
         assertThat(
            "should not increment unread alliance messages counter "
               + "when new message is received",
            chat.numUnreadAllianceMessages, equals (0)
         );
      }

      [Test]
      public function numUnreadAllianceMessages_channelNotVisible(): void {
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         assertThat(
            "should not have unread alliance messages at start",
            chat.numUnreadAllianceMessages, equals (0)
         );

         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hi", null));
         assertThat(
            "should increment unread alliance messages counter "
               + "when new message is received",
            chat.numUnreadAllianceMessages, equals (1)
         );
      }

      [Test]
      public function numUnreadAllianceMessages_afterClosingChannel(): void {
         chat.visible = false;
         chat.channelJoin("alliance-1", chat.members.getMember(ML.player.id));
         chat.receivePublicMessage(
            makeMessage(ML.player.id, ML.player.name, "alliance-1", "test", null)
         );
         chat.channelLeave("alliance-1", ML.player.id);
         assertThat(
            "should not have unread alliance messages",
            chat.numUnreadAllianceMessages, equals (0)
         );
      }

      [Test]
      public function numUnreadAllianceMessages_afterChatBecomesVisible(): void {
         chat.visible = false;
         chat.selectAllianceChannel();
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hi", null));
         chat.visible = true;
         assertThat(
            "should not have unread alliance messages",
            chat.numUnreadAllianceMessages, equals (0)
         );
      }

      [Test]
      public function numUnreadAllianceMessages_afterChannelIsSelected(): void {
         chat.visible = true;
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         chat.receivePublicMessage(makeMessage(2, "jho", "alliance-1", "Hi", null));
         chat.selectAllianceChannel();
         assertThat(
            "should not have unread alliance messages",
            chat.numUnreadAllianceMessages, equals (0)
         );
      }

      [Test]
      public function IChatJSCallbacksInvokerUsage(): void {
         chat.visible = false;
         chat.channelJoin("alliance-1", makeMember(2, "jho"));
         chat.selectMainChannel();
         jsCallbacksInvoker.reset();

         function assertTitleParam(numMessages: int): void {
            assertThat(
               "hasUnreadAllianceMessages() param title",
               jsCallbacksInvoker.hasUnreadAllianceMessagesParam,
               equals (numMessages + " alliance messages")
            );
            assertThat(
               "allianceMessagesRead() not called",
               jsCallbacksInvoker.allianceMessagesReadCalled, isFalse()
            );
            jsCallbacksInvoker.reset();
         }

         function receiveMessage(): void {
            chat.receivePublicMessage(
               makeMessage(2, "jho", "alliance-1", "test", null)
            );
         }

         receiveMessage();
         assertTitleParam(1);

         receiveMessage();
         assertTitleParam(2);

         chat.selectAllianceChannel();
         chat.visible = true;
         assertThat(
            "should not call hasUnreadAllianceMessages()",
            jsCallbacksInvoker.hasUnreadAllianceMessagesParam, nullValue()
         );
         assertThat(
            "should have called allianceMessagesRead()",
            jsCallbacksInvoker.allianceMessagesReadCalled, isTrue()
         );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function makeMember(id: int, name: String): MChatMember {
         const member: MChatMember = new MChatMember();
         member.id = id;
         member.name = name;
         return member;
      }

      private function makeMessage(playerId: int,
                                   playerName: String,
                                   channel: String,
                                   message: String,
                                   time: Date): MChatMessage {
         const msg: MChatMessage = MChatMessage(chat.messagePool.borrowObject());
         msg.playerId = playerId;
         msg.playerName = playerName;
         msg.message = message;
         msg.channel = channel;
         msg.time = time;
         return msg;
      }
   }
}