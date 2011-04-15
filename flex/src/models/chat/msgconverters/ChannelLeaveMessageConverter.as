package models.chat.msgconverters
{
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatStyles;
   import models.chat.MChatMessage;
   
   import utils.SingletonFactory;
   
   
   /**
    * Converts <code>MChatMessage</code> to "<player> left" <code>FlowElement</code>.
    */
   public class ChannelLeaveMessageConverter extends BaseMessageConverter
   {
      public static function getInstance() : ChannelLeaveMessageConverter
      {
         return SingletonFactory.getSingletonInstance(ChannelLeaveMessageConverter);
      }
      
      
      public function ChannelLeaveMessageConverter()
      {
         super();
      }
      
      
      protected override function addCustomContent(message:MChatMessage, paragraph:ParagraphElement) : void
      {
         var text:SpanElement = new SpanElement();
         text.color = ChatStyles.TEXT_CHAN_LEAVE_MESSAGE_COLOR;
         text.text = message.message;
         paragraph.addChild(text);
      }
   }
}