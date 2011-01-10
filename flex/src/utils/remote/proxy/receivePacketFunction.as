/**
 * Proxy to <code>LargeMessageReceiver.invoked_receivePacket()</code>.
 */
public function invoked_receivePacket(methodName:String, lastPacket:Boolean, packetData:String) : void
{
   _receiver.invoked_receivePacket(methodName, lastPacket, packetData);
}