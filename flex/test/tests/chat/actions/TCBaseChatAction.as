package tests.chat.actions
{
   import asmock.framework.MockRepository;
   import asmock.framework.SetupResult;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import models.chat.MChat;
   import models.chat.MChatMessageFactory;
   
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   import namespaces.client_internal;
   
   import utils.SingletonFactory;
   import utils.locale.Locale;
   import utils.pool.impl.StackObjectPoolFactory;
   
   
   public class TCBaseChatAction
   {
      public function TCBaseChatAction()
      {
         includeMocks = new IncludeMocksRule(classesToMock());
      };
      
      
      /**
       * Returns an array of classes to be mocked.
       */
      public function classesToMock() : Array
      {
         return [MChat];
      }
      
      
      [Rule]
      public var includeMocks:IncludeMocksRule;
      
      
      /**
       * Is available between <code>setUp()</code> and <code>tearDown()</code>.
       */
      protected var mockRepository:MockRepository;
      
      
      /**
       * Reference to <code>MChat</code> singleton mock.
       */
      protected function get MCHAT() : MChat
      {
         return MChat.getInstance();
      }
      
      
      private function get RM() : IResourceManager
      {
         return ResourceManager.getInstance();
      }
      
      
      [Before]
      public function setUp() : void
      {
         RM.addResourceBundle(new GeneralResourceBundle());
         RM.update();
         
         mockRepository = new MockRepository();
         SingletonFactory.client_internal::registerSingletonInstance(MChat, mockRepository.createStrict(MChat));
         SetupResult.forCall(MCHAT.messagePool)
            .returnValue(new StackObjectPoolFactory(new MChatMessageFactory()).createPool());
      };
      
      
      [After]
      public function tearDown() : void
      {
         RM.removeResourceBundlesForLocale(Locale.EN);
         
         mockRepository = null;
         SingletonFactory.clearAllSingletonInstances();
      };
   }
}


import mx.resources.IResourceBundle;

import utils.locale.Locale;

internal class GeneralResourceBundle implements IResourceBundle
{
   public function get bundleName() : String
   {
      return "General";
   }
   
   
   public function get locale() : String
   {
      return Locale.EN;
   }
   
   
   private var _content:Object = {
      "message.actionCanceled": ""
   };
   public function get content() : Object
   {
      return _content;
   }
}