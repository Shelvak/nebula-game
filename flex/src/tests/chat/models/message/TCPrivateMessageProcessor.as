package tests.chat.models.message
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePrivateActionParams;
   
   import models.chat.MChatChannel;
   import models.chat.MChatMember;
   import models.chat.message.processors.PrivateMessageProcessor;
   import models.player.Player;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   
   
   public class TCPrivateMessageProcessor extends TCBaseChatMessageProcessor
   {
      public function TCPrivateMessageProcessor()
      {
         super();
      }
      
      
      private var processor:PrivateMessageProcessor;
      private var channel:MChatChannel;
      private var player:MChatMember;
      private var friend:MChatMember;
      
      
      [Before]
      public override function setUp() : void
      {
         processor = new PrivateMessageProcessor();
         channel = new MChatChannel("friend", processor);
         
         player = new MChatMember();
         player.id = ML.player.id;
         player.name = ML.player.name;
         channel.members.addMember(player);
         
         friend = new MChatMember();
         friend.id = 2;
         friend.name = "friend";
         channel.members.addMember(friend);
      };
      
      
      [After]
      public override function tearDown() : void
      {
         processor = null;
         channel = null;
         player = null;
         friend = null;
         EventBroker.clearAllSubscriptions();
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
         
         processor.sendMessage(message);
         
         assertThat( cmdDispatched, isTrue() );
         
         // PrivateMessageProcessor should have borrowed MChatMessage form the pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 1,
            "numIdle": 0
         }));
      };
   }
}