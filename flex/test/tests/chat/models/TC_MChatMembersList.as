package tests.chat.models
{
   import asmock.framework.Expect;
   import asmock.framework.MockRepository;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import controllers.ui.NavigationController;

   import ext.hamcrest.collection.array;

   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.definesProperty;

   import ext.hamcrest.object.equals;
   import ext.hamcrest.object.metadata.withBindableTag;
   import ext.mocks.Mock;
   
   import models.ModelLocator;
   import models.chat.MChat;
   import models.chat.MChatChannel;
   import models.chat.MChatChannelPrivate;
   import models.chat.MChatChannelPublic;
   import models.chat.MChatMember;
   import models.chat.MChatMembersList;
   import models.chat.events.MChatChannelEvent;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.allOf;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   import org.hamcrest.object.sameInstance;

   import utils.SingletonFactory;
   
   
   public class TC_MChatMembersList
   {
      private var channel: MChatChannel;
      private var member: MChatMember;
      private var list: MChatMembersList;

      [Rule]
      public var includeMocks: IncludeMocksRule =
                          new IncludeMocksRule([MChat, NavigationController]);
      private var mockRepository: MockRepository;

      [Before]
      public function setUp(): void {
         ML.player.id = 1;
         ML.player.name = "mikism";
         mockRepository = new MockRepository();
         Mock.singleton(mockRepository, MChat);
         Mock.singleton(mockRepository, NavigationController);
         member = new MChatMember(ML.player.id, ML.player.name);
         list = new MChatMembersList();
         list.addMember(member);
      }

      [After]
      public function tearDown(): void {
         member = null;
         list = null;
         mockRepository = null;
         SingletonFactory.clearAllSingletonInstances();
      }


      [Test]
      public function should_add_chat_member_to_list(): void {
         assertThat(list, arrayWithSize(1));
         assertThat(list, hasItem(member));
         assertThat(list.getMember(member.id), equals(member));
      }

      [Test]
      public function should_ignore_if_member_is_already_in_the_channel(): void {
         var clone: MChatMember = cloneMember(member);
         list.addMember(clone);
         assertThat("should only contain one member", list, array(member));
      }

      [Test]
      public function should_remove_chat_member_from_list(): void {
         list.removeMember(cloneMember(member));
         assertThat(list, arrayWithSize(0));
      }

      [Test]
      public function should_ignore_if_member_to_remove_not_found(): void {
         var another: MChatMember = new MChatMember();
         another.id = 2;
         another.name = "jho";
         list.removeMember(another);
         assertThat("should only contain one member", list, array(member));
      }
      
      [Test]
      public function openMemberOpensPrivateChannelForFriendAndProfileForPlayerWhenChannelIsPublic(): void {
         var friend: MChatMember = new MChatMember(2, "jho");
         channel = new MChatChannelPublic("galaxy");
         channel.memberJoin(member, false);
         channel.memberJoin(friend, false);
         list = channel.members;
         
         Expect.notCalled(NAV_CTRL.showPlayer(friend.id));
         Expect.notCalled(MCHAT.openPrivateChannel(member.id));
         Expect.call(MCHAT.openPrivateChannel(friend.id));
         Expect.call(NAV_CTRL.showPlayer(member.id));
         mockRepository.replayAll();
         list.openMember(friend.id);
         list.openMember(member.id);
         mockRepository.verifyAll();
      }
      
      [Test]
      public function openMemberShowsPlayerProfileWhenChannelIsPrivate(): void {
         var friend: MChatMember = new MChatMember(2, "jho");
         channel = new MChatChannelPrivate("jho");
         channel.memberJoin(member, false);
         channel.memberJoin(friend, false);
         list = channel.members;
         
         Expect.notCalled(MCHAT.openPrivateChannel(0)).ignoreArguments();
         Expect.call(NAV_CTRL.showPlayer(friend.id));
         Expect.call(NAV_CTRL.showPlayer(member.id));
         mockRepository.replayAll();
         list.openMember(friend.id);
         list.openMember(member.id);
         mockRepository.verifyAll();
      }

      [Test]
      public function nameFilter_notApplied(): void {
         list.reset();
         const member1: MChatMember = new MChatMember(1, "one");
         const member2: MChatMember = new MChatMember(2, "two");
         list.addMember(member1);
         list.addMember(member2);
         assertThat(
            "filter should not be applied by default",
            list.dataProvider, hasItems (member1, member2)
         );

         list.nameFilter = "";
         assertThat(
            "empty string does not apply filter",
            list.dataProvider, arrayWithSize (2)
         );

         list.nameFilter = "   \t";
         assertThat(
            "whitespace does not apply filter",
            list.dataProvider, arrayWithSize (2)
         );

         list.nameFilter = null;
         assertThat(
            "null does not apply filter",
            list.dataProvider, arrayWithSize (2)
         );
      }

      [Test]
      public function nameFilter_applied(): void {
         list.reset();
         const member1: MChatMember = new MChatMember(1, "onret");
         const member2: MChatMember = new MChatMember(2, "thwo");
         const member3: MChatMember = new MChatMember(3, "three");
         list.addMember(member1);
         list.addMember(member2);
         list.addMember(member3);

         list.nameFilter = "re";
         assertThat(
            "should contain only members that have 're' substring in their names",
            list.dataProvider, allOf(
               hasItems (member1, member3),
               not (hasItem (member2))
            )
         );

         list.nameFilter = "  three\n";
         assertThat(
            "should trim whitespace form filter value and contain only member "
               + "that have 'three' substring in their names",
            list.dataProvider, allOf(
               hasItems (member3),
               not (hasItems (member1, member2))
            )
         );

         list.nameFilter = "THREE";
         assertThat(
            "filtering should be case insensitive",
            list.dataProvider, hasItem (member3)
         );
      }

      [Test]
      public function nameFilter_changeEvent(): void {
         assertThat(
            "should dispatch event when nameFilter property changes",
            function():void{ list.nameFilter = "name" },
            causes (list) .toDispatchEvent (MChatChannelEvent.MEMBERS_FILTER_CHANGE)
         );

         assertThat(
            "should not dispatch event if nameFilter does not change",
            function():void{ list.nameFilter = "name  " },
            not (causes (list) .toDispatchEvent (MChatChannelEvent.MEMBERS_FILTER_CHANGE))
         );

         assertThat(
            "[pro nameFilter] should have [Bindable] metadata tag attached",
            MChatMembersList, definesProperty(
               "nameFilter",
               withBindableTag (MChatChannelEvent.MEMBERS_FILTER_CHANGE)
            )
         );
      }

      [Test]
      public function reset(): void {
         const friend: MChatMember = new MChatMember(2, "friend");
         list.addMember(friend);
         list.nameFilter = "friend";

         list.reset();
         assertThat(
            "should remove all members from the list",
            list, emptyArray()
         );
         assertThat( list.getMember(1), nullValue() );
         assertThat( list.getMember(2), nullValue() );

         list.addMember(member);
         assertThat(
            "should remove the filter",
            list.dataProvider, hasItem (member)
         );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }

      private function get MCHAT(): MChat {
         return MChat.getInstance();
      }

      private function get NAV_CTRL(): NavigationController {
         return NavigationController.getInstance();
      }

      private function cloneMember(member: MChatMember): MChatMember {
         var clone: MChatMember = new MChatMember();
         clone.id = member.id;
         clone.name = member.name;
         return clone;
      }
   }
}