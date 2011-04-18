package models.chat.msgconverters
{
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatTextStyles;
   import models.chat.MChatMessage;
   
   import utils.SingletonFactory;
   
   
   /**
    * Converts <code>MChatMessage</code> to "<player>: <messageText>" <code>FlowElement</code>.
    */
   public class PlayerMessageConverter extends BaseMessageConverter
   {
      public static function getInstance() : PlayerMessageConverter
      {
         return SingletonFactory.getSingletonInstance(PlayerMessageConverter);
      }
      
      
      public function PlayerMessageConverter()
      {
         super();
      }
      
      
      protected override function addCustomContent(message:MChatMessage, paragraph:ParagraphElement) : void
      {
         var text:SpanElement = new SpanElement();
         text.color = ChatTextStyles.PLAYER_MESSAGE_COLOR;
         text.text = message.message;
         paragraph.addChild(text);
      }
   }
}