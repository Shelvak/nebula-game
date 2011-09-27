package models.chat.msgconverters
{
   import flash.errors.IllegalOperationError;
   
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatTextStyles;
   import models.chat.MChatMessage;
   
   import mx.formatters.DateFormatter;
   
   import utils.Objects;
   import utils.locale.Localizer;
   
   
   /**
    * All converted messages have three parts: firts is time, then there is player name and after that is
    * text. Base class only creates time and player name (<code>addPlayer()</code> method) parts and adds
    * them to a <code>ParagraphElement</code>. <code>addCustomContent()</code> is invoked: this is where you
    * add aditional content to the <code>ParagraphElement</code>.
    */
   public class BaseMessageConverter implements IChatMessageConverter
   {
      private static const URL_REGEXP:RegExp = /(\s|^)((www\.|\w+:\/\/).+?)(\s|$)/i;
      
      
      private var _timeFormatter:DateFormatter;
      
      
      public function BaseMessageConverter()
      {
         _timeFormatter = new DateFormatter();
         _timeFormatter.formatString = Localizer.string("Chat", "format.time");
      }
      
      
      public function toFlowElement(message:MChatMessage):FlowElement {
         var p:ParagraphElement = new ParagraphElement();
         addTime(message, p);
         addPlayer(message, p);
         addText(message, p);
         return p;
      }
      
      /**
       * Adds time to the message.  If you don't need it, override this to no-op.
       */
      protected function addTime(message:MChatMessage, p:ParagraphElement) : void {
         var time:SpanElement = new SpanElement();
         time.color = ChatTextStyles.TIME_COLOR;
         time.text = "[" + _timeFormatter.format(message.time) + "] ";
         p.addChild(time);
      }
      
      /**
       * Adds player name to the message. If you don't need it, override this to no-op.
       */
      protected function addPlayer(message:MChatMessage, p:ParagraphElement) : void {
         var name:SpanElement = new SpanElement();
         name.color = ChatTextStyles.PLAYER_NAME_COLOR;
         name.fontWeight = ChatTextStyles.PLAYER_NAME_FONT_WEIGHT;
         name.text = "<" + message.playerName + "> ";
         p.addChild(name);
      }
      
      protected function get textColor() : uint {
         throw new IllegalOperationError("Property is abstract");
      }
      
      /**
       * Adds additional text (or any content) to the given <code>ParagraphElement</code>. You should
       * generate this text from <code>message</code>. In <code>BaseMessageConverter</code> this method parses
       * <code>message.message</code> to a sequence of <code>SpanElement</code> and <code>LinkElement</code>
       * elements.
       * 
       * @param message <code>MChatMessage</code> containing all information needed for text generation. 
       * @param paragraph <code>ParagraphElement</code> with time and player parts already added.
       */
      protected function addText(message:MChatMessage, paragraph:ParagraphElement) : void {
         var msgText:String = message.message;
         var match:Object;
         while ( (match = URL_REGEXP.exec(msgText)) != null ) {
            var matchWhole:String = match[0];
            var matchBeforeUrl:String = match[1] != null ? match[1] : "";
            var matchUrl:String = match[2];
            var link:String = matchUrl.indexOf("www.") == 0 
               ? "http://" + matchUrl : matchUrl;
            var matchUrlIdx:int = match["index"] + matchBeforeUrl.length;
            var textBeforeURL:String = msgText.substr(0, matchUrlIdx);
            
            addSpan(paragraph, textBeforeURL, textColor);
            addUrl(paragraph, link);
            
            // remove stuff that we processed and go on
            msgText = msgText.substr(matchUrlIdx + matchUrl.length);
         }
         addSpan(paragraph, msgText, textColor);
      }
    
      
      private function addUrl(parent:FlowGroupElement, url:String) : void {
         Objects.paramNotNull("parent", parent);
         Objects.paramNotEquals("url", url, [null, ""]);
         url = decodeURI(url);
         var link:LinkElement = new LinkElement();
         link.href = url;
         link.target = "_blank";
         addSpan(link, url, ChatTextStyles.URL_COLOR);
         parent.addChild(link);
      }
      
      private function addSpan(parent:FlowGroupElement, text:String, textColor:uint) : void {
         Objects.paramNotNull("parent", parent);
         if (text == null || text.length == 0)
            return;
         var span:SpanElement = new SpanElement();
         span.color = textColor;
         span.text  = text;
         parent.addChild(span);
      }      
   }
}
