package tests.models
{
   import utils.SingletonFactory;
   
   import ext.hamcrest.object.equals;
   
   import models.ModelLocator;
   import models.galaxy.Galaxy;
   import models.solarsystem.SolarSystem;
   
   import org.hamcrest.assertThat;

   
   /**
    * Tests cached property of SolarSystem.
    */
   public class TCSolarSystem_cached
   {
      public function TCSolarSystem_cached()
      {
      };
      
      
      private var ML:ModelLocator;
      private var ss:SolarSystem;
      
      
      [Before]
      public function setUp() : void
      {
         ML = ModelLocator.getInstance();
         ML.latestGalaxy = new Galaxy();
         ML.latestGalaxy.id = 1;
         ML.latestSolarSystem = new SolarSystem();
         ML.latestSolarSystem.galaxyId = 1;
         ML.latestSolarSystem.id = 1;
         ML.latestGalaxy.addObject(ML.latestSolarSystem);
         ss = new SolarSystem();
         ss.id = 1;
         ss.galaxyId = 1;
      };
      
      
      [After]
      public function tearDown() : void
      {
         SingletonFactory.clearAllSingletonInstances();
         ML.reset();
         ML = null;
         ss = null;
      };
      
      
      [Test]
      public function should_not_be_cached_if_latestSolarSystem_is_null() : void
      {
         ML.latestSolarSystem = null;
         assertFalse();
      };
      
      
      [Test]
      public function should_not_be_cached_if_latestSolarSystem_is_fake() : void
      {
         ML.latestSolarSystem.fake = true;
         assertFalse();
      };
      
      
      [Test]
      public function should_not_be_cached_if_ids_do_not_match_and_both_are_not_wormholes() : void
      {
         ML.latestSolarSystem.id = 1;
         ML.latestSolarSystem.wormhole = false;
         ss.id = 2;
         ss.wormhole = false;
         assertFalse();
      };
      
      
      [Test]
      public function should_be_cached_if_ids_match_and_latestSolarSystem_is_not_fake_and_instance_is_fake() : void
      {
         ML.latestSolarSystem.id = 1;
         ML.latestSolarSystem.fake = false;
         ss.id = 1;
         ss.fake = true;
         assertTrue();
      };
      
      
      [Test]
      public function should_be_cached_if_ids_match_and_both_are_valid_instances() : void
      {
         // setUp() has set up all instances to be valid and cached
         assertTrue();
      };
      
      
      [Test]
      public function should_not_be_cached_if_ids_do_not_match_and_both_are_wormholes() : void
      {
         ML.latestSolarSystem.id = 1;
         ML.latestSolarSystem.wormhole = true;
         ss.id = 2;
         ss.wormhole = true;
         ML.latestGalaxy.addObject(ss);
         assertFalse();
      };
      
      
      [Test]
      public function should_be_cached_if_ids_do_not_match_and_instance_is_wormhole_and_latestSolarSystem_is_battleground() : void
      {
         ML.latestGalaxy.battlegroundId = 1;
         ML.latestSolarSystem.id = 1;
         ss.id = 2;
         ss.wormhole = true;
         ML.latestGalaxy.addObject(ss);
         assertTrue();
      };
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function assertFalse() : void
      {
         assertThat( ss.cached, equals (false) );
      }
      
      
      private function assertTrue() : void
      {
         assertThat( ss.cached, equals (true) );
      }
   }
}