package models.chat
{
   import models.BaseModel;
   
   
   /**
    * A chat message. The same class is used for private and public messages. Differentiation of
    * the two is controlled by two different implementations of <code>ChatMessageProcessor</code>.
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
   }
}