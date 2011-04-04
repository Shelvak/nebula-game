package models.chat.message.converters
{
   import flash.errors.IllegalOperationError;
   
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.IMChatMessageConverter;
   import models.chat.MChatMessage;
   
   
   /**
    * All converted messages have two parts: firts is time, and after that is text.
    * Base class only creates the time part and adds it to a <code>ParagraphElement</code>.
    * <code>addCustomContent()</code> is invoked: this is where you add aditional content to the
    * <code>ParagraphElement</code>.
    */
   public class BaseMessageConverter implements IMChatMessageConverter
   {
      public function BaseMessageConverter()
      {
      }
      
      
      public function toFlowElement(message:MChatMessage):FlowElement
      {
         var p:ParagraphElement = new ParagraphElement();
         var time:SpanElement = new SpanElement();
         time.text = "[" + message.time + "] ";
         time.styleName = "chatText-time";
         p.addChild(time);
         addCustomContent(message, p);
         return p;
      }
      
      
      /**
       * Adds additional content to the given <code>ParagraphElement</code>. You should generate
       * this content from <code>message</code>.
       * 
       * @param message <code>MChatMessage</code> containing all information needed for content generation. 
       * @param paragraph <code>ParagraphElement</code> with time part already added.
       */
      protected function addCustomContent(message:MChatMessage, paragraph:ParagraphElement) : void
      {
         throw new IllegalOperationError("This method is abstract");
      }
   }
}