package tests.chat.models.message
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePublicActionParams;
   
   import models.chat.MChatChannel;
   import models.chat.message.processors.PublicMessageProcessor;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   
   
   public class TCPublicMessageProcessor extends TCBaseChatMessageProcessor
   {
      public function TCPublicMessageProcessor()
      {
         super();
      }
      
      
      private var processor:PublicMessageProcessor;
      private var channel:MChatChannel;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         processor = new PublicMessageProcessor();
         channel = new MChatChannel("galaxy", processor);
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         processor = null;
         channel = null;
         EventBroker.clearAllSubscriptions();
      };
      
      
      [Test]
      public function should_dispatch_MESSAGE_PUBLIC_command() : void
      {
         var message:String = "Hello everyone!";
         
         var cmdDispatched:Boolean = false;
         EventBroker.subscribe(ChatCommand.MESSAGE_PUBLIC,
            function(cmd:ChatCommand) : void
            {
               var params:MessagePublicActionParams = MessagePublicActionParams(cmd.parameters);
               assertThat( params.message, notNullValue() );
               assertThat( params.message, hasProperties ({
                  "playerId": ML.player.id,
                  "playerName": ML.player.name,
                  "channel": channel.name,
                  "message": message
               }));
               cmdDispatched = true;
            }
         );
         
         processor.sendMessage(message);
         
         assertThat( cmdDispatched, isTrue() );
         
         // PublicMessageProcessor should have borrowed MChatMessage form the pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 1,
            "numIdle": 0
         }));
      }
   }
}