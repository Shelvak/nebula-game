package tests.chat.models.channel
{
   import models.chat.MChatChannel;
   import models.chat.MChatMessageProcessor;

   public class TCBaseMChatChannel
   {
      protected var channel:MChatChannel
      
      
      [Before]
      public function setUp() : void
      {
         channel = new MChatChannel(new MChatMessageProcessor());
      };
      
      
      [After]
      public function tearDown() : void
      {
         channel = null;
      };
   }
}