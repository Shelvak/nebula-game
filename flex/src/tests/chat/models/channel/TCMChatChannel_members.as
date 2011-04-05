package tests.chat.models.channel
{
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatMember;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.hasItem;

   public class TCMChatChannel_members extends TCBaseMChatChannel
   {
      public function TCMChatChannel_members()
      {
         super();
      };
      
      
      private var member:MChatMember;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         member = new MChatMember();
         member.id = 1;
         member.name = "mikism";
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         member = null;
      };
      
      
      [Test]
      public function should_add_system_message_when_member_has_joined_the_channel() : void
      {
         channel.memberJoin(member);
         
         assertThat( channel.members, arrayWithSize (1) );
         assertThat( channel.members, hasItem (member) );
         assertThat( channel.content.text.numChildren, equals (1) );
      };
      
      
      [Test]
      public function should_add_system_message_when_member_has_left_the_channel() : void
      {
         channel.memberJoin(member);
         channel.memberLeave(member);
         
         assertThat( channel.members, arrayWithSize (0) );
         // one message when member joined the channel
         // one message when member left the channel
         assertThat( channel.content.text.numChildren, equals (2) );
      };
   }
}