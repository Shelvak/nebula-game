package models.chat
{
   /**
    * Various styles of chat text elements. Styles like overall font size or type are set in CSS.
    */
   public class ChatStyles
   {
      /**
       * Color of the time text of a message.
       */
      public static const TEXT_TIME_COLOR:uint = 0x9898B2;
      
      
      /**
       * Color of the channel join system message text.
       */
      public static const TEXT_CHAN_JOIN_MESSAGE_COLOR:uint = 0x00FF00;
      
      
      /**
       * Color of the channel leave system message text.
       */
      public static const TEXT_CHAN_LEAVE_MESSAGE_COLOR:uint = 0xFF0000;
      
      
      /**
       * Color of a message sent by any chat member.
       */
      public static const TEXT_MEMBER_MESSAGE_COLOR:uint = 0x000000;
      
      
      /**
       * Color of a message sent by current player.
       */
      public static const TEXT_PLAYER_MESSAGE_COLOR:uint = 0x8A8A8A;
   }
}