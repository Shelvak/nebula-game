package tests.chat.actions
{
   import asmock.framework.Expect;
   import asmock.framework.MockRepository;
   import asmock.framework.OriginalCallOptions;
   import asmock.framework.SetupResult;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import models.chat.MChat;
   import models.chat.MChatMessageFactory;
   
   import namespaces.client_internal;
   
   import utils.SingletonFactory;
   import utils.pool.impl.StackObjectPoolFactory;
   
   
   public class TCBaseChatAction
   {
      public function TCBaseChatAction()
      {
      };
      
      
      [Rule]
      public var includeMocks:IncludeMocksRule = new IncludeMocksRule([MChat]);
      
      
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
      
      
      [Before]
      public function setUp() : void
      {
         mockRepository = new MockRepository();
         SingletonFactory.client_internal::registerSingletonInstance(MChat, mockRepository.createStrict(MChat));
         SetupResult.forCall(MCHAT.messagePool)
            .returnValue(new StackObjectPoolFactory(new MChatMessageFactory()).createPool());
      };
      
      
      [After]
      public function tearDown() : void
      {
         mockRepository = null;
         SingletonFactory.clearAllSingletonInstances();
      };
   }
}