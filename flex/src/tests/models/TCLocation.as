package tests.models
{
   import asmock.framework.Expect;
   import asmock.framework.MockRepository;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import controllers.ui.NavigationController;
   
   import ext.hamcrest.object.equals;
   
   import models.ModelLocator;
   import models.Owner;
   import models.galaxy.Galaxy;
   import models.location.Location;
   import models.location.LocationType;
   import models.planet.Planet;
   import models.player.Player;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SolarSystem;
   
   import namespaces.client_internal;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   
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
         ML.player = new Player();
         ML.player.galaxyId = 1;
         ML.latestGalaxy = new Galaxy();
         ML.latestGalaxy.id = ML.player.galaxyId;
         ML.latestGalaxy.battlegroundId = 100;
         ML.latestSolarSystem = new SolarSystem();
         ML.latestSolarSystem.id = 1;
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
         loc = null;
         mockRepository = null;
      };
      
      
      [Test]
      public function should_be_navigable_if_galaxy() : void
      {
         loc.id = 1;
         loc.type = LocationType.GALAXY;
         
         assertThat( loc.isNavigable, equals (true) );
         
         Expect.call(NAV_CTRL.toGalaxy())
            .ignoreArguments()
            .doAction(function (galaxy:Galaxy = null, completeHandler:Function = null) : void
            {
               assertThat( galaxy, nullValue() );
               assertThat( completeHandler, notNullValue() );
            });
         mockRepository.replayAll();
         loc.navigateTo();
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_be_navigable_if_solar_system_and_visible() : void
      {
         loc.id = 1;
         loc.type = LocationType.SOLAR_SYSTEM;
         // a solar system with id 1 has been added to the galaxy in setUp()
         
         assertThat( loc.isNavigable, equals (true) );
         
         Expect.call(NAV_CTRL.toSolarSystem(0))
            .ignoreArguments()
            .doAction(function (id:int, completeHandler:Function = null) : void
            {
               assertThat( id, equals (loc.id) );
               assertThat( completeHandler, notNullValue() );
            });
         mockRepository.replayAll();
         loc.navigateTo();
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_not_be_navigable_if_solar_system_but_not_visible() : void
      {
         loc.id = 2;
         loc.type = LocationType.SOLAR_SYSTEM;
         
         assertThat( loc.isNavigable, equals (false) );
      };
      
      
      [Test]
      public function should_be_navigable_if_battleground_and_a_wormhole_visible() : void
      {
         loc.id = ML.latestGalaxy.battlegroundId;
         loc.type = LocationType.SOLAR_SYSTEM;
         var wormhole:SolarSystem = new SolarSystem();
         wormhole.id = 2;
         wormhole.wormhole = true;
         ML.latestGalaxy.addObject(wormhole);
         
         assertThat( loc.isNavigable, equals (true) );
      };
      
      
      [Test]
      public function should_not_be_navigable_if_battleground_but_no_wormholes_visible() : void
      {
         loc.id = ML.latestGalaxy.battlegroundId;
         loc.type = LocationType.SOLAR_SYSTEM;
         assertThat( loc.isNavigable, equals (false) );
      };
      
      
      [Test]
      public function should_be_navigable_if_planet_and_that_planet_belongs_to_player() : void
      {
         loc.id = 2;
         loc.solarSystemId = 2;
         loc.type = LocationType.SS_OBJECT;
         var p:MSSObject = new MSSObject();
         p.id = loc.id;
         p.owner = Owner.PLAYER;
         ML.player.planets.addItem(p);
         
         
         assertThat( loc.isNavigable, equals (true) );
         
         Expect.call(NAV_CTRL.toPlanet(null))
            .ignoreArguments()
            .doAction(function (planet:MSSObject, onComplete:Function = null) : void
            {
               assertThat( planet, equals (p) );
            });
         mockRepository.replayAll();
         loc.navigateTo();
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_be_navigable_if_planet_and_that_planet_cached() : void
      {
         ML.latestPlanet.ssObject.viewable = true;
         ML.latestPlanet.ssObject.owner = Owner.ENEMY;
         ML.latestPlanet.id = 2;
         loc.id = ML.latestPlanet.id;
         loc.solarSystemId = 1;
         loc.type = LocationType.SS_OBJECT;
         
         assertThat( loc.isNavigable, equals (true) );
         
         Expect.call(NAV_CTRL.toPlanet(null))
            .ignoreArguments()
            .doAction(function (planet:MSSObject, onComplete:Function = null) : void
            {
               assertThat( planet, equals (ML.latestPlanet.ssObject) );
            });
         mockRepository.replayAll();
         loc.navigateTo();
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_be_navigable_if_is_not_cached_planet_but_ss_cached() : void
      {
         loc.id = 2;
         loc.solarSystemId = ML.latestSolarSystem.id;
         loc.type = LocationType.SS_OBJECT;
         
         assertThat( loc.isNavigable, equals (true) );
      };
      
      
      [Test]
      public function should_navigate_to_panet_if_not_cached_but_viewable_and_ss_cached() : void
      {
         loc.id = 2;
         loc.solarSystemId = ML.latestSolarSystem.id;
         loc.type = LocationType.SS_OBJECT;
         var p:MSSObject = new MSSObject();
         p.id = loc.id;
         p.solarSystemId = loc.solarSystemId;
         p.viewable = true;
         ML.latestSolarSystem.addObject(p);
         
         Expect.call(NAV_CTRL.toPlanet(null))
            .ignoreArguments()
            .doAction(function (planet:MSSObject, onComplete:Function = null) : void
            {
               assertThat( planet, equals (p) );
            });
         mockRepository.replayAll();
         loc.navigateTo();
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_navigate_to_ss_if_planet_not_cached_and_not_viewable_and_ss_cached() : void
      {
         loc.id = 2;
         loc.solarSystemId = ML.latestSolarSystem.id;
         loc.type = LocationType.SS_OBJECT;
         var p:MSSObject = new MSSObject();
         p.id = loc.id;
         p.solarSystemId = loc.solarSystemId;
         p.viewable = false;
         ML.latestSolarSystem.addObject(p);
         
         Expect.call(NAV_CTRL.toSolarSystem(0))
            .ignoreArguments()
            .doAction(function(id:int, completeHandler:Function = null) : void
            {
               assertThat( id, equals (loc.solarSystemId) );
               assertThat( completeHandler, notNullValue() );
            });
         mockRepository.replayAll();
         loc.navigateTo();
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_be_navigable_if_planet_in_battleground_and_battleground_is_cached() : void
      {
         loc.id = 2;
         loc.solarSystemId = ML.latestGalaxy.battlegroundId;
         loc.type = LocationType.SS_OBJECT;
         ML.latestSolarSystem.id = loc.solarSystemId;
         ML.latestPlanet.id = loc.id;
         ML.latestPlanet.solarSystemId = loc.solarSystemId;
         
         assertThat( loc.isNavigable, equals (true) );
         
         Expect.call(NAV_CTRL.toPlanet(null))
            .ignoreArguments()
            .doAction(function (planet:MSSObject, onComplete:Function = null) : void
            {
               assertThat( planet, equals (ML.latestPlanet.ssObject) );
            });
         mockRepository.replayAll();
         loc.navigateTo();
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_be_navigable_if_planet_in_battleground_but_not_cached_but_wormhole_visible() : void
      {
         loc.id = 2;
         loc.solarSystemId = ML.latestGalaxy.battlegroundId;
         loc.type = LocationType.SS_OBJECT;
         var wormhole:SolarSystem = new SolarSystem();
         wormhole.id = 2;
         wormhole.wormhole = true;
         ML.latestGalaxy.addObject(wormhole);
         
         assertThat( loc.isNavigable, equals (true) );
         
         Expect.call(NAV_CTRL.toSolarSystem(0))
            .ignoreArguments()
            .doAction(function (id:int, completeHandler:Function = null) : void
            {
               assertThat( id, equals (wormhole.id) );
               assertThat( completeHandler, notNullValue() );
            });
         mockRepository.replayAll();
         loc.navigateTo();
         mockRepository.verifyAll();
      };
      
      
      [Test]
      public function should_not_be_navigable_if_planet_in_battleground_and_no_wormholes_visible() : void
      {
         loc.id = 2;
         loc.solarSystemId = ML.latestGalaxy.battlegroundId;
         loc.type = LocationType.SS_OBJECT;
         
         assertThat( loc.isNavigable, equals (false) );
      };
   }
}