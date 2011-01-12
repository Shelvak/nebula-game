package utils.remote.proxy
{
   import flash.errors.IllegalOperationError;
   import flash.events.AsyncErrorEvent;
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   
   import mx.utils.ObjectUtil;
   
   
   /**
    * An extension of <code>LocalConnection</code> which supports sending large messages (40K and above).
    * For that reason direct use of <code>send()</code> method has been disabled. You can use
    * either <code>sendLarge()</code> method, which will split your data into packets supported by
    * <code>send()</code> and will send those packets to the receiver, or use <code>sendSimple()</code>
    * for calls that do not require a lot of data to be transfered.
    * 
    * <p>This extension of <code>LocalConnection</code> can't received any calls and can only be used for
    * sending messages. Use <code>LargeMessageReceiver</code> for sending large messages.</p>
    */
   public class LargeMessageSender extends LocalConnection
   {
      /**
       * Maximum number of characters in one packet.
       */
      public static const CHARS_IN_PACKET:int = 36 * 1024;
      
      
      private var config:LargeMessageSenderConfig;
      private var connectionName:String;
      
      
      /**
       * Instantiates the instance of <code>LargeMessageSender</code> with given configuration.
       * If you don't provide configuration instance, the default will be used. Refer documenation of
       * <code>LargeMessageSenderConfig</code> class to find out more about configuration options and
       * behaviour of <code>LargeMessageSender</code> under various circumstances with different
       * configuration options.
       * 
       * @param config configuration of <code>LargeMessageSender</code> instance
       * @param connectionName name of the connection to use for communication
       * 
       * @see LargeMessageSenderConfig 
       */
      public function LargeMessageSender(connectionName:String, config:LargeMessageSenderConfig = null)
      {
         super(); 
         addEventListener(StatusEvent.STATUS, this_statusHandler);
         addEventListener(AsyncErrorEvent.ASYNC_ERROR, this_asyncErrorHandler);
         this.connectionName = connectionName;
         this.config = config;
      }
      
      
      /**
       * Not supported. Use <code>sendSimple()</code> instead.
       */
      public override function send(connectionName:String, methodName:String, ...parameters) : void
      {
         trace("[LargeMessageSender] Call to send(): throwing error!");
         throw new IllegalOperationError("This method is not supported. Use sendSimple() instead.");
      }
      
      
      /**
       * Does the same as the <code>send()</code> but you must use this method because <code>send()</code>
       * has been disabled.
       * 
       * @param methodName name of the method to invoke on receiving end
       * @param parameters any parameters that should be passed to the receiving function
       * @param completeHandler handler which will be called when the call has been successful or when
       * error occured. The handler must have three parameters: <code>methodName</code>,
       * <code>parameters</code> and <code>status</code> (one of values of constants in
       * <code>MessageDeliveryStatus</code> class)
       */
      public function sendSimple(methodName:String,
                                 parameters:Array = null,
                                 completeHandler:Function = null) : void
      {
         schedulePacket(new Packet(false, false, false, methodName, null, parameters, null, completeHandler));
         sendPackets();
      }
      
      
      /**
       * Use this for sending lots of data (36K and above). You can also use this for sending small
       * messages but have in mind that this method only accepts one parameter as data to be sent. If you
       * need to invoke a method with more than one parameter (or if that parameter is not of string type),
       * use <code>sendSimple()</code>.
       * 
       * @param methodName name of the method to invoke on receiving end
       * @param message message to be sent
       * @param completeHandler handler which will be called when last packet of the message has been
       * successfully delivered to the receiver or when error has occured while sending any of the packets.
       * The handler must have three parameters: <code>methodName</code>, <code>message</code> and
       * <code>status</code> (one of values of constants in <code>MessageDeliveryStatus</code> class)
       */
      public function sendLarge(methodName:String, message:String, completeHandler:Function = null) : void
      {
         var packets:Vector.<String> = breakMessage(message);
         for (var i:int = 0; i < packets.length; i++)
         {
            var firstPacket:Boolean = i == 0;
            var lastPacket:Boolean  = i + 1 == packets.length;
            schedulePacket(new Packet(true, firstPacket, lastPacket, methodName, packets[i],
                                      null, message, completeHandler));
         }
         sendPackets();
      }
      
      
      /**
       * Breaks given message to a series of packets that can be sent over the communication channel.
       */
      private function breakMessage(message:String) : Vector.<String>
      {
         var packets:Vector.<String> = new Vector.<String>();
         while (message.length > CHARS_IN_PACKET)
         {
            var packet:String = message.substr(0, CHARS_IN_PACKET);
            message = message.substring(CHARS_IN_PACKET);
            packets.push(packet);
         }
         // We must send at least one packet (even if its empty)
         if (message.length > 0 || packets.length == 0)
         {
            packets.push(message);
         }
         return packets;
      }
      
      
      /* ###################################### */
      /* ### PACKETS SCHEDULING AND SENDING ### */
      /* ###################################### */
      
      
      private var channelBusy:Boolean = false;
      private var packetInChannel:Packet = null;
      private var packetsToSend:Vector.<Packet> = new Vector.<Packet>();
      
      
      /**
       * Schedules a packet to be sent over the communication channel. To actually send scheduled packets,
       * call <code>sendPackets()</code>.
       * 
       * @param packet a packet to be sent
       * @param beginning if <code>false</code>, packet will be added to the end of the schedule, otherwise -
       * the beginning
       */
      private function schedulePacket(packet:Packet, beginning:Boolean = false) : void
      {
         if (beginning)
         {
            packetsToSend.unshift(packet);
         }
         else
         {
            packetsToSend.push(packet);
         }
      }
      
      
      private function sendPackets() : void
      {
         if (channelBusy)
         {
            return;
         }
         channelBusy = true;
         sendNextPacket();
      }
      
      
      private function sendNextPacket() : void
      {
         if (packetsToSend.length == 0)
         {
            channelBusy = false;
            packetInChannel = null;
            return;
         }
         packetInChannel = packetsToSend.shift();
         var parameters:Array;
         var methodName:String;
         if (packetInChannel.multiPacketMessage)
         {
            methodName = LargeMessageReceiver.METHOD_NAME_RECEIVE_PACKET;
            parameters = [packetInChannel.methodName,
                          packetInChannel.lastPacket,
                          packetInChannel.packetData];
         }
         else
         {
            methodName = packetInChannel.methodName;
            parameters = packetInChannel.parameters;
         }
         var sendFunction:Function = super.send;
         if (parameters)
         {
            sendFunction.apply(super, [connectionName, methodName].concat(parameters));
         }
         else
         {
            sendFunction.apply(super, [connectionName, methodName]);
         }
      }
      
      
      private function this_statusHandler(event:StatusEvent) : void
      {
         switch (event.level)
         {
            case "status":
               if (!packetInChannel.multiPacketMessage || packetInChannel.lastPacket)
               {
                  packetInChannel.invokeCompleteHandler(MessageDeliveryStatus.COMPLETE)
               }
               break;
            
            case "warning":
               throw new Error("Got status event with level 'warning': " + ObjectUtil.toString(event));
               break;
            
            case "error":
               // try sending the same packet a few times before reporting an error
               if (config.retryAfterFailure &&
                   config.maxRetries < 0 || packetInChannel.retries < config.maxRetries)
               {
                  packetInChannel.retries++;
                  schedulePacket(packetInChannel, true);
               }
               else
               {
                  // if this was a report about the failed multi-packet message, ignore the error
                  if (packetInChannel.methodName == LargeMessageReceiver.METHOD_NAME_CANCEL_LARGE_MESSAGE)
                  {
                     break;
                  }
                  var reportFailure:Boolean = false;
                  // cancel all remaining packets of the multi-packet message which has failed
                  if (packetInChannel.multiPacketMessage &&
                     !packetInChannel.firstPacket &&
                     !packetInChannel.lastPacket)
                  {
                     while (packetsToSend[0].multiPacketMessage && !packetsToSend[0].firstPacket)
                     {
                        packetsToSend.shift();
                     }
                     reportFailure = true;
                  }
                  // cancel all pending calls if configuration tells us to do that
                  if (config.cancelAllCallsAfterError)
                  {
                     for each (var packet:Packet in packetsToSend)
                     {
                        if (!packet.multiPacketMessage || packet.lastPacket)
                        {
                           packet.invokeCompleteHandler(MessageDeliveryStatus.CANCEL);
                        }
                     }
                     packetsToSend.splice(0, packetsToSend.length);
                  }
                  // report the failed multi-packet message to the receiver
                  if (reportFailure)
                  {
                     schedulePacket(new Packet(false, false, false,
                                               LargeMessageReceiver.METHOD_NAME_CANCEL_LARGE_MESSAGE,
                                               null, null, null, null));
                  }
                  // finally invoke complete handler with error status on the packet that has failed
                  packetInChannel.invokeCompleteHandler(MessageDeliveryStatus.ERROR);
               }
               break;
         }
         sendNextPacket();
      }
      
      
      private function this_asyncErrorHandler(event:AsyncErrorEvent) : void
      {
         throw event.error;
      }
   }
}


