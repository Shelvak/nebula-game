package tests.models
{
   import ext.hamcrest.object.equals;
   
   import models.ModelLocator;
   import models.galaxy.Galaxy;
   import models.map.MMapSolarSystem;
   import models.planet.MPlanet;
   import models.solarsystem.MSSObject;
   import models.solarsystem.MSolarSystem;
   
   import org.hamcrest.assertThat;
   
   import utils.SingletonFactory;

   /**
    * Tests cached property of MPlanet.
    */
   public class TC_Planet_cached
   {
      public function TC_Planet_cached()
      {
      }
      
      
      private var ML:ModelLocator;
      private var p:MPlanet;
      
      
      [Before]
      public function setUp() : void
      {
         ML = ModelLocator.getInstance();
         ML.player.reset();
         ML.player.galaxyId = 1;
         ML.latestGalaxy = new Galaxy();
         ML.latestGalaxy.id = ML.player.galaxyId;
         ML.latestSSMap = new MMapSolarSystem(new MSolarSystem());
         ML.latestSSMap.id = 1;
         ML.latestPlanet = new MPlanet(new MSSObject());
         ML.latestPlanet.id = 1;
         ML.latestPlanet.solarSystemId = 1;
         p = new MPlanet(new MSSObject());
         p.id = 1;
         p.solarSystemId = 1;
      }
      
      
      [After]
      public function tearDown() : void
      {
         SingletonFactory.clearAllSingletonInstances();
         ML.reset();
         ML = null;
         p.cleanup();
         p = null;
      }
      
      
      [Test]
      public function should_not_be_cached_if_latestPlanet_is_null() : void
      {
         ML.latestPlanet = null;
         assertFalse();
      }
      
      
      [Test]
      public function should_not_be_cached_if_latestPlanet_is_fake() : void
      {
         ML.latestPlanet.fake = true;
         assertFalse();
      }
      
      
      [Test]
      public function should_not_be_cached_if_ids_do_not_match() : void
      {
         ML.latestPlanet.id = 1;
         p.id = 2;
         assertFalse();
      }
      
      
      [Test]
      public function should_be_cached_if_ids_match_and_both_are_valid_instances() : void
      {
         // setUp() has set up all cached models
         assertTrue();
      }
      
      
      [Test]
      public function should_be_cached_if_ids_match_and_latestPlanet_is_not_fake_and_instance_is_fake() : void
      {
         ML.latestPlanet.id = 1;
         ML.latestPlanet.fake = false;
         p.id = 1;
         p.fake = true;
         assertTrue();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function assertFalse() : void
      {
         assertThat( p.cached, equals (false) );
      }
      
      
      private function assertTrue() : void
      {
         assertThat( p.cached, equals (true) );
      }
   }
}