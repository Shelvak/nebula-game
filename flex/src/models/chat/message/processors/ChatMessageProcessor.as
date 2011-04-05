package models.chat.message.processors
{
   import flash.errors.IllegalOperationError;
   
   import models.ModelLocator;
   import models.chat.MChat;
   import models.chat.MChatChannel;
   import models.chat.MChatMessage;
   import models.chat.message.converters.IChatMessageConverter;
   import models.chat.message.converters.MemberMessageConverter;
   import models.chat.message.converters.PlayerMessageConverter;
   
   import utils.ClassUtil;
   
   
   /**
    * Implements common behaviour of all chat message processors. This class is abstract.
    */
   public class ChatMessageProcessor
   {
      private static var _receivedMsgConverter:IChatMessageConverter;
      private static function get receivedMsgConverter() : IChatMessageConverter
      {
         if (_receivedMsgConverter == null)
         {
            _receivedMsgConverter = new MemberMessageConverter();
         }
         return _receivedMsgConverter;
      }
      
      
      private static var _playerMsgConverter:IChatMessageConverter;
      private static function get playerMsgConverter() : IChatMessageConverter
      {
         if (_playerMsgConverter == null)
         {
            _playerMsgConverter = new PlayerMessageConverter();
         }
         return _playerMsgConverter;
      }
      
      
      protected function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      protected function get MCHAT() : MChat
      {
         return MChat.getInstance();
      }
      
      
      public function ChatMessageProcessor()
      {
      }
      
      
      /**
       * Reference to instance of <code>MChatChannel</code> which uses this
       * <code>MChatMessageProcessor</code>.
       */
      public var channel:MChatChannel = null;
      
      
      /**
       * Called by <code>MChatChannel</code> when a message has been received. This method converts
       * given message to <code>FlowElement</code> and adds it to <code>MChatChannelContent</code>.
       * 
       * @param message a <code>MChatMessage</code> received to be added to the channel content.
       */
      public function receiveMessage(message:MChatMessage) : void
      {
         message.converter = receivedMsgConverter;
         channel.content.addMessage(message.toFlowElement());
         MCHAT.messagePool.returnObject(message);
      }
      
      
      /**
       * Posts given message to <code>channel</code>. Once response is received from the server,
       * either <code>messageSendSuccess()</code> or <code>messageSendFailure()</code> is invoked.
       * This method is abstract and must be overrided.
       * 
       * @param message message text to post to the channel.
       */
      public function sendMessage(message:String) : void
      {
         throw new IllegalOperationError("This method is abstract");
      }
      
      
      /**
       * Called when a message has successfully been posted to the channel.
       * 
       * @param message <code>MChatMessage</code> which has successfully been posted to the channel.
       */
      public function messageSendSuccess(message:MChatMessage) : void
      {
         message.converter = playerMsgConverter;
         message.time = new Date();
         channel.content.addMessage(message.toFlowElement());
         MCHAT.messagePool.returnObject(message);
      }
      
      
      /**
       * Called when a message could not be posted to the channel. In <code>MChatMessageProcessor</code>
       * <code>message</code> is returned to the <code>MChat.messagePool</code> pool.
       * 
       * @param message <code>MChatMessage</code> which was rejected by the server for some reason.
       */
      public function messageSendFailure(message:MChatMessage) : void
      {
         MCHAT.messagePool.returnObject(message);
      }
   }
}