class Packet
{
   public var multiPacketMessage:Boolean;
   public var firstPacket:Boolean;
   public var lastPacket:Boolean;
   public var methodName:String;
   public var packetData:String;
   public var parameters:Array;
   public var wholeMessage:String;
   public var completeHandler:Function;
   public var errorHandler:Function;
   public var cancelHandler:Function;
   public var retries:uint = 0;
   public function Packet(multiPacketMessage:Boolean,
                          firstPacket:Boolean,
                          lastPacket:Boolean,
                          methodName:String,
                          packet:String,
                          parameters:Array,
                          wholeMessage:String,
                          completeHandler:Function)
   {
      this.multiPacketMessage = multiPacketMessage;
      this.firstPacket = firstPacket;
      this.lastPacket = lastPacket;
      this.methodName = methodName;
      this.parameters = parameters;
      this.packetData = packet;
      this.wholeMessage = wholeMessage;
      this.completeHandler = completeHandler;
   }
   
   
   public function invokeCompleteHandler(deliveryStatus:uint) : void
   {
      if (completeHandler == null)
      {
         return;
      }
      if (multiPacketMessage)
      {
         completeHandler(methodName, wholeMessage, deliveryStatus);
      }
      else
      {
         completeHandler(methodName, parameters, deliveryStatus);
      }
   }
   
}