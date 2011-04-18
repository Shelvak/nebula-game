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
      
      
      public override function toFlowElement(message:MChatMessage) : FlowElement
      {
         message.time = new Date();
         message.message = Localizer.string("Chat", "message.channelJoin", [message.playerName]);
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
         text.color = ChatTextStyles.CHAN_JOIN_MESSAGE_COLOR;
         text.text = message.message;
         paragraph.addChild(text);
      }
   }
}