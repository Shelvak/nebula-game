package models.chat.msgconverters
{
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatTextStyles;
   import models.chat.MChatMessage;
   
   import utils.SingletonFactory;
   import utils.locale.Localizer;
   
   
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
      
      
      public override function toFlowElement(message:MChatMessage) : FlowElement
      {
         message.time = new Date();
         message.message = Localizer.string("Chat", "message.channelLeave", [message.playerName]);
         return super.toFlowElement(message);
      }
      
      
      /**
       * No-op.
       */
      protected override function addPlayer(message:MChatMessage, p:ParagraphElement) : void
      {
      }
      
      
      protected override function addCustomContent(message:MChatMessage, paragraph:ParagraphElement) : void
      {
         var text:SpanElement = new SpanElement();
         text.color = ChatTextStyles.CHAN_LEAVE_MESSAGE_COLOR;
         text.text = message.message;
         paragraph.addChild(text);
      }
   }
}