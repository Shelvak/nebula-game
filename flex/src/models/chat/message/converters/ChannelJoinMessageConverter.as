package models.chat.message.converters
{
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatStyles;
   import models.chat.MChatMessage;
   
   import utils.SingletonFactory;
   
   
   public class ChannelJoinMessageConverter extends BaseMessageConverter
   {
      public static function getInstance() : ChannelJoinMessageConverter
      {
         return SingletonFactory.getSingletonInstance(ChannelJoinMessageConverter);
      }
      
      
      public function ChannelJoinMessageConverter()
      {
         super();
      }
      
      
      protected override function addCustomContent(message:MChatMessage, paragraph:ParagraphElement) : void
      {
         var text:SpanElement = new SpanElement();
         text.styleName = ChatStyles.TEXT_CHAN_JOIN;
         text.text = message.message;
         paragraph.addChild(text);
      }
   }
}