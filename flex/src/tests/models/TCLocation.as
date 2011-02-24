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
         loc = new Location();
         mockRepository = new MockRepository();
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
      public function should_be_navigable_if_in_galaxy() : void
      {
         loc.id = 1;
         loc.type = LocationType.GALAXY;
         assertThat( loc.isNavigable, equals (true) );
      };
      
      
      [Test]
      public function should_navigate_to_galaxy_if_in_galaxy() : void
      {
         loc.id = 1;
         loc.id = LocationType.GALAXY;
         mockNavigationController();
         Expect.call(NAV_CTRL.toGalaxy());
         mockRepository.replayAll();
         loc.navigateTo();
         mockRepository.verifyAll();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function mockNavigationController() : void
      {
         SingletonFactory.client_internal::registerSingletonInstance(
            NavigationController,
            mockRepository.createStrict(NavigationController)
         );
      }
   }
}