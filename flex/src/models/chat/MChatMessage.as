package models.chat
{
   import models.BaseModel;
   
   
   /**
    * A chat message. The same class is used for private and public messages. Differentiation of
    * the two is controlled by two different implementations of <code>ChatMessageProcessor</code>.
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
         return playerId == msg.playerId &&
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