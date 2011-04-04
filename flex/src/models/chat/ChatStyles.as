package models.chat
{
   /**
    * Defines CSS style names (classes) used in the chat subsystem.
    */
   public class ChatStyles
   {
      /**
       * Prefix of chat style names other thatn text (chat-).
       */
      public static const PREFIX_CHAT:String = "chat-";
      
      
      /**
       * Prefix of chat text style names (chatText-).
       */
      public static const PREFIX_TEXT:String = "chatText-";
      
      
      /**
       * Time of a chat message (chatText-time).
       */
      public static const TEXT_TIME:String = PREFIX_TEXT + "time";
      
      
      /**
       * Text of a whole current player message (chatText-playerMsg).
       */
      public static const TEXT_PLAYER_MSG:String = PREFIX_TEXT + "playerMsg";
      
      
      /**
       * Text of whole member (not the current player) message (chatText-memberMsg).
       */
      public static const TEXT_MEMBER_MSG:String = PREFIX_TEXT + "memberMsg";
      
      
      /**
       * Style of "<player> joined" message text.
       */
      public static const TEXT_CHAN_JOIN:String = PREFIX_TEXT + "chanJoin";
      
      
      /**
       * Style of "<player> left" message text.
       */
      public static const TEXT_CHAN_LEAVE:String = PREFIX_TEXT + "chanLeave";
   }
}