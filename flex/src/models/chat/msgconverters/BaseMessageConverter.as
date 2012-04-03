package models.chat.msgconverters
{
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.FlowGroupElement;
   import flashx.textLayout.elements.LinkElement;
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   import flashx.textLayout.events.FlowElementMouseEvent;
   import flashx.textLayout.formats.TextDecoration;

   import models.chat.ChatTextStyles;
   import models.chat.MChatMessage;

   import mx.formatters.DateFormatter;

   import styles.LinkStyle;

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


      public function toFlowElement(message: MChatMessage,
                                    onPlayerElementClick: Function = null): FlowElement {
         var p:ParagraphElement = new ParagraphElement();
         addTime(message, p);
         addPlayer(message, p, onPlayerElementClick);
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
       * Adds player name to the message. If you don't need it, override this
       * to no-op.
       *
       * @param onClick if not <code>null</code> will be called when
       * user clicks on the player name. The function will be passed the
       * <code>message</code> the only parameter.
       */
      protected function addPlayer(message: MChatMessage,
                                   p: ParagraphElement,
                                   onClick: Function = null): void {
         const playerId: int = message.playerId;
         const playerName: String = message.playerName;
         const name: SpanElement = new SpanElement();
         name.color = ChatTextStyles.PLAYER_NAME_COLOR;
         name.fontWeight = ChatTextStyles.PLAYER_NAME_FONT_WEIGHT;
         name.text = "<" + playerName + "> ";
         name.textDecoration = TextDecoration.NONE;
         if (onClick != null) {
            const link: LinkElement = new LinkElement();
            link.addChild(name);
            link.addEventListener(
               FlowElementMouseEvent.CLICK,
               function (event: FlowElementMouseEvent): void {
                  onClick.call(null, playerId, playerName);
               }
            );
            p.addChild(link);
         }
         else {
            p.addChild(name);
         }
      }
      
      protected function get textColor() : uint {
         Objects.throwAbstractPropertyError();
         return 0;   // unreachable
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
            const matchBeforeUrl:String = match[1] != null ? match[1] : "";
            const matchUrl:String = match[2];
            const link:String = matchUrl.indexOf("www.") == 0
               ? "http://" + matchUrl : matchUrl;
            const matchUrlIdx:int = match["index"] + matchBeforeUrl.length;
            const textBeforeURL:String = msgText.substr(0, matchUrlIdx);
            
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
         url = decodeURIComponent(url);
         const link:LinkElement = new LinkElement();
         link.href = url;
         link.target = "_blank";
         addSpan(link, url, LinkStyle.CHAT_URL.normalState.color);
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
