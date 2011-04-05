package models.chat
{
   import flashx.textLayout.elements.FlowElement;
   import flashx.textLayout.elements.ParagraphElement;
   
   import models.BaseModel;
   import models.chat.msgconverters.IChatMessageConverter;
   
   
   /**
    * A chat message. The same class is used for private, public and system messages. Differentiation of
    * the first two is controlled by two different implementations of <code>ChatMessageProcessor</code>.
    * Differentiation of all three is controlled by different implementations of
    * <code>IChatMessageConverter</code>.
    * 
    * <p>Should not be created directly. Use <code>MChat.messagePool</code> <code>IObjectPool</code>
    * for retrieving instance of this class. When no longer needed, <code>MChatMessage</code>
    * should be returned to the pool.</p>
    */
   public class MChatMessage extends BaseModel
   {
      public function MChatMessage()
      {
         super();
      }
      
      
      /**
       * Text of the message.
       * 
       * @default null
       */
      public var message:String = null;
      
      
      /**
       * Id of the player who has sent the message.
       * 
       * @default 0
       */      
      public var playerId:int = 0;
      
      
      /**
       * <code>true</code> if this message has been posted by the current player.
       */
      public function get authorIsPlayer() : Boolean
      {
         return ML.player.id == playerId;
      }
      
      
      /**
       * Name of the player who has sent this message.
       * 
       * @default null
       */
      public var playerName:String = null;
      
      
      /**
       * Time when this message was sent.
       * 
       * @default null
       */
      public var time:Date = null;
      
      
      /**
       * Name of the channel this message has been sent to.
       * 
       * @default null
       */
      public var channel:String = null;
      
      
      /**
       * A <code>IChatMessageConverter</code> instance which is used to convert this message
       * to <code>FlowElement</code> when <code>toFlowElement()</code> is called.
       */
      public var converter:IChatMessageConverter;
      
      
      /**
       * @see IMChatMessageConverter#toFlowElement()
       */
      public function toFlowElement() : FlowElement
      {
         return converter.toFlowElement(this);
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      
      public override function equals(o:Object) : Boolean
      {
         if ( !(o is MChatMessage) )
         {
            return false;
         }
         var msg:MChatMessage = MChatMessage(o);
         return this == msg ||
                playerId == msg.playerId &&
                channel == msg.channel &&
                message == msg.message &&
                (time == msg.time || time.time == msg.time.time)
      }
      
      
      public override function toString() : String
      {
         return "[class: " + className +
                ", channel: " + channel +
                ", playerId: " + playerId +
                ", playerName: " + playerName +
                ", message: " + message +
                ", time: " + time + "]";
      }
   }
}