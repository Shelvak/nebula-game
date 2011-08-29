package tests.models
{
   import asmock.framework.Expect;
   import asmock.framework.MockRepository;
   import asmock.integration.flexunit.IncludeMocksRule;
   
   import controllers.ui.NavigationController;
   
   import ext.hamcrest.events.causesTarget;
   import ext.hamcrest.object.equals;
   
   import models.ModelLocator;
   import models.Owner;
   import models.galaxy.Galaxy;
   import models.location.Location;
   import models.location.LocationEvent;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.planet.Planet;
   import models.player.PlayerMinimal;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSKind;
   import models.solarsystem.SolarSystem;
   
   import namespaces.client_internal;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   import org.hamcrest.object.sameInstance;
   
   import testsutils.LocalizerUtl;
   
   import utils.Objects;
   import utils.SingletonFactory;

   public class TC_Location
   {
      public function TC_Location()
      {
      };
      
      
      [Rule]
      public var includeMocks:IncludeMocksRule = new IncludeMocksRule([
         NavigationController
      ]);
      
      
      private var ML:ModelLocator;
      private var loc:Location;
      private var mockRepository:MockRepository;
      
      
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      
      [Before]
      public function setUp() : void {
         LocalizerUtl.setUp();
         LocalizerUtl.addBundle("Players", {"npc": "NPC"});
         ML = ModelLocator.getInstance();
         ML.player.reset();
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
         ML.player.reset();
         ML.player.id = 1;
         loc = new Location();
         mockRepository = new MockRepository();
         SingletonFactory.client_internal::registerSingletonInstance(
            NavigationController,
            mockRepository.createStrict(NavigationController)
         );
      };
      
      
      [After]
      public function tearDown() : void {
         LocalizerUtl.tearDown();
         SingletonFactory.clearAllSingletonInstances();
         ML.reset();
         ML = null;
         loc = null;
         mockRepository = null;
      };
      
      
      [Test]
      public function inBattleground() : void {
         ML.latestGalaxy.battlegroundId = 100;
         
         loc.type = LocationType.GALAXY;
         assertThat( "when galaxy", loc.inBattleground, isFalse() );
         
         loc.type = LocationType.SOLAR_SYSTEM;
         assertThat( "when solar system", loc.inBattleground, isFalse() );
         
         loc.id = ML.latestGalaxy.battlegroundId;
         assertThat( "when battleground", loc.inBattleground, isFalse() );
         
         loc.type = LocationType.SS_OBJECT;
         loc.solarSystemId = 1;
         assertThat( "when ss object not in battleground", loc.inBattleground, isFalse() );
         
         loc.solarSystemId = ML.latestGalaxy.battlegroundId;
         assertThat( "when ss object in battleground", loc.inBattleground, isTrue() );
      }
      
      
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
         wormhole.kind = SSKind.WORMHOLE;
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
         wormhole.kind = SSKind.WORMHOLE;
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
      
      [Test]
      public function namePropertyChange() : void {
         loc.type = LocationType.SS_OBJECT;
         
         assertThat(
            "changing name", function():void{ loc.name = "My home" },
            causesTarget(loc) .toDispatchEvent (LocationEvent.NAME_CHANGE)
         );
         assertThat( "name", loc.name, equals ("My home") );
         assertThat( "planetName", loc.name, equals ("My home") );
      }
      
      [Test]
      public function updateName() : void {
         assertThat(
            "null location ignored", function():void{ Location.updateName(null, 1 , "name") },
            not (throws (Error))
         );
         
         var locMinimal:LocationMinimal = new LocationMinimal();
         locMinimal.id = 1;
         locMinimal.type = LocationType.SS_OBJECT;
         assertThat(
            "not instance of Location ignored", function():void{ Location.updateName(locMinimal, locMinimal.id, "name") },
            not (throws (Error))
         );
         
         loc.id   = 1;
         loc.type = LocationType.GALAXY;
         loc.name = null;
         Location.updateName(loc, loc.id, "name");
         assertThat( "not of LocationType.SS_OBJECT type ignored", loc.name, nullValue() );
         
         loc.type = LocationType.SS_OBJECT;
         Location.updateName(loc, 2, "name");
         assertThat( "not the same location ignored", loc.name, nullValue() );
         
         Location.updateName(loc, 1, "name");
         assertThat( "name should have been changed", loc.name, equals ("name") );
      }
      
      [Test]
      public function autoCreation() : void {
         loc = Objects.create(Location, {"type": LocationType.SS_OBJECT, "player": {"id": 1, "name": "mikism"}});
         assertThat( "not NPC player: id", loc.player.id, equals (1) );
         assertThat( "not NPC player: name", loc.player.name, equals ("mikism") );
         
         loc = Objects.create(Location, {"type": LocationType.SS_OBJECT});
         assertThat( "NPC player", loc.player, sameInstance(PlayerMinimal.NPC_PLAYER) );
      }
   }
}