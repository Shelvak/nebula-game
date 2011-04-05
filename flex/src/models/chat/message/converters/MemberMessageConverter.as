package models.chat.message.converters
{
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatStyles;
   import models.chat.MChatMessage;
   
   import utils.SingletonFactory;
   
   
   public class MemberMessageConverter extends BaseMessageConverter
   {
      public static function getInstance() : MemberMessageConverter
      {
         return SingletonFactory.getSingletonInstance(MemberMessageConverter);
      }
      
      
      public function MemberMessageConverter()
      {
         super();
      }
      
      
      protected override function addCustomContent(message:MChatMessage, paragraph:ParagraphElement) : void
      {
         var text:SpanElement = new SpanElement();
         text.styleName = ChatStyles.TEXT_MEMBER_MSG;
         text.text = "<" + message.playerName + "> " + message.message;
         paragraph.addChild(text);
      }
   }
}