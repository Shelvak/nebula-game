package tests.chat.models.chat
{
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatChannelPrivate;
   import models.chat.MChatMember;
   import models.player.Player;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.allOf;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.notNullValue;
   
   
   public class TCMChat_openPrivateChannel extends TCBaseMChat
   {
      public function TCMChat_openPrivateChannel()
      {
         super();
      }
      
      
      private var player:MChatMember;
      private var friend:MChatMember;
      private var channel:MChatChannelPrivate;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         ML.player = new Player();
         ML.player.id = 1;
         ML.player.name = "mikism";
         player = createMember(ML.player.id, ML.player.name);
         friend = createMember(2, "friend");
         chat.members.addMember(player);
         chat.members.addMember(friend);
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         player = null;
      };
      
      
      [Test]
      public function should_create_private_and_change_selected_channel_when_player_initiates_conversation() : void
      {
         chat.openPrivateChannel(friend.id);
         
         assertThat( chat.channels, arrayWithSize (1) );
         assertThat( chat.selectedChannel, equals (chat.channels.getItemAt(0)) );
         channel = MChatChannelPrivate(chat.channels.getChannel(friend.name));
         assertThat( channel, notNullValue() );
         assertThat( channel.members, allOf(
            arrayWithSize (2),
            hasItems (
               player,
               hasProperties ({
                  "id": friend.id,
                  "name": friend.name
               })
            )
         ));
      };
      
      
      [Test]
      public function should_not_do_anything_if_player_tries_to_initiate_conversation_with_himself() : void
      {
         chat.openPrivateChannel(player.id);
         assertThat( chat.channels, emptyArray() );
      };
      
      
      [Test]
      public function should_select_appropriate_channel_when_player_initiates_the_same_conversation_again() : void
      {
         var anotherFriend:MChatMember = createMember(3, "friendNo2");
         chat.members.addMember(anotherFriend);
         chat.openPrivateChannel(friend.id);
         chat.openPrivateChannel(anotherFriend.id);
         chat.openPrivateChannel(friend.id);
         assertThat( chat.channels, arrayWithSize (2) );
         channel = MChatChannelPrivate(chat.channels.getChannel(friend.name));
         assertThat( chat.selectedChannel, equals (channel) );
         assertThat( channel.members, arrayWithSize (2) );
      };
      
      
      [Test]
      public function should_open_private_channel_and_add_memeber_to_members_list_when_no_such_member_is_in_chat() : void
      {
         chat.openPrivateChannel(3, "jho");
         
         assertThat( chat.channels, arrayWithSize (1) );
         assertThat( chat.selectedChannel.name, equals ("jho") );
         assertThat( chat.members, hasItem( hasProperties ({"id": 3, "name": "jho"}) ));
      };
      
      
      private function createMember(id:int, name:String) : MChatMember
      {
         return new MChatMember(id, name);
      }
   }
}