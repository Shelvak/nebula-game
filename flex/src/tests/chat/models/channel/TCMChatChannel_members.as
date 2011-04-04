package tests.chat.models.channel
{
   import models.chat.MChatMember;

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
         
      };
      
      
      [Test]
      public function should_add_system_message_when_member_has_left_the_channel() : void
      {
         
      };
   }
}