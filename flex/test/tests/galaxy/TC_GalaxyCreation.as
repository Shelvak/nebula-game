package tests.galaxy
{
   import config.Config;
   
   import controllers.galaxies.actions.ShowAction;
   import controllers.units.SquadronsController;
   
   import ext.hamcrest.object.equals;
   
   import models.MWreckage;
   import models.ModelLocator;
   import models.Owner;
   import models.cooldown.MCooldownSpace;
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.MapArea;
   import models.movement.MHop;
   import models.movement.MRoute;
   import models.movement.MSquadron;
   import models.planet.MPlanet;
   import models.player.PlayerId;
   import models.player.PlayerMinimal;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSKind;
   import models.solarsystem.SSObjectType;
   import models.solarsystem.MSolarSystem;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   import org.hamcrest.object.sameInstance;
   
   import utils.SingletonFactory;
   import utils.datastructures.Collections;

   public class TC_GalaxyCreation
   {
      private static const GALAXY_ID:int = 1;
      private static const BATTLEGROUND_ID:int = 100;
      private static const PID_PLAYER:int = 1;
      private static const PID_ALLY:int = 2;
      private static const PID_ENEMY:int = 3;
      
      private var showAction:ShowAction;
      
      [Before]
      public function setUp() : void {
         Config.setConfig({
            "units.trooper.kind": "space"
         });
         showAction = new ShowAction();
      }
      
      [After]
      public function tearDown() : void {
         showAction = null;
         SingletonFactory.clearAllSingletonInstances();
      }
      
      
      [Test]
      public function createGalaxy() : void {
         ML.routes.addAll(new ArrayCollection([
            makeRoute(1),
            makeRoute(2)
         ]));
         showAction.createGalaxy(
            GALAXY_ID,
            BATTLEGROUND_ID,
            [  // fow entries
               new MapArea(-5, 5, -5, 5)
            ],
            new ArrayCollection([  // solar systems
               makeSS(1, 0, 0),
               makeSS(2, 0, 1)
            ]),
            new ArrayCollection([  // wreckages
               makeWreck(1, 2, 2),
               makeWreck(2, 3, 3)
            ]),
            new ArrayCollection([  // cooldowns
               makeCool(1, -1, -1)
            ]),
            new ArrayCollection([  // units
               makeUnit(1, PID_PLAYER, 0, 0, 0),
               makeUnit(2, PID_PLAYER, 1, 0, 0),
               makeUnit(3, PID_PLAYER, 1, 0, 0),
               makeUnit(4, PID_PLAYER, 2, 0, 3),
               makeUnit(5, PID_ENEMY, 0, 0, 1),
               makeUnit(6, PID_ENEMY, 3, 0, 2)
            ]),
            [  // hops
               makeHop(1, 3, 0, 3, new Date(2000, 1, 1))
            ],
            // non-friendly routes
            new Object()
         );
         
         assertThat( "galaxy created", galaxy, notNullValue() );
         assertThat( "galaxy id", galaxy.id, equals (GALAXY_ID) );
         assertThat( "battleground id", galaxy.battlegroundId, equals (BATTLEGROUND_ID) );
         
         assertThat( "galaxy bounds created", galaxy.bounds, notNullValue() );
         assertThat( "galaxy width", galaxy.bounds.width, equals (15) );
         assertThat( "galaxy height", galaxy.bounds.height, equals (15) );
         
         assertThat( "# of static objects", galaxy.objects, arrayWithSize (5) );
         
         assertThat( "# of natural objects", galaxy.naturalObjects, arrayWithSize (2) );
         assertThat( "has SS 1", galaxy.getSSById(1), notNullValue() );
         assertThat( "has SS 2", galaxy.getSSById(2), notNullValue() );
         
         assertThat( "# of wrecks", galaxy.wreckages, arrayWithSize (2) );
         assertThat( "has wreck 1", find(galaxy.wreckages, 1), notNullValue() );
         assertThat( "has wreck 2", find(galaxy.wreckages, 2), notNullValue() );
         
         assertThat( "# of cooldowns", galaxy.cooldowns, arrayWithSize (1) );
         assertThat( "has cooldown 1", find(galaxy.cooldowns, 1), notNullValue() );
         
         assertThat( "# of units in game", ML.units, arrayWithSize (6) );
         assertThat( "# of units in galaxy", galaxy.units, arrayWithSize (6) );
         assertThat( "has unit 1", findGalaxyUnit(1), notNullValue() );
         assertThat( "has unit 2", findGalaxyUnit(2), notNullValue() );
         assertThat( "has unit 3", findGalaxyUnit(3), notNullValue() );
         assertThat( "has unit 4", findGalaxyUnit(4), notNullValue() );
         assertThat( "has unit 5", findGalaxyUnit(5), notNullValue() );
         assertThat( "has unit 6", findGalaxyUnit(6), notNullValue() );
         
         var squad:MSquadron;
         assertThat( "# of routes in game", ML.routes, arrayWithSize (2) );
         assertThat( "# of squads in game", ML.squadrons, arrayWithSize (5) );
         assertThat( "# of squads in galaxy", galaxy.squadrons, arrayWithSize (5) );
         
         squad = findGalaxySquad(1);
         assertThat( "has squad 1", squad, notNullValue() );
         assertThat( "squad 1 is moving", squad.isMoving, isTrue() );
         assertThat( "squad 1 has route 1", squad.route.id, equals (1) );
         assertThat( "squad 1 has unit 2", find(squad.units, 2), notNullValue() );
         assertThat( "squad 1 has unit 3", find(squad.units, 3), notNullValue() );
         
         squad = findGalaxySquad(2);
         assertThat( "has squad 2", squad, notNullValue() );
         assertThat( "squad 2 is moving", squad.isMoving, isTrue() );
         assertThat( "squad 2 has route 2", squad.route.id, equals (2) );
         assertThat( "squad 2 has unit 4", find(squad.units, 4), notNullValue() );
         
         squad = findGalaxySquad(3);
         assertThat( "has squad 3", squad, notNullValue() );
         assertThat( "squad 3 is moving", squad.isMoving, isTrue() );
         assertThat( "squad 3 has one hop", squad.hops, arrayWithSize (1) );
         assertThat( "next hop of squad 3", squad.nextHop.id, equals (1) );
         assertThat( "squad 3 has route 3", squad.route.id, equals(3) );
         assertThat( "squad 3 has unit 6", find(squad.units, 6), notNullValue() );
         
         squad = findGalaxySquad(0, PID_PLAYER, makeGalaxyLoc(0, 0));
         assertThat( "has player squad at 0:0", squad, notNullValue() );
         assertThat( "player squad is stationary", squad.isMoving, isFalse() );
         assertThat( "player squad has unit 1", find(squad.units, 1), notNullValue() );
         
         squad = findGalaxySquad(0, PID_ENEMY, makeGalaxyLoc(0, 1));
         assertThat( "has enemy squad at 0:1", squad, notNullValue() );
         assertThat( "enemy squad is stationary", squad.isMoving, isFalse() );
         assertThat( "enemy squad has unit 5", find(squad.units, 5), notNullValue() );
      }
      
      [Test]
      public function createGalaxyInvalidatesOldGalaxy() : void {
         var g:Galaxy = new Galaxy();
         g.id = GALAXY_ID;
         g.battlegroundId = BATTLEGROUND_ID;
         g.addObject(makeSS(1, 0, 0));
         g.addObject(makeWreck(1, 0, 0));
         g.addObject(makeCool(1, 0, 0));
         ML.units.addItem(makeUnit(1, PID_PLAYER, 1, 0, 0));
         ML.units.addItem(makeUnit(2, PID_ENEMY, 2, 0, 0));
         ML.units.addItem(makeUnit(3, PID_ALLY, 0, 0, 1));
         squadsCtrl.createSquadronsForUnits(ML.units, g);
         ML.latestGalaxy = g;
         
         createEmptyGalaxy();
         
         assertThat( "old units removed", ML.units, emptyArray() );
         assertThat( "old units removed", galaxy.units, emptyArray() );
         assertThat( "old squadrons removed", ML.squadrons, emptyArray() );
         assertThat( "old squadrons removed", galaxy.squadrons, emptyArray() );
         assertThat( "old solar systems removed", galaxy.solarSystems, emptyArray() );
         assertThat( "old wreckages removed", galaxy.wreckages, emptyArray() );
         assertThat( "old cooldowns removed", galaxy.cooldowns, emptyArray() );
      }
      
      [Test]
      public function createGalaxyInvalidatesChachedSolarSystemIfItIsNotVisible() : void {
         function makeUnit(id:int) : Unit {
            var unit:Unit = new Unit();
            unit.type == "Trooper";
            unit.id = id;
            unit.squadronId = id;
            unit.location = makeLoc(1, LocationType.SOLAR_SYSTEM, 0, 0);
            return unit;
         }
         var ss:MSolarSystem = makeSS(1, 0, 0);
         ss.units.addItem(makeUnit(1));
         ss.units.addItem(makeUnit(2));
         squadsCtrl.createSquadronsForUnits(ss.units, ss);
         var g:Galaxy = new Galaxy();
         g.id = GALAXY_ID;
         g.battlegroundId = BATTLEGROUND_ID;
         g.addObject(ss);
         ML.latestGalaxy = g;
         ML.latestSSMap = ss;
         
         createEmptyGalaxy();
         
         assertThat( "old units removed", ML.units, emptyArray() );
         assertThat( "old squadrons removed", ML.squadrons, emptyArray() );
         assertThat( "old solar systems removed", galaxy.solarSystems, emptyArray() );
         assertThat( "cached solar system destroyed", ML.latestSSMap, nullValue() );
      }
      
      [Test]
      public function createGalaxyLeavesCachedSolarSystemIfItIsVisible() : void {
         var ss:MSolarSystem = makeSS(1, 0, 0);
         var g:Galaxy = new Galaxy();
         g.id = GALAXY_ID;
         g.battlegroundId = BATTLEGROUND_ID;
         g.addObject(ss);
         ML.latestGalaxy = g;
         ML.latestSSMap = ss;
         
         showAction.createGalaxy(
            GALAXY_ID,
            BATTLEGROUND_ID,
            new Array(),
            new ArrayCollection([makeSS(1, 0, 0)]),
            new ArrayCollection(),
            new ArrayCollection(),
            new ArrayCollection(),
            new Array(),
            new Object()
         );
         
         assertThat( "cached solar system is the same", ML.latestSSMap, sameInstance (ss) );
      }
      
      [Test]
      public function createGalaxyInvalidatesChachedPlanetIfSolarSystemIsNotVisible() : void {
         function makeUnit(id:int) : Unit {
            var unit:Unit = new Unit();
            unit.type == "Trooper";
            unit.id = id;
            unit.squadronId = id;
            unit.location = makeLoc(1, LocationType.SS_OBJECT, 0, 0);
            return unit;
         }
         var ssObj:MSSObject = new MSSObject();
         ssObj.id = 1;
         ssObj.type = SSObjectType.PLANET;
         ssObj.solarSystemId = 1;
         var planet:MPlanet = new MPlanet(ssObj);
         planet.units.addItem(makeUnit(1));
         planet.units.addItem(makeUnit(2));
         squadsCtrl.createSquadronsForUnits(planet.units, planet);
         var ss:MSolarSystem = makeSS(1, 0, 0);
         ss.addObject(ssObj);
         var g:Galaxy = new Galaxy();
         g.id = GALAXY_ID;
         g.battlegroundId = BATTLEGROUND_ID;
         g.addObject(makeSS(1, 0, 0));
         ML.latestGalaxy = g;
         ML.latestSSMap = ss;
         ML.latestPlanet = planet;
         
         createEmptyGalaxy();
         
         assertThat( "old units removed", ML.units, emptyArray() );
         assertThat( "old squadrons removed", ML.squadrons, emptyArray() );
         assertThat( "old solar systems removed", galaxy.solarSystems, emptyArray() );
         assertThat( "cached solar system destroyed", ML.latestSSMap, nullValue() );
         assertThat( "cached planet destroyed", ML.latestPlanet, nullValue() );
      }
      
      [Test]
      public function createGalaxyLeavesChachedPlanetIfSolarSystemIsVisible() : void {
         var ssObj:MSSObject = new MSSObject();
         ssObj.id = 1;
         ssObj.type = SSObjectType.PLANET;
         ssObj.solarSystemId = 1;
         var planet:MPlanet = new MPlanet(ssObj);
         var ss:MSolarSystem = makeSS(1, 0, 0);
         ss.addObject(ssObj);
         var g:Galaxy = new Galaxy();
         g.id = GALAXY_ID;
         g.battlegroundId = BATTLEGROUND_ID;
         g.addObject(makeSS(1, 0, 0));
         ML.latestGalaxy = g;
         ML.latestSSMap = ss;
         ML.latestPlanet = planet;
         
         showAction.createGalaxy(
            GALAXY_ID,
            BATTLEGROUND_ID,
            new Array(),
            new ArrayCollection([makeSS(1, 0, 0)]),
            new ArrayCollection(),
            new ArrayCollection(),
            new ArrayCollection(),
            new Array(),
            new Object()
         );
         
         assertThat( "# of solar systems", galaxy.solarSystems, arrayWithSize (1) );
         assertThat( "solar system in galaxy created", galaxy.getSSById(1), notNullValue() );
         assertThat( "cached solar system is the same", ML.latestSSMap, sameInstance (ss) );
         assertThat( "cached planet is the same", ML.latestPlanet, sameInstance (planet) );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
      }
      
      private function get squadsCtrl() : SquadronsController {
         return SquadronsController.getInstance();
      }
      
      private function get galaxy() : Galaxy {
         return ML.latestGalaxy;
      }
      
      private function createEmptyGalaxy() : void {
         showAction.createGalaxy(
            GALAXY_ID,
            BATTLEGROUND_ID,
            new Array(),            // fow entries
            new ArrayCollection(),  // solar systems
            new ArrayCollection(),  // wreckages
            new ArrayCollection(),  // cooldowns
            new ArrayCollection(),  // units
            new Array(),            // hops
            new Object()            // non-friendly routes
         );
      }
      
      private function find(list:IList, id:int) : * {
         return Collections.findFirstWithId(list, id);
      }
      
      private function findGalaxyUnit(id:int) : Unit {
         return find(galaxy.units, id);
      }
      
      private function findGalaxySquad(id:int, playerId:int = 0, loc:LocationMinimal = null) : MSquadron {
         return Collections.findFirst(galaxy.squadrons,
            function(squad:MSquadron) : Boolean {
               return squad.id == id &&
                  (id == 0 ? squad.player.id == playerId && squad.currentHop.location.equals(loc) : true)
            }
         );
      }
      
      private function makeSS(id:int, x:int, y:int, kind:int = SSKind.NORMAL) : MSolarSystem {
         var ss:MSolarSystem = new MSolarSystem();
         ss.id = id;
         ss.x = x;
         ss.y = y;
         ss.kind = kind;
         return ss;
      }
      
      private function makeWreck(id:int, x:int, y:int) : MWreckage {
         var wreck:MWreckage = new MWreckage();
         wreck.id = id;
         wreck.currentLocation = makeGalaxyLoc(x, y);
         return wreck;
      }
      
      private function makeCool(id:int, x:int, y:int) :  MCooldownSpace {
         var cool:MCooldownSpace = new MCooldownSpace();
         cool.id = id;
         cool.currentLocation = makeGalaxyLoc(x, y);
         return cool;
      }
      
      private function makeUnit(id:int, playerId:int, squadronId:int, x:int, y:int) : Unit {
         var unit:Unit = new Unit();
         unit.id = id;
         unit.level = 1;
         unit.type = "Trooper";
         unit.playerId = playerId;
         var playerName:String = "NPC";
         switch (playerId) {
            case PID_PLAYER: playerName = "mikism"; break;
            case PID_ENEMY: playerName = "arturaz"; break;
            case PID_ALLY: playerName = "jho"; break;
         }
         unit.player = makePlayer(playerId, playerName);
         unit.owner = Owner.NPC;
         switch (playerId) {
            case PID_PLAYER: unit.owner = Owner.PLAYER; break;
            case PID_ENEMY: unit.owner = Owner.ENEMY; break;
            case PID_ALLY: unit.owner = Owner.ALLY; break;
         }
         unit.squadronId = squadronId;
         unit.location = makeGalaxyLoc(x, y);
         return unit;
      }
      
      private function makeHop(id:int, routeId:int, x:int, y:int, arrivesAt:Date) : MHop {
         var hop:MHop = new MHop();
         hop.id = id;
         hop.routeId = routeId;
         hop.location = makeGalaxyLoc(x, y);
         hop.arrivesAt = arrivesAt;
         return hop;
      }
      
      private function makeLoc(id:int, type:uint, x:int, y:int) : LocationMinimal {
         var loc:LocationMinimal = new LocationMinimal();
         loc.id = id;
         loc.type = type;
         loc.x = x;
         loc.y = y;
         return loc;
      }
      
      private function makeGalaxyLoc(x:int, y:int) : LocationMinimal {
         return makeLoc(GALAXY_ID, LocationType.GALAXY, x, y);
      }
      
      private function makePlayer(id:int, name:String = null) : PlayerMinimal {
         if (id == PlayerId.NO_PLAYER)
            return PlayerMinimal.NPC_PLAYER;
         var p:PlayerMinimal = new PlayerMinimal();
         p.id = id;
         p.name = name;
         return p;
      }
      
      private function makeRoute(id:int) : MRoute {
         var route:MRoute = new MRoute();
         route.id = id;
         return route;
      }
   }
}