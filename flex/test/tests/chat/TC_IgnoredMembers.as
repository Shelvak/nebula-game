package tests.chat
{
   import controllers.playeroptions.PlayerOptionsCommand;

   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.causesGlobalEvent;
   import ext.hamcrest.object.equals;

   import models.chat.IgnoredMembers;
   import models.chat.events.IgnoredMembersEvent;
   import models.player.PlayerOptions;

   import org.flexunit.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;


   public class TC_IgnoredMembers
   {
      private static const IGNORED: String = "ignored";

      private var ignoredMembers: IgnoredMembers;

      [Before]
      public function setUp(): void {
         PlayerOptions.loadOptions({"ignoredChatPlayers": []});
         PlayerOptions.addIgnoredPlayer(IGNORED);
         ignoredMembers = new IgnoredMembers();
      }

      [After]
      public function tearDown(): void {
         PlayerOptions.ignoredPlayersDataProvider.removeAll();
         ignoredMembers = null;
      }

      [Test]
      public function isIgnored(): void {
         assertThat(
            "member in a backing list should be ignored",
            ignoredMembers.isIgnored(IGNORED), isTrue()
         );
         assertThat(
            "member not in backing list should not be ignored",
            ignoredMembers.isIgnored("test"), isFalse()
         );
      }

      [Test]
      public function isCompletelyOrFilteredIgnored_ignored(): void {
         PlayerOptions.chatIgnoreType = PlayerOptions.IGNORE_TYPE_COMPLETE;
         assertThat(
            "member should be completely ignored when IGNORE_TYPE_COMPLETE",
            ignoredMembers.isCompleteIgnored(IGNORED), isTrue()
         );
         assertThat(
            "member should not be filtered ignored when IGNORE_TYPE_COMPLETE",
            ignoredMembers.isFilteredIgnored(IGNORED), isFalse()
         );

         PlayerOptions.chatIgnoreType = PlayerOptions.IGNORE_TYPE_FILTERED;
         assertThat(
            "member should not be completely ignored when IGNORE_TYPE_FILTERED",
            ignoredMembers.isCompleteIgnored(IGNORED), isFalse()
         );
         assertThat(
            "member should be filtered ignored when IGNORE_TYPE_FILTERED",
            ignoredMembers.isFilteredIgnored(IGNORED), isTrue()
         );
      }

      [Test]
      public function isCompletelyOrFilteredIgnored_notIgnored(): void {
         const name:String = "notIgnored";

         PlayerOptions.chatIgnoreType = PlayerOptions.IGNORE_TYPE_COMPLETE;
         assertThat(
            "member should not be completely ignored "
               + "when IGNORE_TYPE_COMPLETE but he is not ignored",
            ignoredMembers.isCompleteIgnored(name), isFalse()
         );
         assertThat(
            "member should not be filtered ignored when "
               + "IGNORE_TYPE_COMPLETE but he is not ignored",
            ignoredMembers.isFilteredIgnored(name), isFalse()
         );

         PlayerOptions.chatIgnoreType = PlayerOptions.IGNORE_TYPE_FILTERED;
         assertThat(
            "member should not be completely ignored when "
               + "IGNORE_TYPE_FILTERED but he is not ignored",
            ignoredMembers.isCompleteIgnored(name), isFalse()
         );
         assertThat(
            "member should not be filtered ignored when "
               + "IGNORE_TYPE_FILTERED but he is not ignored",
            ignoredMembers.isFilteredIgnored(name), isFalse()
         );
      }

      [Test]
      public function addToIgnoreList(): void {
         const nameA: String = "playerA";
         assertThat(
            function(): void { ignoredMembers.addToIgnoreList(nameA) },
            causesGlobalEvent(
               PlayerOptionsCommand.SET,
               function(cmd: PlayerOptionsCommand): void {
                  assertThat(
                     "'" + nameA + "' should be ignored",
                     ignoredMembers.isIgnored(nameA), isTrue()
                  );
               }
            )
         );

         const nameB: String = "playerB";
         assertThat(
            function(): void { ignoredMembers.addToIgnoreList(nameB) },
            causes (ignoredMembers) .toDispatchEvent(
               IgnoredMembersEvent.ADD_TO_IGNORE,
               function (event: IgnoredMembersEvent): void {
                  assertThat(
                     "event.member", event.memberName, equals(nameB)
                  );
               }
            )
         );
      }

      [Test]
      public function removeFromIgnoreList(): void {
         assertThat(
            function():void{ ignoredMembers.removeFromIgnoreList(IGNORED) },
            causesGlobalEvent(
               PlayerOptionsCommand.SET,
               function(cmd: PlayerOptionsCommand): void {
                  assertThat(
                     "'" + IGNORED + "' should not be ignored",
                     ignoredMembers.isIgnored(IGNORED), isFalse()
                  );
               }
            )
         );

         const name:String = "player";
         ignoredMembers.addToIgnoreList(name);
         assertThat(
            function():void{ ignoredMembers.removeFromIgnoreList(name) },
            causes (ignoredMembers) .toDispatchEvent(
               IgnoredMembersEvent.REMOVE_FROM_IGNORE,
               function (event: IgnoredMembersEvent): void {
                  assertThat(
                     "event.member", event.memberName, equals(name)
                  )
               }
            )
         );
      }

      [Test]
      public function backingIgnoredListModificationsCauseEvents(): void {
         const name: String = "player";
         function eventHandler(event: IgnoredMembersEvent): void {
            assertThat( "event.member", event.memberName, equals (name) );
         }

         assertThat(
            function():void{ PlayerOptions.addIgnoredPlayer(name) },
            causes (ignoredMembers) .toDispatchEvent(
               IgnoredMembersEvent.ADD_TO_IGNORE,
               eventHandler
            )
         );
         assertThat(
            function():void{ PlayerOptions.removeIgnoredPlayer(name) },
            causes(ignoredMembers) .toDispatchEvent(
               IgnoredMembersEvent.REMOVE_FROM_IGNORE,
               eventHandler
            )
         );
      }
   }
}
