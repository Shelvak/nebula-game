package tests.chat.models.chat
{
   import asmock.framework.MockRepository;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import com.developmentarc.core.utils.EventBroker;
   
   import models.chat.MChat;
   
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   import tests.chat.classes.ChatResourceBundle;
   
   import utils.SingletonFactory;
   
   
   public class TCBaseMChat
   {
      protected function get RM() : IResourceManager
      {
         return ResourceManager.getInstance();
      }
      
      
      public function TCBaseMChat() : void
      {
         includeMocks = new IncludeMocksRule(classesToMock());
      }
      
      
      /**
       * Returns an array of classes to be mocked.
       */
      public function classesToMock() : Array
      {
         return [];
      }
      
      
      /**
       * Is available between <code>setUp()</code> and <code>tearDown()</code>.
       */
      protected var mockRepository:MockRepository;
      
      
      [Rule]
      public var includeMocks:IncludeMocksRule;
      
      
      protected var chat:MChat;
      
      
      [Before]
      public function setUp() : void
      {
         RM.addResourceBundle(new ChatResourceBundle());
         RM.update();         
         mockRepository = new MockRepository();
         chat = MChat.getInstance();
      };
      
      
      [After]
      public function tearDown() : void
      {
         RM.removeResourceBundlesForLocale("en_US");
         mockRepository = null;
         chat = null;
         SingletonFactory.clearAllSingletonInstances();
         EventBroker.clearAllSubscriptions();
      };
   }
}