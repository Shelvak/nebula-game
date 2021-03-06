package tests.chat.models
{
   import asmock.framework.Expect;
   import asmock.framework.MockRepository;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import controllers.ui.NavigationController;
   
   import ext.hamcrest.events.causes;
   import ext.hamcrest.events.event;
   import ext.hamcrest.object.equals;

   import models.chat.MChat;

   import models.chat.MChatMember;
   import models.chat.events.MChatMemberEvent;
   import models.player.PlayerOptions;

   import mx.events.PropertyChangeEvent;

   import namespaces.client_internal;
   import namespaces.prop_name;

   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import tests.chat.classes.IChatJSCallbacksInvokerMock;

   import utils.SingletonFactory;
   
   
   public class TC_MChatMember
   {
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }

      private function get MCHAT(): MChat {
         return MChat.getInstance();
      }
      
      [Rule]
      public var includeMocks:IncludeMocksRule = new IncludeMocksRule([NavigationController]);
      private var mockRespository:MockRepository;
      
      
      public function TC_MChatMember() {
      }
      
      
      private var member:MChatMember;
      
      
      [Before]
      public function setUp() : void {
         PlayerOptions.loadOptions({"ignoredChatPlayers": []});
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
      public function IAutoCompleteValue(): void {
         assertThat(
            "autoCompleteValue returns member name",
            member.autoCompleteValue, equals (member.name)
         );
      }

      [Test]
      public function name(): void {
         member.name = "OldName";
         assertThat(
            "changing name property",
            function():void{ member.name = "NewName" },
            causes (member).toDispatch (
               event (MChatMemberEvent.NAME_CHANGE),
               event (PropertyChangeEvent.PROPERTY_CHANGE, hasProperties({
                  "source": member,
                  "property": MChatMember.prop_name::name,
                  "oldValue": "OldName",
                  "newValue": "NewName"}))
            )
         );
      }

      [Test]
      public function isIgnored(): void {
         assertThat(
            function():void{ member.isIgnored = true },
            causes (member) .toDispatchEvent (MChatMemberEvent.IS_IGNORED_CHANGE)
         );
         assertThat(
            function():void{ member.isIgnored = false },
            causes (member) .toDispatchEvent (MChatMemberEvent.IS_IGNORED_CHANGE)
         );
      }
      
      [Test]
      public function isOnline() : void {
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

      [Test]
      public function setIsIgnored():void {
         const chat:MChat = MCHAT;
         chat.initialize(
            new IChatJSCallbacksInvokerMock(), {"2": "test"}, {"galaxy": [2]}
         );
         member = chat.members.getMember(2);

         member.setIsIgnored(true);
         assertThat( "should be ignored", member.isIgnored, isTrue() );
         assertThat(
            "should be in ignore list",
            MCHAT.ignoredMembers.isIgnored(member.name), isTrue()
         );

         member.setIsIgnored(false);
         assertThat( "should not be ignored", member.isIgnored, isFalse() );
         assertThat(
            "should not be in ignore list",
            MCHAT.ignoredMembers.isIgnored(member.name), isFalse()
         );
      }
   }
}