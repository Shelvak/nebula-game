package tests.chat.models
{
   import ext.hamcrest.object.equals;
   
   import models.ModelLocator;
   import models.chat.MChatMessage;
   import models.player.Player;
   
   import org.hamcrest.assertThat;
   
   
   public class TCMChatMessage
   {
      private var message:MChatMessage;
      
      
      private function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      [Before]
      public function setUp() : void
      {
         ML.player = new Player();
         ML.player.id = 1;
         message = new MChatMessage();
      };
      
      
      [After]
      public function tearDown() : void
      {
         message = null;
      };
      
      
      [Test]
      public function should_belong_to_current_player_if_playerId_is_the_same() : void
      {
         message.playerId = ML.player.id;
         assertThat( message.authorIsPlayer, equals (true) );
      };
      
      
      [Test]
      public function should_not_belong_to_current_player_if_playerId_is_different() : void
      {
         message.playerId = 2;
         assertThat( message.authorIsPlayer, equals (false) );
      };
   }
}