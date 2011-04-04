package tests.chat.models.channel
{
   import models.chat.MChatChannel;

   public class TCBaseMChatChannel
   {
      protected var channel:MChatChannel
      
      
      [Before]
      public function setUp() : void
      {
         channel = new MChatChannel();
      };
      
      
      [After]
      public function tearDown() : void
      {
         channel = null;
      };
   }
}