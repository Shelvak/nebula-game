package tests.chat.models.channel
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePublicActionParams;
   
   import models.chat.MChatChannelPublic;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   
   
   public class TC_MChatChannelPublic extends TC_BaseMChatChannel
   {
      public function TC_MChatChannelPublic()
      {
         super();
      };
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         channel = new MChatChannelPublic("friend");
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
         
         channel.sendMessage(message);
         
         assertThat( cmdDispatched, isTrue() );
         
         // PublicMessageProcessor should have borrowed MChatMessage form the pool
         assertThat( MCHAT.messagePool, hasProperties ({
            "numActive": 1,
            "numIdle": 0
         }));
      };
   }
}