package tests.models
{
   import ext.hamcrest.object.equals;
   
   import models.ModelLocator;
   import models.galaxy.Galaxy;
   import models.player.Player;
   
   import org.hamcrest.assertThat;
   
   import utils.SingletonFactory;

   /**
    * Tests cached property of Galaxy.
    */
   public class TCGalaxy_cached
   {
      public function TCGalaxy_cached()
      {
      };
      
      
      private var ML:ModelLocator;
      private var g:Galaxy;
      
      
      [Before]
      public function setUp() : void
      {
         ML = ModelLocator.getInstance();
         ML.player.reset();
         ML.player.galaxyId = 1;
         ML.latestGalaxy = new Galaxy();
         ML.latestGalaxy.id = ML.player.galaxyId;
         g = new Galaxy();
         g.id = 1;
      };
      
      
      [After]
      public function tearDown() : void
      {
         SingletonFactory.clearAllSingletonInstances();
         ML.reset();
         ML = null;
         g = null;
      };
      
      
      [Test]
      public function should_not_be_cached_if_latestGalaxy_is_null() : void
      {
         ML.latestGalaxy = null;
         assertFalse();
      };
      
      
      [Test]
      public function should_not_be_cached_if_latestGalaxy_is_fake() : void
      {
         ML.latestGalaxy.fake = true;
         assertFalse();
      };
      
      
      [Test]
      public function should_not_be_cached_if_ids_do_not_match() : void
      {
         ML.latestGalaxy.id = ML.player.galaxyId;
         g.id = 2;
         assertFalse();
      };
      
      
      [Test]
      public function should_be_cached_if_ids_match_and_latestGalaxy_is_not_fake_and_not_null() : void
      {
         ML.latestGalaxy.id = ML.player.galaxyId;
         g.id = 1;
         assertTrue();
      };
      
      
      [Test]
      public function should_be_cached_if_latestGalaxy_is_not_fake_but_instance_is_fake() : void
      {
         ML.latestGalaxy.id = ML.player.galaxyId;
         ML.latestGalaxy.fake = false;
         g.id = 1;
         g.fake = true;
         assertTrue();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function assertFalse() : void
      {
         assertThat( g.cached, equals (false) );
      }
      
      
      private function assertTrue() : void
      {
         assertThat( g.cached, equals (true) );
      }
   }
}