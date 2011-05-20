package tests.chat.models.chat
{
   import asmock.framework.MockRepository;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.ui.NavigationController;
   
   import models.ModelLocator;
   import models.chat.MChat;
   
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   import namespaces.client_internal;
   
   import tests.chat.classes.ChatResourceBundle;
   
   import utils.SingletonFactory;
   import utils.locale.Locale;
   
   
   public class TCBaseMChat
   {
      protected function get RM() : IResourceManager
      {
         return ResourceManager.getInstance();
      }
      
      
      protected function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
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
         return [NavigationController];
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
         SingletonFactory.client_internal::registerSingletonInstance(
            NavigationController,
            mockRepository.createStub(NavigationController)
         );
         chat = MChat.getInstance();
      };
      
      
      [After]
      public function tearDown() : void
      {
         RM.removeResourceBundlesForLocale(Locale.EN);
         mockRepository = null;
         chat = null;
         SingletonFactory.clearAllSingletonInstances();
         EventBroker.clearAllSubscriptions();
      };
   }
}