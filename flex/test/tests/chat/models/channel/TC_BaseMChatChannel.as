package tests.chat.models.channel
{
   import com.developmentarc.core.utils.EventBroker;
   
   import models.ModelLocator;
   import models.chat.MChat;
   import models.chat.MChatChannel;
   import models.player.Player;
   import models.player.PlayerOptions;

   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   import tests.chat.classes.ChatResourceBundle;
   
   import utils.SingletonFactory;
   
   
   public class TC_BaseMChatChannel
   {
      protected var channel:MChatChannel;
      
      
      protected function get RM() : IResourceManager
      {
         return ResourceManager.getInstance();
      }
      
      
      protected function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      protected function get MCHAT() : MChat
      {
         return MChat.getInstance();
      }
      
      
      [Before]
      public function setUp() : void
      {
         PlayerOptions.loadOptions({"ignoredChatPlayers": []});
         RM.addResourceBundle(new ChatResourceBundle());
         RM.update();
         ML.player.reset();
         ML.player.id = 1;
         ML.player.name = "mikism";
         channel = new MChatChannel("galaxy");
      };
      
      
      [After]
      public function tearDown() : void
      {
         RM.removeResourceBundlesForLocale("en_US");
         RM.update();
         channel = null;
         SingletonFactory.clearAllSingletonInstances();
         EventBroker.clearAllSubscriptions();
      };
   }
}