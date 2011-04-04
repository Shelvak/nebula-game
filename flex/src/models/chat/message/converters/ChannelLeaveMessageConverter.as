package models.chat.message.converters
{
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatStyles;
   import models.chat.MChatMessage;
   
   
   public class ChannelLeaveMessageConverter extends BaseMessageConverter
   {
      public function ChannelLeaveMessageConverter()
      {
         super();
      }
      
      
      protected override function addCustomContent(message:MChatMessage, paragraph:ParagraphElement) : void
      {
         var text:SpanElement = new SpanElement();
         text.styleName = ChatStyles.TEXT_CHAN_LEAVE;
         text.text = message.message;
         paragraph.addChild(text);
      }
   }
}