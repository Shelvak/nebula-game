package models.chat.events
{
   import flash.events.Event;
   
   
   public class MChatEvent extends Event
   {
      /**
       * Dispatched when <code>MChat.selectedChannel</code> property has been changed either
       * programaticly or by user interaction.
       * @eventType selectedChannelChange
       */
      public static const SELECTED_CHANNEL_CHANGE:String = "selectedChannelChange";
      
      /**
       * Dispatched when <code>MChat.privateChannelOpen</code> property has changed.
       * @eventType privateChannelOpenChange
       */
      public static const PRIVATE_CHANNEL_OPEN_CHANGE:String = "privateChannelOpenChange";
      
      /**
       * Dispatched when <code>MChat.allianceChannelOpen</code> property has changed.
       * @eventType allianceChannelOpenChange
       */
      public static const ALLIANCE_CHANNEL_OPEN_CHANGE:String = "allianceChannelOpenChange";
      
      /**
       * Dispatched when <code>MChat.hasUnreadAllianceMsg</code> property has changed.
       * @eventType hasUnreadAllianceMsgChange
       */
      public static const HAS_UNREAD_ALLIANCE_MSG_CHANGE:String = "hasUnreadAllianceMsgChange";
      
      /**
       * Dispatched when <code>MChat.hasUnreadPrivateMsg</code> property has changed.
       * @eventType hasUnreadPrivateMsgChange
       */
      public static const HAS_UNREAD_PRIVATE_MSG_CHANGE:String = "hasUnreadPrivateMsgChange";
      
      /**
       * Dispatched when <code>MChat.hasUnreadMainMsg</code> property has changed.
       * @eventType hasUnreadMainMsgChange
       */
      public static const HAS_UNREAD_MAIN_MSG_CHANGE:String = "hasUnreadMainMsgChange";
      
      /**
       * Dispatched when <code>MChat.visible</code> property has changed.
       * @eventType visibleChange
       */
      public static const VISIBLE_CHANGE:String = "visibleChange";
      
      
      public function MChatEvent(type:String) {
         super(type, false, false);
      }
   }
}