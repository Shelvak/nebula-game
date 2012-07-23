package tests.movement
{
   import com.adobe.errors.IllegalStateError;

   import config.Config;

   import controllers.units.SquadronsController;

   import ext.hamcrest.collection.array;
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.date.dateEqual;
   import ext.hamcrest.events.causes;
   import ext.hamcrest.object.equals;

   import factories.LocationMinimalBuilder;
   import factories.RouteBuilder;
   import factories.SquadronBuilder;
   import factories.UnitBuilder;
   import factories.newLocation;
   import factories.newRoute;
   import factories.newSquadron;
   import factories.newUnit;

   import models.ModelLocator;
   import models.ModelsCollection;
   import models.Owner;
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.movement.MHop;
   import models.movement.MRoute;
   import models.movement.MSquadron;
   import models.movement.SquadronsList;
   import models.planet.MPlanet;
   import models.planet.events.MPlanetEvent;
   import models.player.PlayerMinimal;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SSObjectType;
   import models.time.MTimeEventFixedMoment;
   import models.unit.Unit;
   import models.unit.UnitBuildingEntry;
   import models.unit.UnitsList;

   import mx.collections.ArrayList;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;

   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.core.allOf;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.hasProperty;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   import org.hamcrest.object.sameInstance;

   import testsutils.LocalizerUtl;

   import utils.DateUtil;
   import utils.Objects;
   import utils.SingletonFactory;


   public final class TC_SquadronsController
   {
      private var squadsCtrl: SquadronsController;
      private var allUnits: UnitsList;
      private var allSquads: SquadronsList;
      private var allRoutes: ModelsCollection;
      private var modelLoc: ModelLocator;

      [Before]
      public function setUp(): void {
         LocalizerUtl.setUp();
         LocalizerUtl.addBundle("Players", {"npc": "NPC"});
         Config.setConfig({
            "units.trooper.guns": [0, 1],
            "units.trooper.kind": "ground",
            "units.dart.guns": [0, 1],
            "units.dart.kind": "space"
         });
         modelLoc = ModelLocator.getInstance();
         squadsCtrl = SquadronsController.getInstance();
         allSquads = modelLoc.squadrons;
         allRoutes = modelLoc.routes;
         allUnits = modelLoc.units;
      }

      [After]
      public function tearDown(): void {
         SingletonFactory.clearAllSingletonInstances();
         LocalizerUtl.tearDown();
         Config.setConfig({});
      }

      /**
       * id = 1
       */
      private function newLoc(): LocationMinimalBuilder {
         return newLocation().id(1);
      }

      [Test]
      public function addHopToSquadron(): void {
         const hop: MHop = newHop(0, 10, 10);
         const anotherHop: MHop = newHop(1, 11, 11);

         assertThat(
            "should ignore hop if there is no squad to add it to",
            function():void{ squadsCtrl.addHopToSquadron(hop) },
            not (throws (Error)) );

         const squad: MSquadron = newSquad(1, 0, 0);
         squad.addHop(hop);
         allSquads.addItem(squad);

         assertThat(
            "should ignore hop if another hop defining same location is already in squad",
            function():void{ squadsCtrl.addHopToSquadron(newHop(1, 10, 10)) },
            not (throws (Error)) );
         assertThat(
            "should not have added the hop with the same location",
            squad.hops, arrayWithSize (1) );

         squadsCtrl.addHopToSquadron(anotherHop);
         assertThat(
            "should have added new hop to squad",
            squad.hops, array (equals(hop), equals(anotherHop))
         );
      }

      [Test]
      public function addHopsToSquadrons(): void {
         const squad: MSquadron = newSquad(1, 0, 0);
         const hop0: MHop = newHop(0, 1, 1);
         const hop1: MHop = newHop(1, 2, 2);
         allSquads.addItem(squad);
         squadsCtrl.addHopsToSquadrons([hop0, hop1]);
         assertThat(
            "should have added all hops to squad",
            MSquadron(allSquads.getFirst()).hops, array (hop0, hop1)
         );
      }

      [Test]
      public function attachJumpsAtToHostileSquads(): void {
         const defaultDate: Date = new Date(10000);

         function $newSquad(id: int, owner: int): MSquadron {
            const squad: MSquadron = newSquad(id, 0, 0, owner);
            const route: MRoute = new MRoute();
            route.id = squad.id;
            route.owner = squad.owner;
            route.jumpsAtEvent = new MTimeEventFixedMoment(defaultDate);
            squad.route = route;
            return squad;
         }

         const squad0: MSquadron = $newSquad(0, Owner.ENEMY);
         const squad1: MSquadron = $newSquad(0, Owner.ALLY);
         const squad2: MSquadron = $newSquad(1, Owner.PLAYER);
         const squad3: MSquadron = $newSquad(2, Owner.ENEMY);
         const squad4: MSquadron = $newSquad(3, Owner.ENEMY);
         const squads: ArrayList = new ArrayList([squad0, squad1, squad2, squad3, squad4]);
         const jumpsAt: Object = {
            "0": "2000-01-01T00:00:00+03:00",
            "1": "2000-01-02T00:00:00+03:00",
            "2": "2000-01-03T00:00:00+03:00"};

         function assertNotChanged(owner: String, movement: String, squad: MSquadron): void {
            assertThat(
               "should not have changed " + owner + " " + movement + " squad",
               squad.route.jumpsAtEvent.occursAt, dateEqual(defaultDate, 0));
         }

         squadsCtrl.attachJumpsAtToHostileSquads(squads, jumpsAt);
         assertNotChanged("hostile", "stationary", squad0);
         assertNotChanged("friendly", "stationary", squad1);
         assertNotChanged("friendly", "moving", squad2);
         assertThat(
            "should have attached new jumpsAtEvent to moving hostile squad",
            squad3.route.jumpsAtEvent.occursAt,
            dateEqual (DateUtil.parseServerDTF("2000-01-03T00:00:00+03:00")));
         assertThat(
            "should have cleared jumpsAtEvent on moving hostile squad",
            squad4.route.jumpsAtEvent, nullValue());
      }
      
      
      /* ############################ */
      /* ### squadron destruction ### */
      /* ############################ */

      [Test]
      public function destroySquadron_inSpace(): void {
         assertThat(
            "should ignore IDs of non-existing squads",
            squadsCtrl.destroySquadron(1), isFalse());

         const triple: Triple = newTriple(1, 1, Owner.NAP, newLoc().inGalaxy().GET);
         const unit: Unit = triple.unit;
         const squad: MSquadron = triple.squad;
         const route: MRoute = triple.route;

         squadsCtrl.destroySquadron(1);
         assertThat( "squadron should have been removed form the list", allSquads, emptyArray() );
         assertThat( "squadron should have been cleaned up", squad.route, nullValue() );
         assertThat( "route should not have been removed form the list", allRoutes, array (route) );
         assertThat( "unit should have been removed from the list", allUnits, emptyArray() );
         assertThat( "unit should have been cleaned up", unit.upgradePart, nullValue() );
      }

      [Test]
      public function destroySquadron_inPlanet_noLatestPlanet(): void {
         newTriple(1, 1, Owner.NAP, newLoc().inSSObject().GET);

         assertThat(
            "should not crash if latest planet is not set",
            function():void{ squadsCtrl.destroySquadron(1) }, not (throws (Error))
         );
      }

      [Test]
      public function destroySquadron_inPlanet_withLatestPlanet(): void {
         const ssObjectLoc: LocationMinimal = newLoc().inSSObject().GET;
         const ssObject:MSSObject = new MSSObject();
         ssObject.id = 1;
         ssObject.type = SSObjectType.PLANET;
         const planet: MPlanet = new MPlanet(ssObject);
         modelLoc.latestPlanet = planet;

         newTriple(1, 1, Owner.NAP, ssObjectLoc);
         newTriple(2, 2, Owner.ENEMY, ssObjectLoc);

         assertThat(
            "should refresh planets units list",
            function():void{ squadsCtrl.destroySquadron(1) },
            causes (planet.units) .toDispatchEvent(
               CollectionEvent.COLLECTION_CHANGE, hasProperty("kind", CollectionEventKind.REFRESH)));
         assertThat(
            "should invalidate planet unit caches",
            function():void{ squadsCtrl.destroySquadron(2) },
            causes (planet) .toDispatchEvent (MPlanetEvent.UNIT_REFRESH_NEEDED));
      }

      private function newTriple(
         unitId: int, squadId: int, owner: int, loc: LocationMinimal): Triple
      {
         const unit: Unit = newUnit().id(unitId).squadronId(squadId).location(loc).GET;
         allUnits.addItem(unit);
         const squad: MSquadron = newSquadron().id(squadId).owner(owner).currentHopFrom(loc).GET;
         allSquads.addItem(squad);
         const route: MRoute = attachRoute(squad);
         allRoutes.addItem(route);
         return new Triple(unit, squad, route);
      }

      private function attachRoute(squad: MSquadron): MRoute {
         const route: MRoute = newRoute().id(squad.id).owner(squad.owner).GET;
         squad.route = route;
         return route;
      }

      private function newSquad(
         id: int, x: int, y: int, owner: int = Owner.PLAYER, playerId: int = 1): MSquadron
      {
         return newSquadron()
            .id(id).owner(owner).player(new PlayerMinimal(playerId, "Test"))
            .currentHopFrom(newLoc().inGalaxy().x(x).y(y).GET)
            .GET;
      }

      private function newHop(index: int, x: int, y: int): MHop {
         const loc: LocationMinimal = newLoc().inGalaxy().x(x).y(y).GET;
         const hop: MHop = new MHop();
         hop.index = index;
         hop.routeId = 1;
         hop.location = loc;
         return hop;
      }
      
      [Test]
      public function destroyEmptySquadrons(): void {
         
         const galaxyLoc: LocationMinimal = newLoc().inGalaxy().GET;
         
         function $unit(): UnitBuilder {
            return new UnitBuilder().id(1).squadronId(1).location(galaxyLoc).type("Dart");
         }
         function $squad(): SquadronBuilder {
            return new SquadronBuilder().id(1).currentHopFrom(galaxyLoc).ownerIsPlayer();
         }
         function $list(... items): ArrayList {
            return new ArrayList(items);
         }
         
         assertThat(
            "should ignore ground units and units not in squad",
            function(): void {
               squadsCtrl.destroyEmptySquadrons(new ArrayList([
                  $unit().id(1).squadronId(1).GET,
                  $unit().id(2).type("Trooper").GET
               ]))
            }, not (throws (Error)));
         
         const route: MRoute = newRoute().id(1).ownerIsPlayer().GET;
         const squadWithRoute: MSquadron = $squad().route(route).GET;
         allRoutes.addItem(route);
         allSquads.addItem(squadWithRoute);
         squadsCtrl.destroyEmptySquadrons($list($unit().squadronId(1).GET));
         assertThat(
            "should have removed empty friendly squad from squadrons list",
            allSquads, emptyArray());
         assertThat(
            "should have removed route of the squadron from routes list",
            allRoutes, emptyArray());
         assertThat(
            "should have cleaned up the squadron",
            squadWithRoute.route, nullValue());
         
         allSquads.addItem($squad().stationary().player(new PlayerMinimal(2, "Test")).GET);
         squadsCtrl.destroyEmptySquadrons($list($unit().stationary().playerId(2).GET));
         assertThat(
            "should have removed empty stationary squad", allSquads, emptyArray());
         
         allSquads.addItem($squad().ownerIsEnemy().GET);
         squadsCtrl.destroyEmptySquadrons($list($unit().GET));
         assertThat(
            "should have removed enemy squad", allSquads, emptyArray());
         
         const squadNotEmpty: MSquadron = $squad().GET; 
         const unitLeft: Unit = $unit().id(1).GET;
         const unitRemoved: Unit = $unit().id(2).GET;
         allSquads.addItem(squadNotEmpty);
         allUnits.addItem(unitLeft);
         squadsCtrl.destroyEmptySquadrons($list(unitRemoved));
         assertThat(
            "should not have removed squadron with units left", allSquads, array (squadNotEmpty));
      }


      /* ####################################### */
      /* ### createRoute(), recreateRoutes() ### */
      /* ####################################### */
      
      private function routeData(
         routeId: int, playerId: int, playerName: String = "Test"): Object
      {
         function locData(x:int, y:int): Object {
            return {"id": 1, "type": LocationType.GALAXY, "x": x, "y": y};
         }
         return {
            "id": routeId,
            "player": {"id": playerId, "name": playerName},
            "status": Owner.PLAYER,
               "arrivesAt": "2000-01-03T00:00:00+03:00",
               "source": locData(0, 0),
               "current": locData(0, 1),
               "target": locData(0, 2),
               "cachedUnits": {
                  "dart": 2,
                  "azure": 5}};
      }
      
      [Test]
      public function createRoute_routeAlreadyExists(): void {
         const data: Object = routeData(1, 1);
         const route: MRoute = Objects.create(MRoute, data);
         allRoutes.addItem(route);

         assertThat(
            "should return existing route if data is the same",
            squadsCtrl.createRoute(data), sameInstance (route));
         assertThat(
            "should have not modified routes list",
            allRoutes, array (route));

         data["status"] = Owner.ENEMY;
         assertThat(
            "should fail when data does not match existing route",
            function():void{ squadsCtrl.createRoute(data) }, throws (IllegalStateError));
      }
      
      [Test]
      public function createRoute_noExistingRoute(): void {
         const data: Object = routeData(1, 1);
         var route: MRoute;
         
         route = squadsCtrl.createRoute(data);
         assertThat( "should have returned the route instance created", route, notNullValue() );
         assertThat( "should have added the route to routes list", allRoutes, array (route) );
         assertThat( "should have created cached units", route.cachedUnits, hasItems(
            equals (new UnitBuildingEntry("Unit::Dart", 2)),
            equals (new UnitBuildingEntry("Unit::Azure", 5)) ));
         assertThat(
            "should have not changed owner of the route",
            route.owner, equals (Owner.PLAYER));
         
         allRoutes.removeAll();
         route = squadsCtrl.createRoute(data, Owner.ENEMY);
         assertThat( "should have changed owner of the route", route.owner, equals (Owner.ENEMY) );
      }
      
      [Test]
      public function recreateRoutes(): void {
         allSquads.addItem(newSquad(1, 0, 0));
         allRoutes.addItem(new MRoute());
         
         modelLoc.player.id = 1;
         modelLoc.player.name = "Me";
         
         const routeData0: Object = routeData(1, 1);
         delete routeData0["player"]; routeData0["playerId"] = 1;
         
         const routeData1: Object = routeData(2, 2);
         delete routeData1["player"]; routeData1["playerId"] = 2;
         
         const routes: Array = [routeData0, routeData1];
         const players: Object = {"1": {"id": 1, "name": "Me"}, "2": {"id": 2, "name": "Ally"}};
         
         squadsCtrl.recreateRoutes(routes, players);
         
         assertThat( "should have removed all old routes and added new ones", allRoutes, arrayWithSize(2) );
         assertThat( "should have set players for both routes", allRoutes, hasItems(
            hasProperty("player", equals (new PlayerMinimal(1, "Me"))),
            hasProperty("player", equals (new PlayerMinimal(2, "Ally"))) ));
         assertThat(
            "should have attached routes to squads",
            MSquadron(allSquads.getFirst()).route, allOf(
               notNullValue(),
               hasProperty ("id", 1)
            ));
      }

      [Test]
      public function createSquadronsForUnits(): void {
         const galaxyLoc: LocationMinimal = new LocationMinimal(LocationType.GALAXY, 1);
         const galaxy: Galaxy = new Galaxy();
         galaxy.id = 1;

         function $list(... args): ArrayList {
            return new ArrayList(args);
         }

         function $unit(): UnitBuilder {
            return new UnitBuilder()
               .type("Dart")
               .player(new PlayerMinimal(1, "Test"))
               .ownerIsPlayer()
               .level(1)
               .hp(100)
               .squadronId(1)
               .location(galaxyLoc);
         }

         squadsCtrl.createSquadronsForUnits(
            $list(
               $unit().id(1).type("Trooper").GET,
               $unit().id(2).stationary().location(null).GET,
               $unit().id(3).stationary().location(new LocationMinimal(LocationType.SS_OBJECT, 1)).GET),
            galaxy);
         assertThat(
            "should skip ground, stationary units without location and stationary units in a planet",
            allSquads, emptyArray());

         const route: MRoute = new RouteBuilder().id(1).ownerIsPlayer().GET;
         allRoutes.addItem(route);
         squadsCtrl.createSquadronsForUnits(
            $list(
               $unit().id(1).squadronId(1).GET,
               $unit().id(2).stationary().GET,
               $unit().id(3).squadronId(2).ownerIsEnemy().GET),
            galaxy);
         const squad1: MSquadron = allSquads.find(1);
         assertThat("should have created squad 1", squad1, notNullValue());
         assertThat("should have attached route to squad 1", squad1.route, equals (route));
         const squad0: MSquadron = allSquads.findStationary(galaxyLoc, 1);
         assertThat("should have created stationary squad", squad0, notNullValue());
         const squad2: MSquadron = allSquads.find(2);
         assertThat("should have created hostile squad", squad2, notNullValue());
         assertThat("should have created route for hostile squad", squad2.route, notNullValue());
         assertThat("should not have added hostile route to routes list", allRoutes, arrayWithSize(1));
      }


      /* ####################### */
      /* ### Complex methods ### */
      /* ####################### */

      [Ignore]
      [Test]
      public function executeJump(): void {
      }

      [Ignore]
      [Test]
      public function updateRoute(): void {
      }

      [Ignore]
      [Test]
      public function stopSquadron(): void {
      }

      [Ignore]
      [Test]
      public function startMovement(): void {

      }
   }
}


import models.movement.MRoute;
import models.movement.MSquadron;
import models.unit.Unit;


class Triple
{
   public function Triple(unit: Unit, squad: MSquadron, route: MRoute) {
      this.unit = unit;
      this.squad = squad;
      this.route = route;
   }

   public var unit: Unit;
   public var squad: MSquadron;
   public var route: MRoute
}