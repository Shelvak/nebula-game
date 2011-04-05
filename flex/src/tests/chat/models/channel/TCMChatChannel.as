package tests.chat.models.channel
{
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatChannel;
   import models.chat.MChatMember;
   import models.chat.MChatMessage;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.notNullValue;
   
   
   public class TCMChatChannel extends TCBaseMChatChannel
   {
      public function TCMChatChannel()
      {
         super();
      }
      
      
      private var member:MChatMember;
      private var message:MChatMessage;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         member = new MChatMember();
         member.id = 1;
         member.name = "mikism";
         message = MChatMessage(MCHAT.messagePool.borrowObject());
         message.time = new Date();
         message.playerId = 1;
         message.playerName = "mikism";
         message.message = "I'm tired";
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         member = null;
         message = null;
      };
      
      
      [Test]
      public function should_instantiate_internal_objects_and_lists() : void
      {
         channel = new MChatChannel("galaxy");
         
         assertThat( channel.name, equals ("galaxy") );

         assertThat( channel.content, notNullValue() );
         
         assertThat( channel.members, notNullValue() );
         assertThat( channel.members, arrayWithSize(0) );
      };
      
      
      [Test]
      public function should_add_system_message_when_member_has_joined() : void
      {
         channel.memberJoin(member);
         
         assertThat( channel.members, arrayWithSize (1) );
         assertThat( channel.members, hasItem (member) );
         assertThat( channel.content.text.numChildren, equals (1) );
      };
      
      
      [Test]
      public function should_not_add_system_message_when_member_has_joined_and_addMessage_is_false() : void
      {
         channel.memberJoin(member, false);
         
         assertThat( channel.members, arrayWithSize (1) );
         assertThat( channel.members, hasItem (member) );
         assertThat( channel.content.text.numChildren, equals (0) );
      };
      
      
      [Test]
      public function should_add_system_message_when_member_has_left() : void
      {
         channel.memberJoin(member);
         channel.memberLeave(member);
         
         assertThat( channel.members, arrayWithSize (0) );
         // one message when member joined the channel
         // one message when member left the channel
         assertThat( channel.content.text.numChildren, equals (2) );
      };
      
      
      
      [Test]
      public function when_received_new_message_should_add_it_to_channel_content() : void
      {
         channel.receiveMessage(message);
         
         assertThat( channel.content.text.numChildren, equals (1) );
         
         // MChatChannel must return MChatMessage to the pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 0,
            "numIdle": 1
         }));
      };
      
      
      [Test]
      public function when_message_was_rejected_should_return_it_to_the_pool_and_do_nothing() : void
      {
         channel.messageSendFailure(message);
         
         assertThat(channel.content.text.numChildren, equals (0) );
         
         // MChatChannel must return MChatMessage to the pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 0,
            "numIdle": 1
         }));
      };
      
      
      [Test]
      public function when_message_has_successfully_been_posted_should_add_it_to_channel_content() : void
      {
         channel.messageSendSuccess(message);
         
         assertThat( channel.content.text.numChildren, equals (1) );
         
         // MChatChannel must return MChatMessage to the pool
         assertThat( MCHAT.messagePool, hasProperties({
            "numActive": 0,
            "numIdle": 1
         }));
      };
   }
}