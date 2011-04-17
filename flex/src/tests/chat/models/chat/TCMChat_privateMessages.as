package tests.chat.models.chat
{
   import asmock.framework.Expect;
   import asmock.framework.SetupResult;
   
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatChannelPrivate;
   import models.chat.MChatChannelPublic;
   import models.chat.MChatMember;
   import models.chat.MChatMessage;
   import models.player.Player;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.core.allOf;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   
   
   public class TCMChat_privateMessages extends TCBaseMChat
   {
      public function TCMChat_privateMessages()
      {
         super();
      };
      
      
      public override function classesToMock() : Array
      {
         return super.classesToMock().concat(MChatChannelPrivate);
      };
      
      
      private var player:MChatMember;
      private var friend:MChatMember;
      private var channel:MChatChannelPrivate;
      private var message:MChatMessage;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         ML.player = new Player();
         ML.player.id = 1;
         ML.player.name = "mikism";
         player = makeMember(ML.player.id, ML.player.name);
         friend = makeMember(2, "friend");
         chat.members.addMember(player);
         chat.members.addMember(friend);
         message = new MChatMessage();
         message.playerId = friend.id;
         message.message = "I'm a happy player you know!";
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         player = null;
         message = null;
      };
      
      
      [Test]
      public function should_set_message_playerName_and_delegate_to_channel() : void
      {
         channel = MChatChannelPrivate(mockRepository.createDynamic(MChatChannelPrivate, [friend.name]));
         SetupResult.forCall(channel.name).returnValue(friend.name);
         Expect.call(channel.receiveMessage(message))
            .doAction(
               function(message:MChatMessage) : void
               {
                  assertThat( message.playerName, equals (friend.name) );
               });
         
         mockRepository.replayAll();
         
         chat.channels.addChannel(channel);
         channel.members.addMember(player);
         channel.members.addMember(friend);
         
         chat.receivePrivateMessage(message);
         
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_create_private_but_not_change_selected_channel_if_another_player_initiated_conversation() : void
      {
         chat.receivePrivateMessage(message);
         
         assertThat( chat.channels, arrayWithSize (1) );
         assertThat( chat.selectedChannel, nullValue() );
         channel = MChatChannelPrivate(chat.channels.getChannel(friend.name));
         assertThat( channel, notNullValue() );
         assertThat( channel.members, allOf(
            arrayWithSize (2),
            hasItems (player, friend)
         ));
      };
      
      
      [Test]
      public function should_create_private_but_not_change_selected_channel_if_an_offline_player_initiated_conversation() : void
      {
         chat.members.removeMember(friend);
         message.playerName = friend.name;
         chat.receivePrivateMessage(message);
         
         assertThat( chat.members, allOf(
            arrayWithSize (2),
            hasItems(
               player,
               hasProperties ({
                  "id": friend.id,
                  "name": friend.name
               })
            )
         ));
         assertThat( chat.channels, arrayWithSize (1) );
         assertThat( chat.selectedChannel, nullValue() );
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
      
      
      private function makeMember(id:int, name:String) : MChatMember
      {
         return new MChatMember(id, name);
      }
   }
}