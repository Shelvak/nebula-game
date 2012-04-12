package tests.chat.models.chat
{
   import ext.hamcrest.object.equals;

   import models.chat.MChatMessage;
   import models.chat.events.MChatEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.nullValue;

   import tests.chat.classes.IChatJSCallbacksInvokerMock;


   public class TC_MChat_hasUnreadPrivateMsg extends TC_BaseMChat
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
      }

      [After]
      public override function tearDown(): void {
         super.tearDown();
         jsCallbacksInvoker = null;
      }

      [Test]
      public function should_not_have_unread_private_msg_if_there_is_no_private_chan_open(): void {
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      }

      [Test]
      public function should_not_have_unread_private_msg_if_none_of_private_chan_have_unread_messages(): void {
         openPrivateChannels(true);
         chat.selectMainChannel();
         
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      }

      [Test]
      public function should_not_have_unread_private_msg_when_received_msg_to_visible_chan(): void {
         chat.visible = true;
         chat.openPrivateChannel(2);   // jho
         chat.receivePrivateMessage(makePrivateMessage(2, null, "Hi!"));
         
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      }

      [Test]
      public function should_have_unread_private_msg_when_received_msg_to_invisible_chan(): void {
         openPrivateChannels();
         chat.visible = true;
         
         // should be unread msg in "jho"
         assertThat( chat.hasUnreadPrivateMsg, isTrue() );
      }

      [Test]
      public function should_not_have_unread_private_msg_when_chan_becomes_visible_and_others_do_not_have_unread_msgs(): void {
         openPrivateChannels();
         chat.visible = true;
         chat.selectMainChannel();
         chat.selectChannel("jho");
         
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      }

      [Test]
      public function should_have_unread_private_msg_when_chan_becomes_visible_and_other_chan_has_unread_msg(): void {
         openPrivateChannels();
         chat.selectMainChannel();
         chat.visible = true;
         chat.selectChannel("jho");
         
         // should be unread msg in "arturaz"
         assertThat( chat.hasUnreadPrivateMsg, isTrue() );
      }

      [Test]
      public function should_not_have_unread_msg_when_chan_is_closed_and_others_do_not_have_unread_msgs(): void {
         openPrivateChannels();
         chat.selectMainChannel();
         chat.visible = true;
         chat.selectChannel("jho");
         chat.closePrivateChannel("arturaz");
         
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      }

      [Test]
      public function should_have_unread_msg_when_chan_is_closed_and_another_chan_has_unread_msg(): void {
         openPrivateChannels();
         chat.selectMainChannel();
         chat.visible = true;
         chat.closePrivateChannel("arturaz");
         
         // should be unread msg in "jho"
         assertThat( chat.hasUnreadPrivateMsg, isTrue() );
      }

      [Test]
      public function should_not_have_unread_private_msg_when_chat_becomes_visible_and_other_chans_do_not_have_unread_msgs(): void {
         openPrivateChannels();
         chat.visible = true;
         // "jho" still has unread message
         chat.visible = false;
         chat.selectChannel("jho");
         chat.visible = true;
         
         assertThat( chat.hasUnreadPrivateMsg, isFalse() );
      }

      [Test]
      public function should_dispatch_HAS_UNREAD_PRIVATE_MSG_CHANGE_when_hasUnreadPrivateMsg_property_changes(): void {
         var eventDispatched: Boolean;
         chat.addEventListener(
            MChatEvent.HAS_UNREAD_PRIVATE_MSG_CHANGE,
            function (event: MChatEvent): void {
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
      }

      [Test]
      public function numUnreadPrivateMessages_messagesToExistingChannels(): void {
         openPrivateChannels(true);
         chat.visible = false;

         assertThat(
            "should not have any private messages",
            chat.numUnreadPrivateMessages, equals (0)
         );

         chat.receivePrivateMessage(makePrivateMessage(2, null, "Hi!"));
         chat.receivePrivateMessage(makePrivateMessage(3, null, "Hi!"));
         assertThat(
            "should have unread private messages",
            chat.numUnreadPrivateMessages, equals (2)
         );

         chat.visible = true;
         chat.selectChannel(chat.members.getMember(3).name);
         assertThat(
            "should have unread private message",
            chat.numUnreadPrivateMessages, equals (1)
         );
         chat.selectChannel(chat.members.getMember(2).name);
         assertThat(
            "should not have unread private messages when user viewed all "
               + "private channels",
            chat.numUnreadPrivateMessages, equals(0)
         );
      }

      [Test]
      public function numUnreadPrivateMessages_afterClosingPrivateChannels(): void {
         openPrivateChannels(false);

         chat.closePrivateChannel(chat.members.getMember(2).name);
         assertThat(
            "should decrement unread messages counter when invisible "
               + "channel is closed",
            chat.numUnreadPrivateMessages, equals (1)
         );
      }

      [Test]
      public function IChatJSCallbacksInvokerUsage(): void {
         chat.visible = false;
         chat.openPrivateChannel(2);
         chat.openPrivateChannel(3);
         jsCallbacksInvoker.reset();

         function assertTitleParam(numMessages: int): void {
            assertThat(
               "hasUnreadPrivateMessages() param title",
               jsCallbacksInvoker.hasUnreadPrivateMessagesParam,
               equals (numMessages + " private messages")
            );
            assertThat(
               "privateMessagesRead() not called",
               jsCallbacksInvoker.privateMessagesReadCalled, isFalse()
            );
            jsCallbacksInvoker.reset();
         }

         function receivePrivateMessage(memberId: int): void {
            chat.receivePrivateMessage(makePrivateMessage(memberId, null, "test"));
         }

         receivePrivateMessage(2);
         assertTitleParam(1);

         receivePrivateMessage(3);
         assertTitleParam(2);

         chat.selectChannel(chat.members.getMember(2).name);
         chat.visible = true;
         assertTitleParam(1);

         chat.selectChannel(chat.members.getMember(3).name);
         assertThat(
            "should not call hasUnreadPrivateMessages()",
            jsCallbacksInvoker.hasUnreadPrivateMessagesParam, nullValue()
         );
         assertThat(
            "should have called privateMessagesRead()",
            jsCallbacksInvoker.privateMessagesReadCalled, isTrue()
         );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function openPrivateChannels(whenChatVisible: Boolean = false): void {
         chat.visible = whenChatVisible;
         chat.openPrivateChannel(2);   // jho
         chat.receivePrivateMessage(makePrivateMessage(2, null, "Hi!"));
         chat.openPrivateChannel(3);   // arturaz
         chat.receivePrivateMessage(makePrivateMessage(3, null, "Hi!"));
      }

      private function makePrivateMessage(playerId: int,
                                          playerName: String,
                                          message: String): MChatMessage {
         const msg: MChatMessage = MChatMessage(chat.messagePool.borrowObject());
         msg.playerId = playerId;
         msg.playerName = playerName;
         msg.message = message;
         return msg;
      }
   }
}
