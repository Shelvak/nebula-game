package tests.chat.models.chat
{
   import ext.hamcrest.object.equals;

   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.elements.TextFlow;

   import models.chat.MChatMessage;
   import models.player.PlayerOptions;

   import org.flexunit.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;


   public class TC_MChat_ignoredMembers extends TC_BaseMChat
   {
      [Before]
      public override function setUp(): void {
         super.setUp();
         ML.player.id = 1;
         ML.player.name = "player";
      }

      [Test]
      public function shouldMarkIgnoredPlayersWhenInitialized(): void {
         PlayerOptions.addIgnoredPlayer("ignored");
         chat.initialize(
            {"1": "player", "2": "normal", "3": "ignored"},
            {"galaxy": [1, 2, 3]}
         );
         assertThat( "'normal' should not be ignored", getIgnored(2), isFalse() );
         assertThat( "'ignored' should be ignored", getIgnored(3), isTrue() );
      }

      [Test]
      public function offlineMemberCreationShouldDependOnItsIgnoreStatus(): void {
         const name: String = "test";
         PlayerOptions.addIgnoredPlayer(name);
         chat.initialize({"1": "player"}, {"galaxy": [1]});

         ignoreComplete();
         chat.openPrivateChannel(2, name);
         assertThat(
            "should not create member if it is offline and ignored completely",
            chat.members.getMember(2), nullValue()
         );
         assertThat(
            "should not open private channel if member is offline and ignored completely",
            chat.channels.containsChannel(name), isFalse()
         );

         ignoreFiltered();
         chat.openPrivateChannel(2, name);
         assertThat(
            "should create member if it is offline and filtered-ignored",
            chat.members.getMember(2), notNullValue()
         );
         assertThat(
            "should open private channel if member is offline and filtered-ignored",
            chat.channels.containsChannel(name), isTrue()
         );
      }

      [Test]
      public function openingPrivateChannelShouldDependOnMemberIgnoreStatus(): void {
         const name: String = "test";
         PlayerOptions.addIgnoredPlayer(name);
         chat.initialize({"1": "player", "2": name}, {"galaxy": [1, 2]});

         ignoreComplete();
         chat.openPrivateChannel(2);
         assertThat(
            "should not open private channel when IGNORE_TYPE_COMPLETE",
            chat.channels.containsChannel(name), isFalse()
         );

         ignoreFiltered();
         chat.openPrivateChannel(2);
         assertThat(
            "should open private channel when IGNORE_TYPE_FILTERED",
            chat.channels.containsChannel(name), isTrue()
         );
      }

      [Test]
      public function receiveMessageFiltersMessagesFromIgnoredPlayers(): void {
         const nameOnline: String = "testOnline";
         const nameOffline: String = "testOffline";
         const idOnline: int = 2;
         const idOffline: int = 3;
         PlayerOptions.addIgnoredPlayer(nameOnline);
         PlayerOptions.addIgnoredPlayer(nameOffline);
         chat.initialize(
            {"1": "player", "2": nameOnline},
            {"galaxy": [1, idOnline]}
         );

         function getChannelText(channel:String): TextFlow {
            return chat.channels.getChannel(channel).content.text;
         }

         function getTextOfFirstMessage(channel: String): String {
            return SpanElement(ParagraphElement(
               getChannelText(channel).getChildAt(0)).getChildAt(2)
            ).text;
         }

         ignoreComplete();
         chat.receivePublicMessage(newMessage(idOnline, nameOnline, "galaxy", "Hi!"));
         assertThat(
            "should not process public messages from completely ignored player",
            getChannelText("galaxy").numChildren, equals (0)
         );
         chat.receivePrivateMessage(newMessage(idOnline, nameOnline, nameOnline, "Hi!"));
         assertThat(
            "should not open private channel for completely ignored player",
            chat.channels.containsChannel(nameOnline), isFalse()
         );
         chat.receivePrivateMessage(newMessage(idOffline, nameOffline, nameOffline, "Hi!"));
         assertThat(
            "should not open private channel for completely ignored offline player",
            chat.channels.containsChannel(nameOffline), isFalse()
         );
         assertThat(
            "should not create MChatMember instance for completely offline player",
            chat.members.getMember(idOffline), nullValue()
         );

         ignoreFiltered();
         chat.receivePublicMessage(newMessage(idOnline, nameOnline, "galaxy", "Hi!"));
         assertThat(
            "should modify text of public message received from filtered-ignored player",
            getTextOfFirstMessage("galaxy"),
            equals ("ignored")
         );
         chat.receivePrivateMessage(newMessage(idOnline, nameOnline, nameOnline, "Hi!"));
         assertThat(
            "should open private channel for filtered-ignore online player",
            chat.channels.containsChannel (nameOnline), isTrue()
         );
         assertThat(
            "should modify text of private message received from filtered-ignored online player",
            getTextOfFirstMessage(nameOnline), equals ("ignored")
         );
         chat.receivePrivateMessage(newMessage(idOffline, nameOffline, nameOffline, "Hi"));
         assertThat(
            "should open private channel for filtered-ignored offline player",
            chat.channels.containsChannel (nameOffline), isTrue()
         );
         assertThat(
            "should modify text of private message received from filtered-ignored offline player",
            getTextOfFirstMessage(nameOffline), equals("ignored")
         );
      }

      [Test]
      public function updatesMemberInstancesWhenIgnoreStatusChanges(): void {
         const name:String = "test";
         chat.initialize({"2": name}, {"galaxy": [2]});

         PlayerOptions.addIgnoredPlayer(name);
         assertThat(
            "should mark '" + name + "' as ignored",
            chat.members.getMember(2).isIgnored, isTrue()
         );

         PlayerOptions.removeIgnoredPlayer(name);
         assertThat(
            "should mark '" + name + "' as not ignored",
            chat.members.getMember(2).isIgnored, isFalse()
         );
      }

      [Test]
      public function addingOfflineMembersToAndRemovingFromIgnoreListDoesNotCauseErrors(): void {
         chat.initialize({"1": ML.player.name}, {"galaxy": [ML.player.id]});
         PlayerOptions.addIgnoredPlayer("notInChat");
         PlayerOptions.removeIgnoredPlayer("notInChat");
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function newMessage(playerId: int,
                                  playerName: String,
                                  channel: String,
                                  message: String): MChatMessage {
         const msg: MChatMessage = new MChatMessage();
         msg.playerId = playerId;
         msg.playerName = playerName;
         msg.channel = channel;
         msg.message = message;
         msg.time = new Date();
         return msg;
      }

      private function ignoreComplete(): void {
         setIgnoreType(PlayerOptions.IGNORE_TYPE_COMPLETE);
      }

      private function ignoreFiltered(): void {
         setIgnoreType(PlayerOptions.IGNORE_TYPE_FILTERED);
      }

      private function setIgnoreType(type: String): void {
         PlayerOptions.chatIgnoreType = type;
      }

      private function getIgnored(memberId: int): Boolean {
         return chat.members.getMember(memberId).isIgnored;
      }
   }
}
