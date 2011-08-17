package tests.chat.models.channel
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePrivateActionParams;
   
   import flash.errors.IllegalOperationError;
   
   import models.chat.MChatChannelPrivate;
   import models.chat.MChatMember;
   import models.chat.events.MChatChannelEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   
   
   public class TC_MChatChannelPrivate extends TC_BaseMChatChannel
   {
      public function TC_MChatChannelPrivate()
      {
         super();
      }
      
      
      private var player:MChatMember;
      private var friend:MChatMember;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         
         channel = new MChatChannelPrivate("friend");
         
         player = newMember(ML.player.id, ML.player.name);
         channel.memberJoin(player, false);
         
         friend = newMember(2, "friend");
         channel.memberJoin(friend, false);
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         player = null;
         friend = null;
      };
      
      
      [Test]
      public function should_not_allow_more_than_two_members_in_private_channel() : void
      {
         assertThat(
            function():void{ channel.memberJoin(newMember(3, "intruder")) },
            throws (IllegalOperationError)
         );
      };
      
      
      [Test]
      public function should_dispatch_MESSAGE_PRIVATE_command() : void
      {
         var message:String = "Hi there!";
         
         var cmdDispatched:Boolean = false;
         EventBroker.subscribe(ChatCommand.MESSAGE_PRIVATE,
            function(cmd:ChatCommand) : void
            {
               var params:MessagePrivateActionParams = MessagePrivateActionParams(cmd.parameters);
               assertThat( params.message, notNullValue() );
               assertThat( params.message, hasProperties ({
                  "playerId": friend.id,
                  "message": message,
                  "channel": channel.name
               }));
               cmdDispatched = true;
            }
         );
         
         channel.sendMessage(message);
         
         assertThat( cmdDispatched, isTrue() );
         
         // PrivateMessageProcessor should have borrowed MChatMessage form the pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 1,
            "numIdle": 0
         }));
      };
      
      
      [Test]
      public function should_set_isFriendOnline_property_when_a_friend_of_the_player_joins() : void
      {
         friend.isOnline = false;
         var privateChan:MChatChannelPrivate = newChannel(friend.name);
         privateChan.memberJoin(player, false);
         // player is not friend so isFriendOnline should still be false
         assertThat( privateChan.isFriendOnline, isFalse() );
         privateChan.memberJoin(friend);
         // online friend joined but he is offline so isFriendOnline should be false
         assertThat( privateChan.isFriendOnline, isFalse() );
         
         friend.isOnline = true;
         privateChan = newChannel(friend.name);
         privateChan.memberJoin(friend, false);
         // a friend joined and he is online so isFriendOnline should be true now
         assertThat( privateChan.isFriendOnline, isTrue() );
      };
      
      
      [Test]
      public function should_update_isFriendOnline_property_when_friend_goes_offline_and_then_online() : void
      {
         friend.isOnline = false;
         var privateChan:MChatChannelPrivate = newChannel(friend.name);
         privateChan.memberJoin(friend, false);
         privateChan.memberJoin(player, false);
         
         var eventDispatched:Boolean;
         privateChan.addEventListener(
            MChatChannelEvent.IS_FRIEND_ONLINE_CHANGE,
            function(event:MChatChannelEvent) : void
            {
               eventDispatched = true;
            }
         );
         
         assertThat( privateChan.isFriendOnline, isFalse() );
         
         eventDispatched = false;
         friend.isOnline = true;
         assertThat( privateChan.isFriendOnline, isTrue() );
         assertThat( eventDispatched, isTrue() );
         
         eventDispatched = false;
         friend.isOnline = false;
         assertThat( privateChan.isFriendOnline, isFalse() );
         assertThat( eventDispatched, isTrue() );
      };
      
      
      [Test]
      public function should_not_update_isFriendOnline_property_when_friend_online_status_changes_after_cleanup() : void
      {
         friend.isOnline = false;
         var privateChan:MChatChannelPrivate = newChannel(friend.name);
         privateChan.memberJoin(friend, false);
         privateChan.memberJoin(player, false);
         
         var eventDispatched:Boolean = false;
         privateChan.addEventListener(
            MChatChannelEvent.IS_FRIEND_ONLINE_CHANGE,
            function(event:MChatChannelEvent) : void
            {
               eventDispatched = true;
            }
         );
         
         // this should unregister event listeners from the friend instance
         privateChan.cleanup();
         friend.isOnline = true;
         assertThat( privateChan.isFriendOnline, isFalse() );
         assertThat( eventDispatched, isFalse() );
      };
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function newChannel(name:String) : MChatChannelPrivate
      {
         return new MChatChannelPrivate(name);
      }
      
      
      private function newMember(id:int, name:String, isOnline:Boolean = true) : MChatMember
      {
         return new MChatMember(id, name, isOnline);;
      }
   }
}