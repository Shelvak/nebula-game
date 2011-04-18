package models.chat.msgconverters
{
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatTextStyles;
   import models.chat.MChatMessage;
   
   import mx.formatters.DateFormatter;
   
   import utils.locale.Localizer;
   
   
   /**
    * All converted messages have three parts: firts is time, then there is player name and after that is
    * text. Base class only creates time and player name (<code>addPlayer()</code> method) parts and adds
    * them to a <code>ParagraphElement</code>. <code>addCustomContent()</code> is invoked: this is where you
    * add aditional content to the <code>ParagraphElement</code>.
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
         time.color = ChatTextStyles.TIME_COLOR;
         time.text = "[" + _timeFormatter.format(message.time) + "] ";
         p.addChild(time);
         addPlayer(message, p);
         addCustomContent(message, p);
         return p;
      }
      
      
      /**
       * Adds player name to the message. If you don't need it, override this to no-op.
       */
      protected function addPlayer(message:MChatMessage, p:ParagraphElement) : void
      {
         var name:SpanElement = new SpanElement();
         name.color = ChatTextStyles.PLAYER_NAME_COLOR;
         name.fontWeight = ChatTextStyles.PLAYER_NAME_FONT_WEIGHT;
         name.text = "<" + message.playerName + "> ";
         p.addChild(name);
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