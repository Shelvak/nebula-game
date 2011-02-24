package tests.models
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import ext.hamcrest.object.equals;
   
   import models.ModelLocator;
   import models.galaxy.Galaxy;
   import models.planet.Planet;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SolarSystem;
   
   import org.hamcrest.assertThat;

   /**
    * Tests cached property of Planet.
    */
   public class TCPlanet_cached
   {
      public function TCPlanet_cached()
      {
      }
      
      
      private var ML:ModelLocator;
      private var p:Planet;
      
      
      [Before]
      public function setUp() : void
      {
         ML = ModelLocator.getInstance();
         ML.latestGalaxy = new Galaxy();
         ML.latestGalaxy.id = 1;
         ML.latestSolarSystem = new SolarSystem();
         ML.latestSolarSystem.id = 1;
         ML.latestSolarSystem.galaxyId = 1;
         ML.latestPlanet = new Planet(new MSSObject());
         ML.latestPlanet.id = 1;
         ML.latestPlanet.solarSystemId = 1;
         p = new Planet(new MSSObject());
         p.id = 1;
         p.solarSystemId = 1;
      };
      
      
      [After]
      public function tearDown() : void
      {
         SingletonFactory.clearAllSingletonInstances();
         ML.reset();
         ML = null;
         p.cleanup();
         p = null;
      };
      
      
      [Test]
      public function should_not_be_cached_if_latestSolarSystem_is_null() : void
      {
         ML.latestSolarSystem = null;
         assertFalse();
      };
      
      
      [Test]
      public function should_not_be_cached_if_latestSolarSystem_is_not_cached() : void
      {
         ML.latestGalaxy.id = 1;
         ML.latestSolarSystem.galaxyId = 2;
         assertFalse();
      };
      
      
      [Test]
      public function should_not_be_cached_if_latestPlanet_is_null() : void
      {
         ML.latestPlanet = null;
         assertFalse();
      };
      
      
      [Test]
      public function should_not_be_cached_if_latestPlanet_is_fake() : void
      {
         ML.latestPlanet.fake = true;
         assertFalse();
      };
      
      
      [Test]
      public function should_not_be_cached_if_is_in_different_solarSystem() : void
      {
         ML.latestSolarSystem.id = 1;
         p.solarSystemId = 2;
         assertFalse();
      };
      
      
      [Test]
      public function should_not_be_cached_if_ids_do_not_match() : void
      {
         ML.latestPlanet.id = 1;
         p.id = 2;
         assertFalse();
      };
      
      
      [Test]
      public function should_be_cached_if_ids_match_and_both_are_valid_instances() : void
      {
         // setUp() has set up all cached models
         assertTrue();
      };
      
      
      [Test]
      public function should_be_cached_if_ids_match_and_latestPlanet_is_not_fake_and_instance_is_fake() : void
      {
         ML.latestPlanet.id = 1;
         ML.latestPlanet.fake = false;
         p.id = 1;
         p.fake = true;
         assertTrue();
      };
      
      
      [Test]
      public function should_be_cached_even_if_latestSolarSystem_is_fake() : void
      {
         ML.latestSolarSystem.fake = true;
         assertTrue();
      };
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function assertFalse() : void
      {
         assertThat( p.isCached(), equals (false) );
      }
      
      
      private function assertTrue() : void
      {
         assertThat( p.isCached(), equals (true) );
      }
   }
}