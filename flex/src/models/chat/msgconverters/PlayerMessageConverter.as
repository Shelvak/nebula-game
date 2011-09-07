package models.chat.msgconverters
{
   import models.chat.ChatTextStyles;
   
   import utils.SingletonFactory;
   
   
   /**
    * Converts <code>MChatMessage</code> to "<player>: <messageText>" <code>FlowElement</code>.
    */
   public class PlayerMessageConverter extends BaseMessageConverter
   {
      public static function getInstance() : PlayerMessageConverter {
         return SingletonFactory.getSingletonInstance(PlayerMessageConverter);
      }
      
      
      public function PlayerMessageConverter() {
         super();
      }
      
      
      protected override function get textColor() : uint {
         return ChatTextStyles.PLAYER_MESSAGE_COLOR;
      }
   }
}