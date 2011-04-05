package tests.chat.models.message
{
   import models.ModelLocator;
   import models.chat.MChat;
   import models.player.Player;
   
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   import tests.chat.classes.ChatResourceBundle;
   
   import utils.SingletonFactory;
   
   
   public class TCBaseChatMessageProcessor
   {
      protected function get MCHAT() : MChat
      {
         return MChat.getInstance();
      }
      
      
      protected function get RM() : IResourceManager
      {
         return ResourceManager.getInstance();
      }
      
      
      protected function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      [Before]
      public function setUp() : void
      {
         RM.addResourceBundle(new ChatResourceBundle());
         RM.update();
         
         ML.player = new Player();
         ML.player.id = 1;
         ML.player.name = "mikism";
      };
      
      
      [After]
      public function tearDown() : void
      {
         RM.removeResourceBundlesForLocale("en_US");
         RM.update();
         SingletonFactory.clearAllSingletonInstances();
      };
   }
}