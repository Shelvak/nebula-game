package tests.chat.models
{
   import asmock.framework.Expect;
   import asmock.framework.MockRepository;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import controllers.ui.NavigationController;
   
   import ext.hamcrest.events.causes;
   
   import models.chat.MChatMember;
   import models.chat.events.MChatMemberEvent;
   
   import namespaces.client_internal;
   
   import org.hamcrest.assertThat;
   
   import utils.SingletonFactory;
   
   
   public class TC_MChatMember
   {
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      [Rule]
      public var includeMocks:IncludeMocksRule = new IncludeMocksRule([NavigationController]);
      private var mockRespository:MockRepository;
      
      
      public function TC_MChatMember() {
      }
      
      
      private var member:MChatMember;
      
      
      [Before]
      public function setUp() : void {
         mockRespository = new MockRepository();
         SingletonFactory.client_internal::registerSingletonInstance
            (NavigationController, mockRespository.createStrict(NavigationController));
         
         member = new MChatMember(1, "mikism");
      }
      
      [After]
      public function tearDown() : void {
         member = null;
         mockRespository = null;
         SingletonFactory.clearAllSingletonInstances();
      }
      
      
      [Test]
      public function should_dispatch_IS_ONLINE_CHANGE_event_when_isOnline_property_changes() : void {
         assertThat(
            function():void{ member.isOnline = true },
            causes (member) .toDispatchEvent (MChatMemberEvent.IS_ONLINE_CHANGE)
         );
         assertThat(
            function():void{ member.isOnline = false },
            causes (member) .toDispatchEvent (MChatMemberEvent.IS_ONLINE_CHANGE)
         );
      }
      
      [Test]
      public function showOpensPlayerProfile() : void {
         Expect.call(NAV_CTRL.showPlayer(member.id));
         mockRespository.replayAll();
         member.showPlayer();
         mockRespository.verifyAll();
      }
   }
}