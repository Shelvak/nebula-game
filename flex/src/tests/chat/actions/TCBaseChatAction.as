package tests.chat.actions
{
   import asmock.framework.MockRepository;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import models.chat.MChat;
   
   import namespaces.client_internal;
   
   import utils.SingletonFactory;
   
   
   public class TCBaseChatAction
   {
      public function TCBaseChatAction()
      {
         includeMocks = new IncludeMocksRule(singletonMockClasses());
      };
      
      
      /**
       * Returns an array of all singleton classes that are mocked (strict mocks are used).
       * <code>TCBaseChatAction.singletonMockClasses()</code> returns an array with only
       * <code>MChat</code>.
       */
      public function singletonMockClasses() : Array
      {
         return [MChat];
      }
      
      
      [Rule]
      public var includeMocks:IncludeMocksRule;
      
      
      /**
       * Is be available between <code>setUp()</code> and <code>tearDown()</code>.
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
         for each (var CLASS:Class in singletonMockClasses())
         {
            SingletonFactory.client_internal::registerSingletonInstance
               (CLASS, mockRepository.createStrict(CLASS));
         }
      };
      
      
      [After]
      public function tearDown() : void
      {
         mockRepository = null;
         SingletonFactory.clearAllSingletonInstances();
      };
   }
}