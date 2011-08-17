package tests.chat.models.chat
{
   import models.chat.MChat;
   import models.chat.MChatChannel;
   import models.chat.MChatChannelPublic;
   import models.chat.MChatMember;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.allOf;
   import org.hamcrest.core.isA;
   import org.hamcrest.object.hasProperty;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   import org.hamcrest.text.startsWith;

   public class TC_MChat_members extends TC_BaseMChat
   {
      public function TC_MChat_members()
      {
         super();
      };
      
      
      private var channelGalaxy:MChatChannelPublic;
      private var channelAlliance:MChatChannelPublic;
      private var member:MChatMember;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         ML.player.reset();
         ML.player.id = 1;
         ML.player.name = "mikism";
         chat.initialize({}, {"galaxy": [], "alliance-1": []});
         channelGalaxy = MChatChannelPublic(chat.channels.getChannel("galaxy"));
         channelAlliance = MChatChannelPublic(chat.channels.getChannel("alliance-1"));
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         channelGalaxy = null;
         channelAlliance = null;
         member = null;
      }
      
      
      [Test]
      public function should_add_new_member_to_members_list_and_to_channel() : void
      {
         member = makeMember(1, "mikism");
         chat.channelJoin("galaxy", member);
         
         assertThat( chat.members, arrayWithSize (1) );
         assertThat( chat.members, hasItem (member) );
         
         assertThat( channelGalaxy.members, arrayWithSize (1) );
         assertThat( channelGalaxy.members, hasItem (member) );
      };
      
      
      [Test]
      public function should_find_existing_member_and_add_to_channel() : void
      {
         // a member is already in one channel
         member = makeMember(1, "mikism");
         chat.channelJoin("galaxy", member);
         
         // he joins the other channel
         var clone:MChatMember = cloneMember(member);
         chat.channelJoin("alliance-1", clone);
         
         assertThat( chat.members, arrayWithSize (1) );
         assertThat( chat.members, hasItem (member) );
         
         assertThat( channelAlliance.members, arrayWithSize (1) );
         assertThat( channelAlliance.members, hasItem (member) );
      };
      
      
      [Test]
      public function should_create_public_channel_if_not_found_and_add_member_to_it() : void
      {
         member = makeMember(1, "mikism");
         chat.channelJoin("monkeys", member);
         
         assertThat( chat.channels, arrayWithSize (3) );
         assertThat( chat.channels.getChannel("monkeys"), allOf (
            isA (MChatChannelPublic),
            hasProperty("members", allOf (
               arrayWithSize (1),
               hasItem (member)
            ))
         ));
      };
      
      
      [Test]
      public function should_remove_member_from_channel() : void
      {
         member = makeMember(1, "mikism");
         chat.channelJoin("galaxy", member);
         chat.channelJoin("alliance-1", member);
         
         assertThat( channelGalaxy.members, arrayWithSize(1) );
         assertThat( channelGalaxy.members, hasItem (member) );
         assertThat( channelAlliance.members, arrayWithSize(1) );
         assertThat( channelAlliance.members, hasItem (member) );
         
         chat.channelLeave("alliance-1", member.id);
         
         assertThat( chat.members, arrayWithSize (1) );
         assertThat( chat.members, hasItem (member) );
         assertThat( channelGalaxy.members, arrayWithSize (1) );
         assertThat( channelGalaxy.members, hasItem (member) );
         assertThat( channelAlliance.members, emptyArray() );
      };
      
      
      [Test]
      public function should_remove_member_from_members_list_if_he_is_not_in_any_channel() : void
      {
         member = makeMember(1, "mikism");
         chat.channelJoin("galaxy", member);
         chat.channelJoin("alliance-1", member);
         
         assertThat( chat.members, arrayWithSize (1) );
         assertThat( chat.members, hasItem (member) );
         
         chat.channelLeave("alliance-1", member.id);
         
         assertThat( chat.members, arrayWithSize (1) );
         assertThat( chat.members, hasItem (member) );
         
         chat.channelLeave("galaxy", member.id);
         
         assertThat( chat.members, emptyArray() );
      };
      
      
      [Test]
      public function should_not_remove_alliance_channel_when_an_alliance_member_has_left_that_channel() : void
      {
         member = makeMember(2, "jho");
         chat.channelJoin("alliance-1", member);
         chat.channelLeave("alliance-1", member.id);
         
         assertThat( chat.channels.getChannel("alliance-1"), notNullValue() );
      };
      
      
      [Test]
      public function should_remove_alliance_channel_when_current_player_has_left_that_channel() : void
      {
         member = makeMember(2, "jho");
         chat.channelJoin("alliance-1", member);
         var player:MChatMember = makeMember(ML.player.id, ML.player.name);
         chat.channelJoin("alliance-1", player);
         chat.channelLeave("alliance-1", player.id);
         
         assertThat( chat.channels.getChannel("alliance-1"), nullValue() );
      };
      
      
      [Test]
      public function when_player_joins_alliance_channel_that_channel_should_be_second_in_the_list() : void
      {
         chat = new MChat();
         chat.initialize(
            {
               "1": ML.player.name,
               "2": "jho"
            },
            {
               "galaxy": [1, 2]
            }
         );
         chat.openPrivateChannel(2);
         
         chat.channelJoin("alliance-2", chat.members.getMember(ML.player.id));
         
         assertThat(
            MChatChannel(chat.channels.getItemAt(MChat.ALLIANCE_CHANNEL_INDEX)).name,
            startsWith (MChat.ALLIANCE_CHANNEL_PREFIX)
         );
      };
      
      
      private function makeMember(id:int, name:String) : MChatMember
      {
         return new MChatMember(id, name);
      }
      
      
      private function cloneMember(member:MChatMember) : MChatMember
      {
         return makeMember(member.id, member.name);
      }
   }
}