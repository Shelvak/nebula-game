package models.chat.msgconverters
{
   import flashx.textLayout.elements.ParagraphElement;
   import flashx.textLayout.elements.SpanElement;
   
   import models.chat.ChatStyles;
   import models.chat.MChatMessage;
   
   import utils.SingletonFactory;
   
   
   /**
    * Converts <code>MChatMessage</code> to "<player>: <messageText>" <code>FlowElement</code>.
    */
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
         text.color = ChatStyles.TEXT_MEMBER_MESSAGE_COLOR;
         text.text = "<" + message.playerName + "> " + message.message;
         paragraph.addChild(text);
      }
   }
}