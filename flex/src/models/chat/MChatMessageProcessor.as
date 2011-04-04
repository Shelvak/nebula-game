package models.chat
{
   import flash.errors.IllegalOperationError;

   /**
    * Implements common behaviour of all chat message processors. This class is abstract.
    */
   public class MChatMessageProcessor
   {
      public function MChatMessageProcessor()
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
       * @param message a <code>MChatMessage</code> received add to be added to the channel content.
       */
      public function receiveMessage(message:MChatMessage) : void
      {
         
      }
      
      
      /**
       * Posts given message to <code>channel</code>. Once response is received from the server,
       * either <code>messageSendSuccess()</code> or <code>messageSendFailure()</code> is invoked.
       * 
       * @param message <code>MChatMessage</code> to post to the channel.
       */
      public function sendMessage(message:MChatMessage) : void
      {
         
      }
      
      
      /**
       * Actually sends the given message to the server. This method is abstract and must be overrided.
       * 
       * @param message <code>MChatMessage</code> to post to the channel.
       */
      protected function sendMessageImpl(message:MChatMessage) : void
      {
         throw new IllegalOperationError("This method is abstract");
      }
      
      
      /**
       * Called when a message has successfully been posted to the channel. In <code>MChatMessageProcessor</code>
       * <code>receiveMessage(message)</code> is invoked.
       * 
       * @param message <code>MChatMessage</code> which has successfully been posted to the channel.
       */
      public function messageSendSuccess(message:MChatMessage) : void
      {
         
      }
      
      
      /**
       * Called when a message could not be posted to the channel. In <code>MChatMessageProcessor</code>
       * this is a no-op.
       * 
       * @param message <code>MChatMessage</code> which was rejected by the server for some reason.
       */
      public function messageSendFailure(message:MChatMessage) : void
      {
         
      }
   }
}