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
      
      
      /**
       * Invoked each time a packet form multi-part message has been received. Once the last packet has
       * been received, will invoke method named <code>methodName</code> passing the whole message on
       * the <code>client</code> object, if provided or on the instance of <code>LargeMessageReceiver</code>
       * itself.
       */
      public function receivePacket(methodName:String, lastPacket:Boolean, packetData:String) : void
      {
         receivedMethodName = methodName;
         receivedPackets.push(packetData);
         if (lastPacket)
         {
            multiPacketMessageReceived();
         }
      }
      
      
      private function assembleMessageAndInvokeMethod() : void
      {
         var message:String = receivedPackets.join("");
         var target:Object = client ? client : this;
         Function(target[receivedMethodName]).call(target, message);
         receivedMethodName = null;
         receivedPackets.splice(0 receivedPackets.length);
      }
      
      
      /**
       * Called by the sender when a multi-packet message has been interrupted and was cancelled. If you
       * override this method, you must call <code>super.multiPacketMessageCancelled()</code>.
       */
      public function multiPacketMessageCancelled() : void
      {
         receivedPackets.splice(0, receivedPackets.length);
      }
   }
}