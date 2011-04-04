package models.chat.message.converters
{
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatStyles;
   import models.chat.MChatMessage;
   
   
   public class PlayerMessageConverter extends BaseMessageConverter
   {
      public function PlayerMessageConverter()
      {
         super();
      }
      
      
      protected override function addCustomContent(message:MChatMessage, paragraph:ParagraphElement) : void
      {
         var text:SpanElement = new SpanElement();
         text.styleName = ChatStyles.TEXT_PLAYER_MSG;
         text.text = "<" + message.playerName + "> " + message.message;
         paragraph.addChild(text);
      }
   }
}