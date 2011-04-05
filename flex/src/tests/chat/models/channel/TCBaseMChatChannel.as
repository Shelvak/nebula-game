package tests.chat.models.channel
{
   import models.chat.MChatChannel;
   import models.chat.message.processors.ChatMessageProcessor;
   
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   import tests.chat.classes.ChatResourceBundle;
   
   
   public class TCBaseMChatChannel
   {
      protected var channel:MChatChannel;
      
      
      private function get RM() : IResourceManager
      {
         return ResourceManager.getInstance();
      }
      
      
      [Before]
      public function setUp() : void
      {
         RM.addResourceBundle(new ChatResourceBundle());
         RM.update();
         channel = new MChatChannel("galaxy", new ChatMessageProcessor());
      };
      
      
      [After]
      public function tearDown() : void
      {
         RM.removeResourceBundlesForLocale("en_US");
         RM.update();
         channel = null;
      };
   }
}