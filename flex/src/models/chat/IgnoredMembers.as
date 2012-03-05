package models.chat
{
   import controllers.playeroptions.PlayerOptionsCommand;

   import flash.events.EventDispatcher;

   import models.chat.events.IgnoredMembersEvent;

   import models.player.PlayerOptions;

   import mx.collections.IList;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;


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
      private function get ignoredList(): IList {
         return PlayerOptions.ignoredPlayersDataProvider;
      }

      public function IgnoredMembers() {
         ignoredList.addEventListener(
            CollectionEvent.COLLECTION_CHANGE,
            ignoredList_collectionChangeHandler, false, 0, true
         );
      }

      private function ignoredList_collectionChangeHandler(event: CollectionEvent): void {
         switch (event.kind) {
            case CollectionEventKind.ADD:
               dispatchIgnoredMembersEvent(
                  IgnoredMembersEvent.ADD_TO_IGNORE, event.items[0]
               );
               break;
            case CollectionEventKind.REMOVE:
               dispatchIgnoredMembersEvent(
                  IgnoredMembersEvent.REMOVE_FROM_IGNORE, event.items[0]
               );
               break;
         }
      }

      public function isIgnored(memberName: String): Boolean {
         return ignoredList.getItemIndex(memberName) >= 0;
      }

      public function isCompleteIgnored(memberName: String): Boolean {
         return isIgnored(memberName) && PlayerOptions.chatIgnoreType ==
                                            PlayerOptions.IGNORE_TYPE_COMPLETE;
      }

      public function isFilteredIgnored(memberName: String): Boolean {
         return isIgnored(memberName) && PlayerOptions.chatIgnoreType ==
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
