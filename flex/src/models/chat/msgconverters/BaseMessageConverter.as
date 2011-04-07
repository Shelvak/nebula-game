package models.chat.msgconverters
{
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatStyles;
   import models.chat.MChatMessage;
   
   import mx.formatters.DateFormatter;
   
   import utils.locale.Localizer;
   
   
   /**
    * All converted messages have two parts: firts is time, and after that is text.
    * Base class only creates the time part and adds it to a <code>ParagraphElement</code>.
    * <code>addCustomContent()</code> is invoked: this is where you add aditional content to the
    * <code>ParagraphElement</code>.
    */
   public class BaseMessageConverter implements IChatMessageConverter
   {
      public function BaseMessageConverter()
      {
         _timeFormatter = new DateFormatter();
         _timeFormatter.formatString = Localizer.string("Chat", "format.time");
      }
      
      
      private var _timeFormatter:DateFormatter;
      
      
      public function toFlowElement(message:MChatMessage):FlowElement
      {
         var p:ParagraphElement = new ParagraphElement();
         var time:SpanElement = new SpanElement();
         time.color = ChatStyles.TEXT_TIME_COLOR;
         time.text = "[" + _timeFormatter.format(message.time) + "] ";
         p.addChild(time);
         addCustomContent(message, p);
         return p;
      }
      
      
      /**
       * Adds additional content to the given <code>ParagraphElement</code>. You should generate
       * this content from <code>message</code>. In <code>BaseMessageConverter</code> this method is
       * a no-op.
       * 
       * @param message <code>MChatMessage</code> containing all information needed for content generation. 
       * @param paragraph <code>ParagraphElement</code> with time part already added.
       */
      protected function addCustomContent(message:MChatMessage, paragraph:ParagraphElement) : void
      {
      }
   }
}