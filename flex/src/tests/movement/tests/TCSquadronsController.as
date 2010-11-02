package tests.movement.tests
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import components.map.space.CMapGalaxy;
   import components.map.space.CMapSolarSystem;
   
   import config.Config;
   
   import controllers.units.SquadronsController;
   
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.object.equals;
   
   import models.ModelLocator;
   import models.ModelsCollection;
   import models.Owner;
   import models.galaxy.Galaxy;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.Map;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.planet.Planet;
   import models.solarsystem.SolarSystem;
   import models.unit.Unit;
   import models.unit.UnitEntry;
   import models.unit.UnitKind;
   
   import mx.collections.ArrayCollection;
   import mx.events.FlexEvent;
   
   import namespaces.client_internal;
   
   import org.fluint.uiImpersonation.UIImpersonator;
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.emptyArray;
   import org.hamcrest.collection.everyItem;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.allOf;
   import org.hamcrest.core.anyOf;
   import org.hamcrest.core.not;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.hasProperty;

   
   public class TCSquadronsController
   {
      [BeforeClass]
      public static function setUpClass() : void
      {
         Config.client_internal::getUnitKind = function(type:String) : String { return UnitKind.SPACE };
      }
      
      
      [AfterClass]
      public static function tearDownClass() : void
      {
         Config.client_internal::getUnitKind = function(type:String) : String { return Config.getUnitProperty(type, "kind"); };
      }
      
      
      include "../../asyncHelpers.as";
      include "../../asyncSequenceHelpers.as";
      
      
      private var _controller:SquadronsController;
      
      private var _modelLoc:ModelLocator;
      
      /**
       * <pre>
       * squadrons:
       * &nbsp;in galaxy:
       * &nbsp;&nbsp;{id: 0, playerId: 1, owner: enemy, x: 0, y:0}
       * &nbsp;&nbsp;{id: 1, playerId: 1, owner: enemy, x: 0, y:0, hops: [1; 1] [2; 2] }
       * &nbsp;&nbsp;{id: 0, playerId: 2, owner: player, x: 2, y:2}
       * &nbsp;&nbsp;{id: 2, playerId: 2, owner: player, x: 2, y:2, hops: [1; 1] [0; 0]}
       * &nbsp;&nbsp;{id: 3, playerId: 3, owner: nap, x: 4, y:4}
       * &nbsp;in solar system:
       * &nbsp;&nbsp;{id: 4, playerId: 4, owner: ally, x: 0, y:0}
       * </pre>
       */
      private var _squads:ModelsCollection;
      
      /**
       * <pre>
       * id: 1,
       * size: 5x5,
       * solar systems:
       * &nbsp;{id:1,  x:0,  y:0}
       * &nbsp;{id:2,  x:0,  y:4}
       * &nbsp;{id:3,  x:4,  y:0}
       * &nbsp;{id:4,  x:4,  y:4}
       * </pre>
       */
      private var _galaxy:Galaxy;
      /**
       * <pre>
       * id: 1,
       * orbits: 5,
       * planets:
       * &nbsp;{id:1, position:0, angle:0}
       * &nbsp;{id:2, position:4, angle:180}
       * </pre>
       */
      private var _solarSystem:SolarSystem;
      /**
       * <pre>
       * id: 1
       * </pre>
       */
      private var _planet:Planet;
      
      
      [Before]
      public function setUp() : void
      {
         runner = new SequenceRunner(this);
         _modelLoc = ModelLocator.getInstance();
         _controller = SquadronsController.getInstance();
         var solarSystem:SolarSystem;
         _galaxy = new Galaxy();
         _galaxy.id = 1;
         solarSystem = getSolarSystem(1, 0, 0);
         _planet = getPlanet(1, 0, 0);
         _modelLoc.latestPlanet = _planet;
         solarSystem.addObject(_planet);
         solarSystem.addObject(getPlanet(2, 4, 180));
         _solarSystem = solarSystem;
         _modelLoc.latestSolarSystem = _solarSystem;
         _galaxy.addSolarSystem(_solarSystem);
         _galaxy.addSolarSystem(getSolarSystem(2, 0, 4));
         _galaxy.addSolarSystem(getSolarSystem(3, 4, 0));
         _galaxy.addSolarSystem(getSolarSystem(4, 4, 4));
         _galaxy.client_internal::setMinMaxProperties();
         _modelLoc.latestGalaxy = _galaxy;
         _modelLoc.squadrons.addAll(new ModelsCollection([
            // Two squadrons that are not moving in galaxy
            getSquadron(0, 1, Owner.ENEMY, getGalaxyLocation(0, 0)),
            getSquadron(0, 2, Owner.PLAYER, getGalaxyLocation(2, 2)),
            // Two squadrons that are moving in galaxy
            getSquadron(1, 1, Owner.ENEMY, getGalaxyLocation(0, 0), [
               getHop(1, getGalaxyLocation(1, 1)),
               getHop(2, getGalaxyLocation(2, 2))
            ]),
            getSquadron(2, 2, Owner.PLAYER, getGalaxyLocation(2, 2), [
               getHop(1, getGalaxyLocation(1, 1)),
               getHop(2, getGalaxyLocation(0, 0))
            ]),
            // Third squadron which is moving in galaxy, but next hop is unknown
            getSquadron(3, 3, Owner.NAP, getGalaxyLocation(4, 4)),
            // One squadron that is not moving in solar system
            getSquadron(0, 4, Owner.ALLY, getSolarSystemLocation(1, 0, 0))
         ]));
         _squads = _modelLoc.squadrons;
         addSquadronsToMMap(_galaxy);
         addSquadronsToMMap(_solarSystem);
         addSquadronsToMMap(_planet);
      };
      
      
      [After]
      public function tearDown() : void
      {
         SingletonFactory.clearAllSingletonInstances();
         UIImpersonator.removeAllChildren();
      };
      
      
      [Test]
      public function whenUnitsReceivedShouldDistributeThemToExistingSquadrons() : void
      {
         var units:ModelsCollection = new ModelsCollection([
            getUnit(1, 0, 1, Owner.ENEMY, getGalaxyLocation(0, 0)),
            getUnit(2, 1, 1, Owner.ENEMY, getGalaxyLocation(0, 0))
         ]);
         _controller.distributeUnitsToSquadrons(units, _galaxy);
         assertThat( MSquadron(_squads.getItemAt(0)).units, hasItem (units.getItemAt(0)) );
         assertThat( MSquadron(_squads.getItemAt(2)).units, hasItem (units.getItemAt(1)) );
      };
      
      
      [Test]
      public function whenUnitsReceivedShouldCreateSquadronsForThoseThatDoNotHaveThemCreatedYet() : void
      {
         var units:Array = [
            getUnit(1, 0, 1, Owner.ENEMY, getGalaxyLocation(2, 2)),
            getUnit(2, 4, 2, Owner.PLAYER, getSolarSystemLocation(1, 0, 90))
         ];
         _controller.distributeUnitsToSquadrons(new ModelsCollection([units[0]]), _galaxy);
         _controller.distributeUnitsToSquadrons(new ModelsCollection([units[1]]), _solarSystem);
         assertThat( _squads, hasItems(
            hasProperties({
               "id": 0,
               "owner": Owner.ENEMY,
               "currentHop": hasProperty( "location", equals (getGalaxyLocation(2, 2)) ),
               "units": hasItem (units[0])
            }),
            hasProperties({
               "id": 4,
               "owner": Owner.PLAYER,
               "currentHop": hasProperty( "location", equals (getSolarSystemLocation(1, 0, 90)) ),
               "units": hasItem (units[1])
            })
         ));
      };
      
      
      [Test]
      public function unitsReceivedAlreadyInSquadronsShouldBeIgnored() : void
      {
         MSquadron(_squads.getItemAt(0)).units.addItem(getUnit(1, 0, 1, Owner.ENEMY, getGalaxyLocation(0, 0)));
         MSquadron(_squads.getItemAt(2)).units.addItem(getUnit(2, 1, 1, Owner.ENEMY, getGalaxyLocation(0, 0)));
         
         _controller.distributeUnitsToSquadrons(
            new ModelsCollection([
               getUnit(1, 0, 1, Owner.ENEMY, getGalaxyLocation(0, 0), "Trooper"),
               getUnit(2, 1, 2, Owner.PLAYER, getGalaxyLocation(0, 0))
            ]), _galaxy
         );
         
         // Unit.type and Unit.playerId are used to ensure controller does not call ModelLocator.squadrons.addItem()
         // since that would update existing models and change the values of these properties
         assertThat( MSquadron(_squads.getItemAt(0)).units, allOf(
            arrayWithSize(1),
            hasItem (hasProperty ("type", "") )
         ));
         assertThat( MSquadron(_squads.getItemAt(2)).units, allOf(
            arrayWithSize(1),
            hasItem (hasProperty ("playerId", 1) )
         ));
      };
      
      
      [Test]
      public function newlyCreatedSquadronModelShouldNotBeAddedToFakeMap() : void
      {
         _galaxy.fake = _solarSystem.fake = _planet.fake = true;
         _controller.distributeUnitsToSquadrons(
            new ModelsCollection([getUnit(1, 10, 1, Owner.ENEMY, getGalaxyLocation(2, 2))]),
            _galaxy
         );
         _controller.distributeUnitsToSquadrons(
            new ModelsCollection([getUnit(2, 11, 2, Owner.PLAYER, getSolarSystemLocation(1, 0, 0))]),
            _solarSystem
         );
         _controller.distributeUnitsToSquadrons(
            new ModelsCollection([getUnit(3, 12, 2, Owner.PLAYER, getPlanetLocation(1, 0, 0))]),
            _planet
         );
         
         assertThat(
            [_galaxy.squadrons, _solarSystem.squadrons, _planet.squadrons],
            everyItem (not (hasItem (anyOf (
               hasProperty ("id", 10),
               hasProperty ("id", 11),
               hasProperty ("id", 12)
            ))))
         );
      };
      
      
      [Test]
      public function newlyCreatedSquadronModelShouldNotBeAddedToMapOfDifferentLocation() : void
      {
         _controller.distributeUnitsToSquadrons(
            new ModelsCollection([getUnit(1, 10, 1, Owner.ENEMY, getGalaxyLocation(2, 2, 2))]),
            _galaxy
         );
         _controller.distributeUnitsToSquadrons(
            new ModelsCollection([getUnit(2, 11, 2, Owner.PLAYER, getSolarSystemLocation(2, 0, 0))]),
            _solarSystem
         );
         _controller.distributeUnitsToSquadrons(
            new ModelsCollection([getUnit(3, 12, 2, Owner.PLAYER, getPlanetLocation(2, 0, 0))]),
            _planet
         );
         
         assertThat(
            [_galaxy.squadrons, _solarSystem.squadrons, _planet.squadrons],
            everyItem (not (hasItem (anyOf (
               hasProperty ("id", 10),
               hasProperty ("id", 11),
               hasProperty ("id", 12)
            ))))
         );
      };
      
      
      [Test]
      public function newlyCreatedSquadronShouldBeAddedToMapDefiningSquadronLocation() : void
      {
         _controller.distributeUnitsToSquadrons(
            new ModelsCollection([getUnit(1, 10, 1, Owner.ENEMY, getGalaxyLocation(0, 0))]),
            _galaxy
         );
         _controller.distributeUnitsToSquadrons(
            new ModelsCollection([getUnit(2, 11, 2, Owner.PLAYER, getSolarSystemLocation(1, 0, 0))]),
            _solarSystem
         );
         
         assertThat( _galaxy.squadrons, allOf(
            arrayWithSize(6),
            hasItem (hasProperty ("id", 10))
         ));
         assertThat( _solarSystem.squadrons, allOf(
            arrayWithSize(2),
            hasItem (hasProperty ("id", 11))
         ));
      };
      
      
      [Test]
      public function onlyMovingNewlyCreatedSquadronShouldBeAddedToPlanetMap() : void
      {
         _controller.distributeUnitsToSquadrons(
            new ModelsCollection([
               getUnit(1, 0, 2, Owner.PLAYER, getPlanetLocation(1, 0, 0)),
               getUnit(1, 10, 2, Owner.PLAYER, getPlanetLocation(1, 0, 0))
            ]), _planet
         );
         
         assertThat( _planet.squadrons, allOf(
            hasItem (hasProperty ("id", 10)),
            not (hasItem (hasProperty ("id", 0)))
         ));
      };
      
      
      [Test(async, timeout=1000)]
      /**
       * When map asks, controller should create all squadron idicators for that map. It should add
       * only those squadrons that are supposed to be on the map.
       */
      public function shouldCreateAllSquadronIndicatorsOnSpaceMap() : void
      {
         // Preconditions: all squadron models have been added to ModelLocator
         var mapGalaxy:CMapGalaxy = new CMapGalaxy(_galaxy);
         addCall(function():void{ UIImpersonator.addChild(mapGalaxy) });
         addWaitFor(mapGalaxy, FlexEvent.CREATION_COMPLETE, 100);
         
         addCall(function():void{
            var squadComps:ArrayCollection = mapGalaxy.getSquadronObjects();
            assertThat( squadComps, arrayWithSize (3) )
            assertThat( squadComps, hasItems(
               hasProperties({
                  "currentLocation": equals (getGalaxyLocation(0, 0)),
                  "squadronsOwner": (Owner.ENEMY),
                  "squadrons": allOf(
                     hasItems (_squads.getItemAt(0), _squads.getItemAt(2)),
                     not (hasItems (_squads.getItemAt(1), _squads.getItemAt(3)))
                  )
               }),
               hasProperties({
                  "currentLocation": equals (getGalaxyLocation(2, 2)),
                  "squadronsOwner": (Owner.PLAYER),
                  "squadrons": allOf(
                     hasItems (_squads.getItemAt(1), _squads.getItemAt(3)),
                     not (hasItems( _squads.getItemAt(0), _squads.getItemAt(2)))
                  )
               }),
               hasProperties({
                  "currentLocation": equals (getGalaxyLocation(4, 4)),
                  "squadronsOwner": (Owner.NAP),
                  "squadrons": allOf(
                     hasItems (_squads.getItemAt(4)),
                     not (hasItems (_squads.getItemAt(0), _squads.getItemAt(1), _squads.getItemAt(2), _squads.getItemAt(3)))
                  )
               })
            ));
         });
         runner.run();
      };
      
      
      [Test]
      public function shouldRemoveHostileAndAllStationarySquadronsInGivenMapFromListInModelLocator() : void
      {
         _controller.removeHostileAndStationarySquadronsFromList(_galaxy);
         
         assertThat( _squads, arrayWithSize(2) );
         assertThat( _squads, not (hasItems(
            hasProperties ({"id": 0, "owner": Owner.ENEMY}),
            hasProperties ({"id": 0, "owner": Owner.PLAYER}),
            hasProperty ("id", 1),
            hasProperty ("id", 3)
         )));
         assertThat( _squads, hasItems (_solarSystem.squadrons) );
         assertThat( _squads, hasItems(
            hasProperty ("id", 2)
         ));
      };
      
      
      [Test(async, timeout=1000)]
      public function shouldCreateNewOrUpdateExistingSquadronIndicatorWhenSquadronIsAddedToACachedSpaceMap() : void
      {
         var mapGalaxy:CMapGalaxy = new CMapGalaxy(_galaxy);
         var mapSolarSystem:CMapSolarSystem = new CMapSolarSystem(_solarSystem);
         addCall(function():void{ UIImpersonator.addChild(mapGalaxy) });
         addWaitFor(mapGalaxy, FlexEvent.CREATION_COMPLETE);
         addCall(function():void{ UIImpersonator.addChild(mapSolarSystem) });
         addWaitFor(mapSolarSystem, FlexEvent.CREATION_COMPLETE);
         addCall(function():void{
            // Updates existing CMapSquadronsIcon
            _controller.distributeUnitsToSquadrons(
               new ModelsCollection([getUnit(1, 10, 1, Owner.ENEMY, getGalaxyLocation(0, 0))]),
                  _galaxy
            );
            // Creates new CMapSquadronsIcon
            _controller.distributeUnitsToSquadrons(
               new ModelsCollection([getUnit(2, 11, 2, Owner.PLAYER, getSolarSystemLocation(1, 1, 0))]),
               _solarSystem
            );
            
            assertThat( mapGalaxy.getSquadronObjects(), hasItem (hasProperties({
               "currentLocation": equals (getGalaxyLocation(0, 0)),
               "squadronsOwner": (Owner.ENEMY),
               "squadrons": hasItem (hasProperty ("id", 10))
            })));
            assertThat( mapSolarSystem.getSquadronObjects(), hasItem (hasProperties({
               "currentLocation": equals (getSolarSystemLocation(1, 1, 0)),
               "squadronsOwner": (Owner.PLAYER),
               "squadrons": hasItem (hasProperty ("id", 11))
            })));
         });
         runner.run();
      };
      
      
      [Test(async, timeout=1000)]
      public function shouldNotMoveSquadronsThatDoNotHaveNextHop() : void
      {
         var mapGalaxy:CMapGalaxy = new CMapGalaxy(_galaxy);
         addCall(function():void{ UIImpersonator.addChild(mapGalaxy) });
         addWaitFor(mapGalaxy, FlexEvent.CREATION_COMPLETE);
         addCall(function():void{
            var squad0:MSquadron = _galaxy.squadrons.findModel(0);
            var squad0Loc:LocationMinimal = getGalaxyLocation(0, 0);
            var squad1:MSquadron = _galaxy.squadrons.findModel(3);
            var squad1Loc:LocationMinimal = getGalaxyLocation(4, 4);
            
            _controller.client_internal::moveSquadron(squad0);
            _controller.client_internal::moveSquadron(squad1);
            
            assertThat( squad0.currentHop.location, equals (squad0Loc) );
            assertThat( mapGalaxy.getSquadronObjects(), hasItem (hasProperties({
               "currentLocation": equals (squad0Loc),
               "squadrons": hasItem (hasProperty ("id", 0))
            })));
            assertThat( squad1.currentHop.location, equals (squad1Loc) );
            assertThat( mapGalaxy.getSquadronObjects(), hasItem (hasProperties({
               "currentLocation": equals (squad1Loc),
               "squadrons": hasItem (hasProperty ("id", 3))
            })));
         });
         runner.run();
      };
      
      
      [Test]
      public function shouldMoveSquadronToNextHop() : void
      {
         var dest0:Location = getGalaxyLocation(0, 1);
         var dest1:Location = getSolarSystemLocation(1, 1, 0);
         var squad0:MSquadron = getSquadron(1, 2, Owner.PLAYER, getGalaxyLocation(0, 0), [getHop(1, dest0)]);
         var squad1:MSquadron = getSquadron(2, 2, Owner.PLAYER, getSolarSystemLocation(1, 0, 0), [getHop(1, dest1)]);
         
         _controller.client_internal::moveSquadron(squad0);
         _controller.client_internal::moveSquadron(squad1);
         
         assertThat( squad0.currentHop.location, equals (dest0) );
         assertThat( squad1.currentHop.location, equals (dest1) );
      };
      
      
      [Test(async, timeout=2000)]
      public function shouldMoveSquadronToNextHopUpdateItsCurrentLocationAndCachedMap() : void
      {
         _squads.removeAll();
         _galaxy.squadrons.removeAll();
         _solarSystem.squadrons.removeAll();
         var src0:Location = getGalaxyLocation(0, 0);
         var src1:Location = getSolarSystemLocation(1, 0, 0);
         var dest0:Location = getGalaxyLocation(1, 0);
         var dest1:Location = getSolarSystemLocation(1, 1, 0);
         var squad0:MSquadron = getSquadron(1, 2, Owner.PLAYER, src0, [getHop(1, dest0)]);
         var squad1:MSquadron = getSquadron(2, 2, Owner.PLAYER, src1, [getHop(1, dest1)]);
         _squads.addItem(squad0);
         _squads.addItem(squad1);
         addSquadronsToMMap(_galaxy);
         addSquadronsToMMap(_solarSystem);
         var mapGalaxy:CMapGalaxy = new CMapGalaxy(_galaxy);
         var mapSolarSystem:CMapSolarSystem = new CMapSolarSystem(_solarSystem);
         addCall(function():void{ UIImpersonator.addChild(mapGalaxy) });
         addWaitFor(mapGalaxy, FlexEvent.CREATION_COMPLETE);
         addCall(function():void{ UIImpersonator.addChild(mapSolarSystem) });
         addWaitFor(mapSolarSystem, FlexEvent.CREATION_COMPLETE);
         addCall(function():void{
            _controller.client_internal::moveSquadron(squad0);
            _controller.client_internal::moveSquadron(squad1);
         });
         addDelay(SquadronsController.MOVE_EFFECT_DURATION + 100);
         
         addCall(function():void{
            assertThat( squad0.currentHop.location, equals (dest0) );
            assertThat( squad1.currentHop.location, equals (dest1) );
            assertThat( squad0.currentLocation, hasProperties ({"id": 1, "x": 1, "y": 0}) );
            assertThat( squad1.currentLocation, hasProperties ({"id": 1, "x": 1, "y": 0, "variation": 1}) );
            assertThat( mapGalaxy.getCSquadronsByLocation(src0), emptyArray() );
            assertThat( mapGalaxy.getCSquadronsByLocation(dest0), allOf(
               arrayWithSize (1),
               hasItem (hasProperties({
                  "currentLocation": equals (dest0),
                  "squadrons": hasItem (squad0)
               }))
            ));
            assertThat( mapSolarSystem.getCSquadronsByLocation(src1), emptyArray() );
            assertThat( mapSolarSystem.getCSquadronsByLocation(dest1), allOf(
               arrayWithSize(1),
               hasItem (hasProperties({
                  "currentLocation": equals (dest1),
                  "squadrons": hasItem (squad1)
               }))
            ));
         });
         runner.run();
      };
      
      
      [Test(async, timeout=1000)]
      public function shouldRemoveSquadronFromPlanetAndAddItToSolarSystem() : void
      {
         _squads.removeAll();
         _planet.squadrons.removeAll();
         _solarSystem.squadrons.removeAll();
         var src:Location = getPlanetLocation(1, 0, 0);
         var dest:Location = getSolarSystemLocation(1, 0, 0);
         var squad:MSquadron = getSquadron
            (1, 2, Owner.PLAYER, src, [getHop(1, dest), getHop(2, getSolarSystemLocation(1, 1, 0))]);
         _squads.addItem(squad);
         addSquadronsToMMap(_planet);
         var mapSolarSystem:CMapSolarSystem = new CMapSolarSystem(_solarSystem);
         addCall(function():void{ UIImpersonator.addChild(mapSolarSystem) });
         addWaitFor(mapSolarSystem, FlexEvent.CREATION_COMPLETE);
         addCall(function():void{
            _controller.client_internal::moveSquadron(squad);
            
            assertThat( _planet.squadrons, not (hasItem (squad)) );
            assertThat( _solarSystem.squadrons, hasItem (squad) );
            assertThat( mapSolarSystem.getSquadronObjects(), hasItem (hasProperties({
               "currentLocation": equals (dest),
               "squadrons": hasItem (squad)
            })));
         });
         runner.run();
      };
      
      
      [Test]
      public function shouldCreateSquadronAndAddItToSquadronsList() : void
      {
         _modelLoc.player.id = 1;
         _squads.removeAll();
         var loc:Location = getPlanetLocation(1, 0, 0);
         var unit:Unit = getUnit(1, 1, 1, Owner.PLAYER, loc, "Trooper");
         
         _controller.createSquadron(new ModelsCollection([unit]), new ModelsCollection());
         
         assertThat( _squads, allOf(
            arrayWithSize (1),
            hasItem (hasProperties ({
               "id": 1,
               "playerId": 1,
               "owner": Owner.PLAYER,
               "currentHop": hasProperty ("location", equals (loc)),
               "units": hasItem (unit)
            }))
         ));
      };
      
      
      [Test]
      public function shouldCreateSquadronAndAddAllHopsToIt() : void
      {
         _modelLoc.player.id = 1;
         _squads.removeAll();
         var loc:Location = getGalaxyLocation(0, 0);
         var hop:MHop = getHop(0, getGalaxyLocation(0, 1));
         var unit:Unit = getUnit(1, 1, 1, Owner.PLAYER, loc, "Trooper");
         
         _controller.createSquadron(new ModelsCollection([unit]), new ModelsCollection([hop]));
         
         assertThat( _squads, allOf(
            arrayWithSize (1),
            hasItem (hasProperties ({
               "id": 1,
               "playerId": 1,
               "owner": Owner.PLAYER,
               "currentHop": hasProperty ("location", equals (loc)),
               "units": hasItem (unit),
               "hops": allOf(
                  arrayWithSize (1),
                  hasItem (hasProperty("location", equals (hop.location)))
               )
            }))
         ));
      };
      
      
      [Test]
      public function shouldCreateSquadronAndAddItToSquadronsListAndCachedMap() : void
      {
         _modelLoc.player.id = 1;
         _squads.removeAll();
         _planet.squadrons.removeAll();
         var loc:Location = getPlanetLocation(1, 0, 0);
         var unit:Unit = getUnit(1, 1, 2, Owner.ENEMY, loc, "Trooper");
         
         _controller.createSquadron(new ModelsCollection([unit]), new ModelsCollection());
         
         assertThat( [_squads, _planet.squadrons], everyItem (hasItem (hasProperties ({
            "id": 1,
            "playerId": 2,
            "owner": Owner.ENEMY,
            "currentHop": hasProperty ("location", equals (loc)),
            "units": hasItem (unit)
         }))));
      };
      
      
      [Test]
      public function shouldNotCreateSquadronIfItIsHostileAndNoneOfTheCachedMapsRepresentsItsLocation() : void
      {
         _modelLoc.player.id = 1;
         _squads.removeAll();
         _galaxy.squadrons.removeAll();
         var loc:Location = getGalaxyLocation(0, 0, 5);
         var unit:Unit = getUnit(1, 1, 2, Owner.ENEMY, loc, "Trooper");
         
         _controller.createSquadron(new ModelsCollection([unit]), new ModelsCollection());
         
         assertThat( _squads, emptyArray() );
      };
      
      
      [Test]
      public function shouldRemoveExistingSquadronWithSameIdAndOnlyThenCreateANewOne() : void
      {
         _modelLoc.player.id = 1;
         _squads.removeAll();
         _planet.squadrons.removeAll();
         _solarSystem.squadrons.removeAll();
         
         var locPlanet:Location = getPlanetLocation(1, 0, 0);
         var squadInPlanet:MSquadron = getSquadron(1, 1, Owner.PLAYER, locPlanet);
         _squads.addItem(squadInPlanet);
         addSquadronsToMMap(_planet);
         
         var locSolarSystem:Location = getSolarSystemLocation(1, 0, 0);
         var unit:Unit = getUnit(1, 1, 1, Owner.PLAYER, locSolarSystem, "Trooper");
         
         _controller.createSquadron(new ModelsCollection([unit]), new ModelsCollection());
         
         assertThat( _planet.squadrons, emptyArray() );
         assertThat( [_squads, _solarSystem.squadrons], everyItem (allOf (
            arrayWithSize (1),
            hasItem (hasProperties ({
               "id": 1,
               "currentLocation": equals (locSolarSystem)
            }))
         )));
      };
      
      
      [Test]
      public function shouldCreateSquadronAddItToSquadronsListAndCachedMapAndUpdateExistingSquadron() : void
      {
         _modelLoc.player.id = 1;
         _squads.removeAll();
         _galaxy.squadrons.removeAll();
         var loc:Location = getGalaxyLocation(0, 0);
         var squadStationary:MSquadron = getSquadron(0, 2, Owner.ENEMY, loc);
         squadStationary.units = new ModelsCollection([
            getUnit(1, 0, 2, Owner.ENEMY, loc, "Trooper"),
            getUnit(2, 0, 2, Owner.ENEMY, loc, "Spy")
         ]);
         squadStationary.client_internal::rebuildCachedUnits();
         _squads.addItem(squadStationary);
         var squadMoving:MSquadron = getSquadron(1, 1, Owner.PLAYER, loc);
         squadMoving.units = new ModelsCollection([
            getUnit(3, 1, 1, Owner.PLAYER, loc, "Gnat"),
            getUnit(4, 1, 1, Owner.PLAYER, loc, "Cyrix")
         ]);
         squadMoving.client_internal::rebuildCachedUnits();
         _squads.addItem(squadMoving);
         addSquadronsToMMap(_galaxy);
         
         var unitFromStationary:Unit = getUnit(1, 2, 2, Owner.ENEMY, loc, "Trooper");
         var unitFromMoving:Unit = getUnit(3, 3, 1, Owner.PLAYER, loc, "Gnat");
         
         _controller.createSquadron(new ModelsCollection([unitFromStationary]), new ModelsCollection());
         _controller.createSquadron(new ModelsCollection([unitFromMoving]), new ModelsCollection());
         
         assertThat( [_squads, _galaxy.squadrons], everyItem (arrayWithSize (4)) );
         assertThat( [_squads, _galaxy.squadrons], everyItem (hasItems (
            squadStationary,
            squadMoving,
            hasProperties({
               "id": 2,
               "playerId": 2,
               "owner": Owner.ENEMY,
               "currentLocation": equals (loc),
               "units": hasItem (unitFromStationary)
            }),
            hasProperties({
               "id": 3,
               "playerId": 1,
               "owner": Owner.PLAYER,
               "currentLocation": equals (loc),
               "units": hasItem (unitFromMoving)
            })
         )));
         assertThat( squadStationary.units, allOf(
            hasItem (equals (getUnit(2, 0, 2, Owner.ENEMY, loc, "Spy"))),
            not (hasItem (equals (unitFromStationary)))
         ));
         assertThat( squadMoving.units, allOf(
            hasItem (equals (getUnit(4, 1, 1, Owner.PLAYER, loc, "Cyrix"))),
            not (hasItem (equals (unitFromMoving)))
         ));
      };
      
      
      [Test]
      public function shouldAddSquadronToSquadronsListAndRemoveExistingSquadronWithoutAnyUnits() : void
      {
         _modelLoc.player.id = 1;
         _squads.removeAll();
         _galaxy.squadrons.removeAll();
         var loc:Location = getGalaxyLocation(0, 0);
         var squadStationary:MSquadron = getSquadron(0, 2, Owner.ENEMY, loc);
         squadStationary.units = new ModelsCollection([getUnit(1, 0, 2, Owner.ENEMY, loc, "Trooper")]);
         squadStationary.client_internal::rebuildCachedUnits();
         _squads.addItem(squadStationary);
         var squadMoving:MSquadron = getSquadron(1, 1, Owner.PLAYER, loc);
         squadMoving.units = new ModelsCollection([getUnit(2, 1, 1, Owner.PLAYER, loc, "Gnat")]);
         squadMoving.client_internal::rebuildCachedUnits();
         _squads.addItem(squadMoving);
         addSquadronsToMMap(_galaxy);
         
         var unitFromStationary:Unit = getUnit(1, 2, 2, Owner.ENEMY, loc, "Trooper");
         var unitFromMoving:Unit = getUnit(2, 3, 1, Owner.PLAYER, loc, "Gnat");
         
         _controller.createSquadron(new ModelsCollection([unitFromStationary]), new ModelsCollection());
         _controller.createSquadron(new ModelsCollection([unitFromMoving]), new ModelsCollection());
         
         assertThat( [_squads, _galaxy.squadrons], everyItem (allOf (
            arrayWithSize (2),
            hasItems (
               hasProperty("units", hasItem( equals (unitFromStationary))),
               hasProperty("units", hasItem( equals (unitFromMoving)))
            )
         )));
         assertThat( [squadStationary.units, squadMoving.units], everyItem (arrayWithSize (0)) );
      };
      
      
      [Test]
      public function shouldFailIfGivenIdIsIllegalMovingSquadId() : void
      {
         _squads.removeAll();
         
         assertThat( function():void{ _controller.stopSquadron(0) }, throws (ArgumentError) );
         assertThat( function():void{ _controller.stopSquadron(-1) }, throws (ArgumentError) );
      };
      
      
      [Test]
      public function shouldStopTheSquadronAndRemoveItFromCachedPlanetMapAndSquadronsList() : void
      {
         _squads.removeAll();
         _planet.squadrons.removeAll();
         var squadToStop:MSquadron = getSquadron(1, 2, Owner.PLAYER, getPlanetLocation(1, 0, 0));
         _squads.addItem(squadToStop);
         addSquadronsToMMap(_planet);
         
         _controller.stopSquadron(squadToStop.id);
         
         assertThat( [_squads, _planet.squadrons], everyItem (emptyArray()) );
      };
      
      
      [Test]
      public function shouldStopTheSquadronInCachedSpaceMap() : void
      {
         _squads.removeAll();
         _galaxy.squadrons.removeAll();
         var loc:Location = getGalaxyLocation(0, 0);
         var squadToStop:MSquadron = getSquadron(1, 1, Owner.ENEMY, loc);
         _squads.addItem(squadToStop);
         addSquadronsToMMap(_galaxy);
         
         _controller.stopSquadron(1);
         
         assertThat( [_squads, _galaxy.squadrons], everyItem (allOf (
            arrayWithSize (1),
            hasItem (hasProperties ({
               "id": 0,
               "playerId": 1,
               "currentHop": hasProperty ("location", equals (loc))
            }))
         )));
      };
      
      
      [Test]
      public function shouldStopTheSquadronAndMergeItToAStationarySquadron() : void
      {
         _squads.removeAll();
         _galaxy.squadrons.removeAll();
         var loc:Location = getGalaxyLocation(0, 0);
         var stationarySquad:MSquadron = getSquadron(0, 1, Owner.ENEMY, loc);
         stationarySquad.cachedUnits = new ModelsCollection([new UnitEntry("Tropper", 1)]);
         var squadToStop:MSquadron = getSquadron(1, 1, Owner.ENEMY, loc);
         squadToStop.cachedUnits = new ModelsCollection([new UnitEntry("Tropper", 1)]);
         _squads.addItem(stationarySquad);
         _squads.addItem(squadToStop);
         addSquadronsToMMap(_galaxy);
         
         _controller.stopSquadron(1);
         
         assertThat( [_squads, _galaxy.squadrons], everyItem ( allOf (
            arrayWithSize(1),
            hasItem (hasProperties ({
               "id": 0,
               "playerId": 1,
               "currentHop": hasProperty("location", equals (loc)),
               "cachedUnits": hasItem (hasProperties ({"type": "Tropper", "count": 2}))
            }))
         )));
      };
      
      
      [Test]
      public function shouldStopFriendlySquadronAndRemoveItFromSquadronsListIfMapDefiningItsLocationIsNotOpen() : void
      {
         _squads.removeAll();
         _galaxy.squadrons.removeAll();
         var loc:Location = getGalaxyLocation(0, 0, 2);
         var squadPlayer:MSquadron = getSquadron(1, 2, Owner.PLAYER, loc);
         var squadAlly:MSquadron = getSquadron(2, 5, Owner.ALLY, loc);
         _squads.addItem(squadPlayer);
         _squads.addItem(squadAlly);
         addSquadronsToMMap(_galaxy);
         
         _controller.stopSquadron(1);
         _controller.stopSquadron(2);
         
         assertThat( [_galaxy.squadrons, _squads], everyItem (emptyArray()) );
      }
      
      
      /* ############### */      
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function getPlanet(id:int, position:int, angle:Number) : Planet
      {
         var planet:Planet = new Planet();
         planet.id = id;
         planet.location.position = position;
         planet.location.angle = angle;
         return planet;
      }
      
      
      private function getSolarSystem(id:int, x:int, y:int) : SolarSystem
      {
         var ss:SolarSystem = new SolarSystem();
         ss.id = id;
         ss.x = x;
         ss.y = y;
         return ss;
      }
      
      
      private function getUnit(id:int, squadronId:int, playerId:int, owner:int, location:Location, type:String = "") : Unit
      {
         var unit:Unit = new Unit();
         unit.id = id;
         unit.owner = owner;
         unit.playerId = playerId;
         unit.squadronId = squadronId;
         unit.location = location;
         unit.type = type;
         return unit;
      }
      
      
      private function getSquadron(id:int, playerId:int, owner:int, currentLocation:Location, hops:Array = null) : MSquadron
      {
         var squad:MSquadron = new MSquadron();
         squad.id = id;
         squad.playerId = playerId;
         squad.owner = owner;
         squad.currentLocation = currentLocation;
         squad.client_internal::createCurrentHop();
         if (hops)
         {
            squad.addAllHops(new ModelsCollection(hops));
         }
         return squad;
      }
      
      
      private function getHop(index:int, location:LocationMinimal) : MHop
      {
         var hop:MHop = new MHop();
         hop.index = index;
         hop.location = location;
         return hop;
      }
      
      
      private function getGalaxyLocation(x:int, y:int, id:int = 1) : Location
      {
         return getLocation(id, LocationType.GALAXY, x, y);
      }
      
      
      private function getSolarSystemLocation(id:int, position:int, angle:Number) : Location
      {
         return getLocation(id, LocationType.SOLAR_SYSTEM, position, angle);
      }
      
      
      private function getPlanetLocation(id:int, position:int, angle:Number) : Location
      {
         return getLocation(id, LocationType.SS_OBJECT, position, angle);
      }
      
      
      private function getLocation(id:int, type:int, x:int, y:int) : Location
      {
         var loc:Location = new Location();
         loc.id = id;
         loc.type = type;
         loc.x = x;
         loc.y = y;
         return loc;
      }
      
      
      private function addSquadronsToMMap(mapM:Map) : void
      {
         mapM.addAllSquadrons(_squads.filterItems(
            function(squad:MSquadron) : Boolean
            {
               return mapM.definesLocation(squad.currentHop.location);
            }
         ));
      }
   }
}