package tests.models
{
   import asmock.framework.Expect;
   import asmock.framework.MockRepository;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import controllers.ui.NavigationController;
   
   import ext.hamcrest.object.equals;
   
   import models.ModelLocator;
   import models.galaxy.Galaxy;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.planet.Planet;
   import models.player.Player;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SolarSystem;
   
   import namespaces.client_internal;
   
   import org.hamcrest.assertThat;
   
   import utils.SingletonFactory;

   public class TCLocation
   {
      public function TCLocation()
      {
      };
      
      
      [Rule]
      public var includeMocks:IncludeMocksRule = new IncludeMocksRule([
         NavigationController
      ]);
      
      
      private var ML:ModelLocator;
      private var loc:Location;
      private var mockRepository:MockRepository;
      
      
      private function get NAV_CTRL() : NavigationController
      {
         return NavigationController.getInstance();
      }
      
      
      [Before]
      public function setUp() : void
      {
         ML = ModelLocator.getInstance();
         ML.latestGalaxy = new Galaxy();
         ML.latestGalaxy.id = 1;
         ML.latestGalaxy.battlegroundId = 100;
         ML.latestSolarSystem = new SolarSystem();
         ML.latestSolarSystem.id = 1;
         ML.latestSolarSystem.galaxyId = 1;
         ML.latestGalaxy.addObject(ML.latestSolarSystem);
         ML.latestPlanet = new Planet(new MSSObject());
         ML.latestPlanet.id = 1;
         ML.latestPlanet.solarSystemId = 1;
         ML.player = new Player();
         ML.player.id = 1;
         loc = new Location();
         mockRepository = new MockRepository();
         SingletonFactory.client_internal::registerSingletonInstance(
            NavigationController,
            mockRepository.createStrict(NavigationController)
         );
      };
      
      
      [After]
      public function tearDown() : void
      {
         SingletonFactory.clearAllSingletonInstances();
         ML.reset();
         ML = null;
         loc.cleanup();
         loc = null;
         mockRepository = null;
      };
      
      
      [Test]
      public function should_be_navigable_if_galaxy() : void
      {
         loc.id = 1;
         loc.type = LocationType.GALAXY;
         assertThat( loc.isNavigable, equals (true) );
      };
      
      
      [Test]
      public function should_navigate_to_galaxy_if_galaxy() : void
      {
         loc.id = 1;
         loc.id = LocationType.GALAXY;
         Expect.call(NAV_CTRL.toGalaxy());
         mockRepository.replayAll();
         loc.navigateTo();
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_be_navigable_if_solar_system_and_is_visible() : void
      {
         loc.id = 1;
         loc.type = LocationType.SOLAR_SYSTEM;
         // a solar system with id 1 has been added to the galaxy in setUp()
         assertThat( loc.isNavigable, equals (true) );
      };
      
      
      [Test]
      public function should_not_be_navigable_if_solar_system_but_is_not_visible() : void
      {
         loc.id = 2;
         loc.type = LocationType.SOLAR_SYSTEM;
         assertThat( loc.isNavigable, equals (false) );
      };
      
      
      [Test]
      public function should_be_navigable_if_battleground_and_a_wormhole_is_visible() : void
      {
         loc.id = ML.latestGalaxy.battlegroundId;
         loc.type = LocationType.SOLAR_SYSTEM;
         var wormhole:SolarSystem = new SolarSystem();
         wormhole.id = 2;
         wormhole.galaxyId = ML.latestGalaxy.id;
         wormhole.wormhole = true;
         ML.latestGalaxy.addObject(wormhole);
         assertThat( loc.isNavigable, equals (true) );
      };
      
      
      [Test]
      public function should_not_be_navigable_if_battleground_but_no_wormholes_are_visible() : void
      {
         loc.id = ML.latestGalaxy.battlegroundId;
         loc.type = LocationType.SOLAR_SYSTEM;
         assertThat( loc.isNavigable, equals (false) );
      };
      
      
      [Test]
      public function should_navigate_to_solar_system_if_solar_system() : void
      {
         loc.id = 1;
         loc.type = LocationType.SOLAR_SYSTEM;
         // a solar system with id 1 has been added to the galaxy in setUp()
         Expect.call(NAV_CTRL.toSolarSystem(loc.id));
         mockRepository.replayAll();
         loc.navigateTo();
         mockRepository.verifyAll();
      };
      
      
//      [Test]
//      public function should_be_navigable_if_is_planet_and_that_planet_belongs_to_player() : void
//      {
//         loc.id = 2;
//         loc.solarSystemId = 1;
//         loc.type = LocationType.SS_OBJECT;
//         var p:MSSObject = new MSSObject();
//         p.player = 
//      };
   }
}