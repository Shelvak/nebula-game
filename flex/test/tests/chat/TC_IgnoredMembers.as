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
      public function ignoreType(): void {
         PlayerOptions.chatIgnoreType = PlayerOptions.IGNORE_TYPE_FILTERED;
         assertThat(
            "completeIgnore should be false when ignoreType is IGNORE_TYPE_FILTERED",
            ignoredMembers.completeIgnore, isFalse()
         );
         assertThat(
            "filteredIgnore should be true when ignoreType is IGNORE_TYPE_FILTERED",
            ignoredMembers.filteredIgnore, isTrue()
         );

         PlayerOptions.chatIgnoreType = PlayerOptions.IGNORE_TYPE_COMPLETE;
         assertThat(
            "completeIgnore should be true when ignoreType is IGNORE_TYPE_COMPLETE",
            ignoredMembers.completeIgnore, isTrue()
         );
         assertThat(
            "filteredIgnore should be true when ignoreType is IGNORE_TYPE_COMPLETE",
            ignoredMembers.filteredIgnore, isFalse()
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
            function(): void { ignoredMembers.removeFromIgnoreList(IGNORED) },
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
            function(): void { ignoredMembers.removeFromIgnoreList(name) },
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
   }
}
