package models.chat
{
   import flashx.textLayout.elements.TextFlow;
   
   import models.BaseModel;
   
   
   /**
    * Holds the content of a chat channel as an instance of <code>TextFlow</code>. Holds as many
    * as <code>MAX_MESSAGES</code> messages. If a new message is added via <code>pushMessage()</code>
    * the oldest one is removed.
    */
   public class MChatChannelContent extends BaseModel
   {
      /**
       * Maximum number of messages to hold (150).
       */
      public static const MAX_MESSAGES:int = 150;
      
      
      public function MChatChannelContent()
      {
         super();
         _text = new TextFlow();
      }
      
      
      private var _text:TextFlow;
      /**
       * All messages held in this <code>MChatChannelContent</code>. <code>TextFlow</code>
       * will have at most <code>MAX_MESSAGES</code> elements at a time.
       */
      public function get text() : TextFlow
      {
         return _text;
      }
   }
}