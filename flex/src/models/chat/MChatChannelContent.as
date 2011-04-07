package models.chat
{
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.TextFlow;
   
   import models.BaseModel;
   
   
   /**
    * Holds the content of a chat channel as an instance of <code>TextFlow</code>. Holds as many
    * as <code>MAX_MESSAGES</code> messages. If a new message is added via <code>pushMessage()</code>
    * the oldest one is removed.
    */
   public class MChatChannelContent extends BaseModel
   {
      public function MChatChannelContent()
      {
         super();
         _text = new TextFlow();
      }
      
      
      private var _text:TextFlow;
      /**
       * All messages held in this <code>MChatChannelContent</code>. <code>TextFlow</code>
       * will have at most <code>ChatConstants.MAX_MESSAGES_IN_CHANNEL</code> elements at a time. Do not
       * modify <code>TextFlow</code> instance directly. Use <code>addMessage()</code>.
       * 
       * @see #addMessage()
       */
      public function get text() : TextFlow
      {
         return _text;
      }
      
      
      /**
       * Appends the given <code>FlowElement</code> to the end of the whole channel text. If total
       * number of elements (messages) reaches <code>ChatConstants.MAX_MESSAGES_IN_CHANNEL</code>, each call
       * will cause the oldest message (at the very beginning of the whole channel text) to be dropped.
       * 
       * @param element a <code>FlowElement</code> to append. <b>Not null.</b>
       */
      public function addMessage(element:FlowElement) : void
      {
         _text.addChild(element);
         if (_text.numChildren > ChatConstants.MAX_MESSAGES_IN_CHANNEL)
         {
            _text.removeChildAt(0);
         }
      }
   }
}