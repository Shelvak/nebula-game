package models.chat.events
{
   import flash.events.Event;

   import utils.Objects;


   public class IgnoredMembersEvent extends Event
   {
      /**
       * Dispatched when member has been added to ignore list.
       */
      public static const ADD_TO_IGNORE: String = "addToIgnore";

      /**
       * Dispatched when member has been removed from ignore list.
       */
      public static const REMOVE_FROM_IGNORE: String = "removeFromIgnore";

      
      public function IgnoredMembersEvent(type: String, memberName: String) {
         super(type);
         _memberName = Objects.paramNotEmpty("memberName", memberName);
      }

      private var _memberName: String;
      /**
       * Member that has been added or removed from ignore list.
       */
      public function get memberName(): String {
         return _memberName;
      }
   }
}
