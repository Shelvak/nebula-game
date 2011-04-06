package tests.chat.models.chat
{
   import models.chat.MChat;
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

   public class TCMChat_members extends TCBaseMChat
   {
      public function TCMChat_members()
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
         chat.initialize({}, {"galaxy": [], "alliance": []});
         channelGalaxy = MChatChannelPublic(chat.channels.getChannel("galaxy"));
         channelAlliance = MChatChannelPublic(chat.channels.getChannel("alliance"));
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
         chat.channelJoin("alliance", clone);
         
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
         chat.channelJoin("alliance", member);
         
         assertThat( channelGalaxy.members, arrayWithSize(1) );
         assertThat( channelGalaxy.members, hasItem (member) );
         assertThat( channelAlliance.members, arrayWithSize(1) );
         assertThat( channelAlliance.members, hasItem (member) );
         
         chat.channelLeave("alliance", member.id);
         
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
         chat.channelJoin("alliance", member);
         
         assertThat( chat.members, arrayWithSize (1) );
         assertThat( chat.members, hasItem (member) );
         
         chat.channelLeave("alliance", member.id);
         
         assertThat( chat.members, arrayWithSize (1) );
         assertThat( chat.members, hasItem (member) );
         
         chat.channelLeave("galaxy", member.id);
         
         assertThat( chat.members, emptyArray() );
      };
      
      
      private function makeMember(id:int, name:String) : MChatMember
      {
         var member:MChatMember = new MChatMember();
         member.id = id;
         member.name = name;
         return member;
      }
      
      
      private function cloneMember(member:MChatMember) : MChatMember
      {
         var clone:MChatMember = new MChatMember();
         clone.id = member.id;
         clone.name = member.name;
         return member;
      }
   }
}