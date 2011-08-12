package tests.chat.models
{
   import asmock.framework.Expect;
   import asmock.framework.MockRepository;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import controllers.ui.NavigationController;
   
   import ext.hamcrest.object.equals;
   import ext.mocks.Mock;
   
   import models.ModelLocator;
   import models.chat.MChat;
   import models.chat.MChatChannel;
   import models.chat.MChatChannelPrivate;
   import models.chat.MChatChannelPublic;
   import models.chat.MChatMember;
   import models.chat.MChatMembersList;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.throws;
   
   import utils.SingletonFactory;
   
   
   public class TC_MChatMembersList
   {
      private var channel:MChatChannel;
      private var member:MChatMember;
      private var list:MChatMembersList;
      
      [Rule]
      public var includeMocks:IncludeMocksRule = new IncludeMocksRule([MChat, NavigationController]);
      private var mockRepository:MockRepository;
      
      [Before]
      public function setUp() : void {
         ML.player.id = 1;
         ML.player.name = "mikism";
         mockRepository = new MockRepository();
         Mock.singleton(mockRepository, MChat);
         Mock.singleton(mockRepository, NavigationController);
         member = new MChatMember(ML.player.id, ML.player.name);
         list = new MChatMembersList();
         list.addMember(member);
      };
      
      [After]
      public function tearDown() : void {
         member = null;
         list = null;
         mockRepository = null;
         SingletonFactory.clearAllSingletonInstances();
      }
      
      
      [Test]
      public function should_add_chat_member_to_list() : void {
         assertThat( list, arrayWithSize (1) );
         assertThat( list, hasItem (member) );
         assertThat( list.getMember(member.id), equals (member) );
      }
      
      [Test]
      public function should_throw_error_if_member_is_already_in_the_channel() : void {
         var clone:MChatMember = cloneMember(member);
         assertThat( function():void{ list.addMember(clone) }, throws (ArgumentError) );
      }
      
      [Test]
      public function should_remove_chat_member_from_list() : void {
         list.removeMember(cloneMember(member));
         assertThat( list, arrayWithSize (0) );
      }
      
      [Test]
      public function should_throw_error_if_member_to_remove_not_found() : void {
         var another:MChatMember = new MChatMember();
         another.id = 2;
         another.name = "jho";
         assertThat( function():void{ list.removeMember(another) }, throws (ArgumentError) );
      };
      
      [Test]
      public function openMemberIgnoresCurrentPlayer() : void {
         Expect.notCalled(MCHAT.openPrivateChannel(0)).ignoreArguments();
         Expect.notCalled(NAV_CTRL.showPlayer(0)).ignoreArguments();
         mockRepository.replayAll();
         list.openMember(member.id);
         mockRepository.verifyAll();
      }
      
      [Test]
      public function openMemberOpensPrivateChannelWhenChannelIsPublic() : void {
         var friend:MChatMember = new MChatMember(2, "jho");
         channel = new MChatChannelPublic("galaxy");
         channel.memberJoin(member, false);
         channel.memberJoin(friend, false);
         list = channel.members;
         
         Expect.notCalled(NAV_CTRL.showPlayer(0)).ignoreArguments();
         Expect.call(MCHAT.openPrivateChannel(friend.id));
         mockRepository.replayAll();
         list.openMember(friend.id);
         mockRepository.verifyAll();
      }
      
      [Test]
      public function openMemberShowsPlayerProfileWhenChannelIsPrivate() : void {
         var friend:MChatMember = new MChatMember(2, "jho");
         channel = new MChatChannelPrivate("jho");
         channel.memberJoin(member, false);
         channel.memberJoin(friend, false);
         list = channel.members;
         
         Expect.notCalled(MCHAT.openPrivateChannel(0)).ignoreArguments();
         Expect.call(NAV_CTRL.showPlayer(friend.id));
         mockRepository.replayAll();
         list.openMember(friend.id);
         mockRepository.verifyAll();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      private function get MCHAT() : MChat {
         return MChat.getInstance();
      }
      
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      private function cloneMember(member:MChatMember) : MChatMember {
         var clone:MChatMember = new MChatMember();
         clone.id = member.id;
         clone.name = member.name;
         return clone;
      }
   }
}