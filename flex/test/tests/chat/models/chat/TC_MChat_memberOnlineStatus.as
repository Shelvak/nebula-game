package tests.chat.models.chat
{
   import models.chat.MChatMember;
   import models.chat.MChatMessage;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.not;
   import org.hamcrest.object.hasProperty;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   public class TC_MChat_memberOnlineStatus extends TC_BaseMChat
   {
      public function TC_MChat_memberOnlineStatus()
      {
         super();
      }
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         ML.player.reset();
         ML.player.id = 1;
         ML.player.name = "mikism";
         chat.initialize(
            {
               "1": ML.player.name,
               "2": "jho",
               "3": "arturaz"
            },
            {
               "galaxy": [1, 2, 3],
               "alliance-1": [1, 2, 3]
            }
         );
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
      };
      
      
      [Test]
      public function all_members_after_chat_initialization_should_be_online() : void
      {
         assertThat( chat.members, not (hasItem (hasProperty ("isOnline", isFalse()) )));
      };
      
      
      [Test]
      public function should_be_online_when_member_joins_public_channel() : void
      {
         var member:MChatMember
         
         // new member joins public channel
         member = makeMember(4, "tommy");
         chat.channelJoin("galaxy", member);
         assertThat( chat.members.getMember(4).isOnline, isTrue() );
         
         chat.receivePrivateMessage(makePrivateMessage(5, "pacifist", "I will soon be online!", new Date()));
         assertThat( chat.members.getMember(5).isOnline, isFalse() );
         
         // existing offline member joins public channel
         chat.channelJoin("galaxy", chat.members.getMember(5));
         assertThat( chat.members.getMember(5).isOnline, isTrue() );
      };
      
      
      [Test]
      public function should_be_offline_when_member_leaves_last_public_chan_and_still_is_in_private_chan() : void
      {
         chat.openPrivateChannel(2);   // jho
         
         chat.channelLeave("alliance-1", 2);
         // "jho" is still in "galaxy" so it should be online
         assertThat( chat.members.getMember(2).isOnline, isTrue() );
         
         chat.channelLeave("galaxy", 2);
         // "jho" left last public channel so it should be offline now
         assertThat( chat.members.getMember(2).isOnline, isFalse() );
      };
      
      
      [Test]
      public function should_be_online_when_private_chan_is_closed_but_member_is_in_public_chan() : void
      {
         chat.openPrivateChannel(2);   // jho
         chat.closePrivateChannel("jho");
         
         // "jho" is still in "galaxy" and "alliance-1" so it should be online
         assertThat( chat.members.getMember(2).isOnline, isTrue() );
      };
      
      
      [Test]
      public function should_be_offline_when_offline_member_initiates_conversation() : void
      {
         chat.receivePrivateMessage(makePrivateMessage(4, "tommy", "I'm offline", new Date()));
         
         assertThat( chat.members.getMember(4).isOnline, isFalse() );
      };
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function makePrivateMessage(playerId:int,
                                          playerName:String,
                                          message:String,
                                          time:Date = null) : MChatMessage
      {
         var msg:MChatMessage = MChatMessage(chat.messagePool.borrowObject());
         msg.playerId = playerId;
         msg.playerName = playerName;
         msg.message = message;
         msg.time = time;
         return msg;
      }
      
      
      private function makeMember(id:int, name:String) : MChatMember
      {
         return new MChatMember(id, name);
      }
   }
}