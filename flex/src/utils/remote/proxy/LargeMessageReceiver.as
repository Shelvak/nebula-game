package utils.remote.proxy
{
   import flash.errors.IllegalOperationError;
   import flash.net.LocalConnection;
   
   
   /**
    * Extension of <code>LocalConnection</code> that supports received of large messages. To send such
    * messages, <code>LargeMessageSender</code> should be used.
    */
   public class LargeMessageReceiver extends LocalConnection
   {
      public function LargeMessageReceiver()
      {
         super();
      }
      
      
      public override function send(connectionName:String, methodName:String, ...parameters):void
      {
         throw new IllegalOperationError("This method is not supported. Use LargeMessageSender for " +
                                         "sending large messages.");
      }
      
 
      private var receivedMethodName:String = null;
      private var receivedPackets:Vector.<String> = new Vector.<String>();
      
      
      internal static const METHOD_NAME_RECEIVE_PACKET:String = "invoked_receivePacket";
      /**
       * Invoked each time a packet form multi-part message has been received. Once the last packet has
       * been received, will invoke method named <code>methodName</code> passing the whole message on
       * the <code>client</code> object, if provided or on the instance of <code>LargeMessageReceiver</code>
       * itself.
       */
      public function invoked_receivePacket(methodName:String, lastPacket:Boolean, packetData:String) : void
      {
         receivedMethodName = methodName;
         receivedPackets.push(packetData);
         if (lastPacket)
         {
            assembleMessageAndInvokeMethod();
         }
      }
      
      
      private function assembleMessageAndInvokeMethod() : void
      {
         var message:String = receivedPackets.join("");
         var target:Object = client ? client : this;
         var targetMethod:Function = target[receivedMethodName]; 
         targetMethod.call(target, message);
         receivedMethodName = null;
         receivedPackets.splice(0, receivedPackets.length);
      }
      
      
      internal static const METHOD_NAME_CANCEL_LARGE_MESSAGE:String = "invoked_cancelLargeMessage";
      /**
       * Called by the sender when a multi-packet message has been interrupted and was cancelled. If you
       * override this method, you must call <code>super.multiPacketMessageCancelled()</code>.
       */
      public function invoked_cancelLargeMessage() : void
      {
         trace("[LargeMessageReceiver] Large message has been canceled by " +
               "LargeMessageSender. Clearing buffer (" + receivedPackets.join("") + ")");
         receivedPackets.splice(0, receivedPackets.length);
      }
   }
}