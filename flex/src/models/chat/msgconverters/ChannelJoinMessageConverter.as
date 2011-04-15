package models.chat.msgconverters
{
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatStyles;
   import models.chat.MChatMessage;
   
   import utils.SingletonFactory;
   
   
   /**
    * Converts <code>MChatMessage</code> to "<player> joined" <code>FlowElement</code>.
    */
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
         text.color = ChatStyles.TEXT_CHAN_JOIN_MESSAGE_COLOR;
         text.text = message.message;
         paragraph.addChild(text);
      }
   }
}