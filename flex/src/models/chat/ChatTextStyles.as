package models.chat
{
   import flash.text.engine.FontWeight;

   /**
    * Various styles of chat text elements. Styles like overall font size or type are set in skins.
    */
   public class ChatTextStyles
   {
      /**
       * Color of the time text of a message.
       */
      public static const TIME_COLOR:uint = 0xDBDBDB;
      
      /**
       * Color of the player name in a message.
       */
      public static const PLAYER_NAME_COLOR:uint = 0xFFC000;
      
      /**
       * Font weight of the palyer name in a message.
       */
      public static const PLAYER_NAME_FONT_WEIGHT:String = FontWeight.BOLD;
      
      /**
       * Color of the channel join system message text.
       */
      public static const CHAN_JOIN_MESSAGE_COLOR:uint = 0x00E207;
      
      /**
       * Color of the channel leave system message text.
       */
      public static const CHAN_LEAVE_MESSAGE_COLOR:uint = 0xDD0202;
      
      /**
       * Color of a message sent by any chat member.
       */
      public static const MEMBER_MESSAGE_COLOR:uint = 0xFFFFFF;
      
      /**
       * Color of a message sent by current player.
       */
      public static const PLAYER_MESSAGE_COLOR:uint = 0xDDD892;
      
      /**
       * Color of URLs.
       */
      public static const URL_COLOR:uint = 0x00D8E3;
   }
}