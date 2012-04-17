package tests.chat.models.chat
{
   import models.chat.events.MChatEvent;

   import org.hamcrest.assertThat;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;

   import tests.chat.classes.IChatJSCallbacksInvokerMock;


   public class TC_MChat extends TC_BaseMChat
   {
      public function TC_MChat()
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
            new IChatJSCallbacksInvokerMock(),
            {
               "1": ML.player.name,
               "2": "jho",
               "3": "arturaz",
               "4": "tommy"
            },
            {
               "galaxy": [1, 2, 3, 4]
            }
         );
      }
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
      }
      
      
      [Test]
      public function should_have_private_channel_when_private_channel_is_opened() : void
      {
         chat.openPrivateChannel(2);   // jho
         
         assertThat( chat.privateChannelOpen, isTrue() );
         
         chat.openPrivateChannel(4);   // tommy
         
         assertThat( chat.privateChannelOpen, isTrue() );
      }
      
      
      [Test]
      public function should_not_have_private_channel_when_last_private_channel_is_closed() : void
      {
         chat.openPrivateChannel(2);   // jho
         chat.openPrivateChannel(4);   // tommy
         
         chat.closePrivateChannel("jho");
         
         assertThat( chat.privateChannelOpen, isTrue() );
         
         chat.closePrivateChannel("tommy");
         
         assertThat( chat.privateChannelOpen, isFalse() );
      }
      
      
      [Test]
      public function should_have_alliance_channel_when_player_joins_that_channel() : void
      {
         chat.channelJoin("alliance-1", chat.members.getMember(ML.player.id));
         
         assertThat( chat.allianceChannelOpen, isTrue() );
      }
      
      
      [Test]
      public function should_not_have_alliance_channel_when_player_leaves_that_channel() : void
      {
         chat.channelJoin("alliance-1", chat.members.getMember(ML.player.id));
         chat.channelLeave("alliance-1", ML.player.id);
         
         assertThat( chat.allianceChannelOpen, isFalse() );
      }
      
      
      [Test]
      public function should_dispatch_HAS_PRIVATE_CHANNEL_CHANGE_event_when_hasPrivateChannel_property_changes() : void
      {
         var eventDispatched:Boolean = false;
         chat.addEventListener(
            MChatEvent.PRIVATE_CHANNEL_OPEN_CHANGE,
            function(event:MChatEvent) : void
            {
               eventDispatched = true;
            }
         );
         
         eventDispatched = false;
         chat.openPrivateChannel(2);   // jho
         
         assertThat( eventDispatched, isTrue() );
         
         eventDispatched = false;
         chat.closePrivateChannel("jho");
         
         assertThat( eventDispatched, isTrue() );
      }
      
      
      [Test]
      public function should_dispatch_HAS_ALLIANCE_CHANNEL_CHANGE_event_when_hasAllianceChannel_property_changes() : void
      {
         var eventDispatched:Boolean = false;
         chat.addEventListener(
            MChatEvent.ALLIANCE_CHANNEL_OPEN_CHANGE,
            function(event:MChatEvent) : void
            {
               eventDispatched = true;
            }
         );
         
         eventDispatched = false;
         chat.channelJoin("alliance-1", chat.members.getMember(ML.player.id));
         
         assertThat( eventDispatched, isTrue() );
         
         eventDispatched = false;
         chat.channelLeave("alliance-1", ML.player.id);
      }
   }
}