package models.chat.msgconverters
{
   import models.chat.ChatTextStyles;
   
   import utils.SingletonFactory;
   
   
   /**
    * Converts <code>MChatMessage</code> to "<player>: <messageText>" <code>FlowElement</code>.
    */
   public class MemberMessageConverter extends BaseMessageConverter
   {
      public static function getInstance() : MemberMessageConverter {
         return SingletonFactory.getSingletonInstance(MemberMessageConverter);
      }
      
      
      public function MemberMessageConverter() {
         super();
      }
      
      
      protected override function get textColor() : uint {
         return ChatTextStyles.MEMBER_MESSAGE_COLOR;
      }
   }
}