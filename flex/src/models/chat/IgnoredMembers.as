package models.chat
{
   import controllers.playeroptions.PlayerOptionsCommand;

   import flash.events.EventDispatcher;

   import models.chat.events.IgnoredMembersEvent;

   import models.player.PlayerOptions;

   import mx.collections.IList;

   
   /**
    * @see models.chat.events.IgnoredMembersEvent.ADD_TO_IGNORE
    */
   [Event(name="addToIgnore", type="models.chat.events.IgnoredMembersEvent")]

   /**
    * @see models.chat.events.IgnoredMembersEvent.REMOVE_FROM_IGNORE
    */
   [Event(name="removeFromIgnore", type="models.chat.events.IgnoredMembersEvent")]

   public class IgnoredMembers extends EventDispatcher
   {
      private var _ignored: IList = PlayerOptions.ignoredPlayersDataProvider;

      public function IgnoredMembers() {
      }

      public function isIgnored(memberName: String): Boolean {
         return _ignored.getItemIndex(memberName) >= 0;
      }

      public function get completeIgnore(): Boolean {
         return PlayerOptions.chatIgnoreType ==
                   PlayerOptions.IGNORE_TYPE_COMPLETE;
      }

      public function get filteredIgnore(): Boolean {
         return PlayerOptions.chatIgnoreType ==
                   PlayerOptions.IGNORE_TYPE_FILTERED;
      }

      public function addToIgnoreList(memberName: String): void {
         PlayerOptions.addIgnoredPlayer(memberName);
         dispatchOptionsSetCommand();
         dispatchIgnoredMembersEvent(
            IgnoredMembersEvent.ADD_TO_IGNORE, memberName
         );
      }

      public function removeFromIgnoreList(memberName: String): void {
         PlayerOptions.removeIgnoredPlayer(memberName);
         dispatchOptionsSetCommand();
         dispatchIgnoredMembersEvent(
            IgnoredMembersEvent.REMOVE_FROM_IGNORE, memberName
         )
      }

      private function dispatchOptionsSetCommand(): void {
         new PlayerOptionsCommand(PlayerOptionsCommand.SET).dispatch();
      }

      private function dispatchIgnoredMembersEvent(type: String,
                                                   memberName: String): void {
         if (hasEventListener(type)) {
            dispatchEvent(new IgnoredMembersEvent(type, memberName));
         }
      }
   }
}
