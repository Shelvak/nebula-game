package tests.chat.models.channel
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePrivateActionParams;
   
   import models.chat.MChatChannelPrivate;
   import models.chat.MChatMember;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   
   
   public class TCMChatChannelPrivate extends TCBaseMChatChannel
   {
      public function TCMChatChannelPrivate()
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
         
         player = new MChatMember();
         player.id = ML.player.id;
         player.name = ML.player.name;
         channel.members.addItem(player);
         
         friend = new MChatMember();
         friend.id = 2;
         friend.name = "friend";
         channel.members.addItem(friend);
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         player = null;
         friend = null;
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
                  "message": message
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
   }
}