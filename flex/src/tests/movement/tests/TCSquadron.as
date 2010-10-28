package tests.movement.tests
{
   import ext.hamcrest.collection.hasItems;
   import ext.hamcrest.object.equals;
   
   import flash.errors.IllegalOperationError;
   
   import models.ModelsCollection;
   import models.Owner;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.events.MRouteEvent;
   import models.movement.events.MRouteEventChangeKind;
   import models.movement.events.MSquadronEvent;
   import models.unit.Unit;
   import models.unit.UnitEntry;
   
   import mx.collections.ArrayCollection;
   
   import namespaces.client_internal;
   
   import org.fluint.sequence.SequenceRunner;
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.arrayWithSize;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.core.allOf;
   import org.hamcrest.core.throws;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.isFalse;
   import org.hamcrest.object.isTrue;
   import org.hamcrest.object.nullValue;
   
   import utils.DateUtil;

   public class TCSquadron
   {
      include "../../asyncHelpers.as";
      include "../../asyncSequenceHelpers.as";
      
      
      private var squadron:MSquadron;
      
      
      [Before]
      public function setUp() : void
      {
         DateUtil.timeDiff = 0;
         squadron = new MSquadron();
         runner = new SequenceRunner(this);
      };
      
      
      [Test]
      /**
       * Checks if interface mathods do not accept bad parameters.
       */
      public function methods_badParams() : void
      {
         assertThat( function():void{ squadron.findEntryByType(null) }, throws (ArgumentError) );
         assertThat( function():void{ squadron.findEntryByType("") }, throws (ArgumentError) );
         assertThat( function():void{ squadron.addHop(null) }, throws (ArgumentError) );
      };
      
      
      [Test]
      /**
       * Checks if findEntryByType() works as expected.
       */
      public function findEntryByType() : void
      {
         var unitA:Unit = new Unit();
         unitA.type = "Moron";
         var unitB:Unit = new Unit();
         unitB.type = "Stupid";
         squadron.units.addItem(unitA);
         squadron.units.addItem(unitB);
         squadron.client_internal::rebuildCachedUnits();
         
         // should return null if no entry could be found
         assertThat( squadron.findEntryByType("Pig"), equalTo (null) );
         
         // should return instance of SquadronEntry
         assertThat( squadron.findEntryByType("Moron"), hasProperties ({"type": "Moron", "count": 1}) );
         assertThat( squadron.findEntryByType("Stupid"), hasProperties ({"type": "Stupid", "count": 1}) );
      }
      
      
      [Test]
      /**
       * lastHop should be null if no hops are in the squadron.
       */
      public function lastHop_squadronEmpty() : void
      {
         assertThat( squadron.lastHop, nullValue() );
      }
      
      
      [Test(async, timeout=200)]
      /**
       * New hop should be added to the end of the hops list, an event should be then dispatched.
       */
      public function addHop_toTheEnd() : void
      {
         var hopA:MHop = getGalaxy(0, 0, 0); 
         var hopB:MHop = getGalaxy(0, 1, 1);
         
         addCall(squadron.addHop, [hopA]);
         addWaitForEvent(squadron, MRouteEvent.CHANGE, function(event:MRouteEvent) : void {
            assertThat( event.kind, equalTo (MRouteEventChangeKind.HOP_ADD) );
            assertThat( event.hop, equalTo (hopA) );
            assertThat( squadron.lastHop, equalTo (hopA) );
         });
         addCall(squadron.addHop, [hopB]);
         addWaitForEvent(squadron, MRouteEvent.CHANGE, function(event:MRouteEvent) : void {
            assertThat( event.kind, equalTo (MRouteEventChangeKind.HOP_ADD) );
            assertThat( event.hop, equalTo (hopB) );
            assertThat( squadron.lastHop, equalTo (hopB) );
         });
         
         runner.run();
      };
      
      
      [Test]
      /**
       * Should not allow adding hops that define same point in space as existing hops.
       */
      public function addHop_samePointIllegal() : void
      {
         var hopGalaxy:MHop = getGalaxy(0, 0, 0);
         var hopSS:MHop = getSolarSystem(0, 1, 1);
         squadron.addHop(hopGalaxy);
         squadron.addHop(hopSS);
         assertThat( function():void{ squadron.addHop(hopGalaxy) }, throws (ArgumentError) );
         assertThat( function():void{ squadron.addHop(getGalaxy(0, 0, 2)) }, throws (ArgumentError) );
         assertThat( function():void{ squadron.addHop(hopSS) }, throws (ArgumentError) );
         assertThat( function():void{ squadron.addHop(getSolarSystem(0, 1, 2)) }, throws (ArgumentError) );
      };
      
      
      [Test]
      /**
       * Should not allow adding hops out-of-order. All hops must be added so that the following
       * conditions are met: <code>hop[i].index - hop[i + 1].index == 1</code> where <code>i =
       * [0; hops.length]</code>.
       */
      public function addHop_outOfOrder() : void
      {
         var hopA:MHop = getGalaxy(0, 0, 0);
         var hopB:MHop = getGalaxy(0, 1, 0);
         var hopC:MHop = getGalaxy(0, 1, 1);
         var hopD:MHop = getGalaxy(0, 2, 2);
         squadron.addHop(hopA)
         assertThat( function():void{ squadron.addHop(hopB) }, throws (ArgumentError) );
         assertThat( function():void{ squadron.addHop(hopD) }, throws (ArgumentError) );
         squadron.addHop(hopC);
         squadron.addHop(hopD);
      }
      
      
      [Test]
      /**
       * moveToNextHop() should throw error if no hops are in the squadron.
       */
      public function moveToNextHop_noHopsRemaining() : void
      {
         assertThat( function():void{ squadron.moveToNextHop() }, throws (IllegalOperationError) );
      };
      
      
      [Test]
      /**
       * moveToNextHop() should return a hop which has been removed from the route of a squadron
       * after it has been moved
       */
      public function moveToNextHop_returnCheck() : void
      {
         var hopA:MHop = getGalaxy(0, 2, 0);
         var hopB:MHop = getGalaxy(0, 3, 1);
         squadron.addHop(hopA);
         squadron.addHop(hopB);
         assertThat( squadron.moveToNextHop(), equals (hopA) );
         assertThat( squadron.moveToNextHop(), equals (hopB) );
      }
      
      
      [Test(async, timeout=500)]
      /**
       * moveToNextHop() should set currentHop to new hop and dispatch an HOP_REMOVE and MOVE events.
       */
      public function moveToNextHop() : void
      {
         var hopA:MHop = getGalaxy(0, 0, 0); 
         var hopB:MHop = getGalaxy(0, 1, 1);
         var hopC:MHop = getGalaxy(0, 2, 2);
         var hopD:MHop = getGalaxy(0, 3, 3);
         squadron.addHop(hopA);
         squadron.addHop(hopB);
         squadron.addHop(hopC);
         squadron.addHop(hopD);
         
         addCall(squadron.moveToNextHop);
         addWaitFor(squadron, MSquadronEvent.MOVE);
         addCall(squadron.moveToNextHop);
         addWaitForEvent(squadron, MSquadronEvent.MOVE,
            function(event:MSquadronEvent) : void
            {
               assertThat( event.moveFrom, equals (hopA.location) );
               assertThat( event.moveTo, equals (hopB.location) );
            }
         );
         
         addCall(squadron.moveToNextHop);
         addWaitForEvent(squadron, MRouteEvent.CHANGE,
            function(event:MRouteEvent) : void
            {
               assertThat( event.kind, equals (MRouteEventChangeKind.HOP_REMOVE) );
               assertThat( event.hop, equals (hopC) );
               assertThat( squadron.currentHop, equals (hopC) );
            }
         );
         addCall(squadron.moveToNextHop);
         addWaitForEvent(squadron, MRouteEvent.CHANGE,
            function(event:MRouteEvent) : void
            {
               assertThat( event.kind, equals (MRouteEventChangeKind.HOP_REMOVE) );
               assertThat( event.hop, equals (hopD) );
               assertThat( squadron.currentHop, equals (hopD) );
               assertThat( squadron.hasHopsRemaining, equals (false) );
               assertThat( squadron.lastHop, nullValue() );
            }
         );
         
         runner.run();
      };
      
      
      [Test]
      /**
       * Squadron should be considered moving if squadron id is equal to 0.
       */
      public function isMoving() : void
      {
         assertThat( squadron.isMoving, equals (false) );
         squadron.id = 1;
         assertThat( squadron.isMoving, equals (true) );
      };
      
      
      [Test]
      public function shouldNotAllowMergingSquadronWithItself() : void
      {
         var squad:MSquadron = getSquadron(0, Owner.PLAYER, 1, getGalaxy(0, 0, 0));
         assertThat( function():void{ squad.merge(squad) }, throws (ArgumentError) );
      };
      
      
      [Test]
      public function shouldNotAllowMergingSquadronsThatBelongToDifferentOwners() : void
      {
         var squad0:MSquadron = getSquadron(0, Owner.PLAYER, 1, getGalaxy(0, 0, 0));
         var squad1:MSquadron = getSquadron(0, Owner.ENEMY, 2, getGalaxy(0, 0, 0));
         assertThat( function():void{ squad0.merge(squad1) }, throws (ArgumentError) );
      };
      
      
      [Test]
      public function shouldAllowMergingNotMovingSquadronsOnly() : void
      {
         var squad0:MSquadron = getSquadron(1, Owner.PLAYER, 1, getGalaxy(0, 0, 0));
         var squad1:MSquadron = getSquadron(2, Owner.PLAYER, 1, getGalaxy(0, 0, 0));
         assertThat( function():void{ squad0.merge(squad1) }, throws (ArgumentError) );
         
         squad0.id = 0;
         assertThat( function():void{ squad0.merge(squad1) }, throws (ArgumentError) );
         assertThat( function():void{ squad1.merge(squad0) }, throws (ArgumentError) );
         
         squad1.id = 0;
         squad0.merge(squad1);
      };
      
      
      [Test]
      public function shouldCopyUnitsWhenMerging() : void
      {
         var unit0:Unit = new Unit(); unit0.id = 1;
         var unit1:Unit = new Unit(); unit1.id = 2;
         var squad0:MSquadron = getSquadron(0, Owner.PLAYER, 1, getGalaxy(0, 0, 0), null, [unit0, unit1]);
         var squad1:MSquadron = getSquadron(0, Owner.PLAYER, 1, getGalaxy(0, 0, 0));
         
         squad1.merge(squad0);
         
         assertThat( squad1.units, hasItems (unit0, unit1) );
      };
      
      
      [Test]
      public function shouldMergeCachedUnitsList() : void
      {
         var unitEntry:UnitEntry = new UnitEntry("Trooper", 2);
         var unitEntry0:UnitEntry = new UnitEntry("Trooper", 1);
         var unitEntry1:UnitEntry = new UnitEntry("Spy", 1);
         var squad0:MSquadron = getSquadron(0, Owner.PLAYER, 1, getGalaxy(0, 0, 0), [unitEntry0, unitEntry1]);
         var squad1:MSquadron = getSquadron(0, Owner.PLAYER, 1, getGalaxy(0, 0, 0), [unitEntry]);
         
         squad1.merge(squad0);
         
         assertThat( squad1.cachedUnits, allOf (
            arrayWithSize (2),
            hasItems(
               hasProperties ({"type": "Trooper", "count": 3}),
               hasProperties ({"type": "Spy", "count": 1})
            )
         ));
      };
      
      
      [Test]
      public function shouldSeparateUnitsFromTheSquadronAndUpdateCachedUnitsList() : void
      {
         var squad:MSquadron = getSquadron(
            1, Owner.PLAYER, 1, getGalaxy(0, 0, 0), null,
            [getUnit(1, "Trooper"), getUnit(2, "Spy"), getUnit(3, "Trooper"), getUnit(4, "Gnat")]
         );
         squad.client_internal::rebuildCachedUnits();
         var anotherSquad:MSquadron = getSquadron(
            2, Owner.PLAYER, 1, getGalaxy(0, 0, 0), null,
            [getUnit(1, "Trooper"), getUnit(4, "Gnat")]
         );
         anotherSquad.client_internal::rebuildCachedUnits();
         
         squad.separateUnits(anotherSquad);
         
         assertThat( squad.cachedUnits, allOf(
            arrayWithSize(2),
            hasItems(
               hasProperties({"type": "Trooper", "count": 1}),
               hasProperties({"type": "Spy", "count": 1})
            )
         ));
         assertThat( squad.units, allOf(
            arrayWithSize (2),
            hasItems (equals (getUnit(2, "Spy")), equals (getUnit(3, "Trooper")))
         ));
      };
      
      
      [Test]
      public function shouldFailWhenTryingToSeparateUnitsNotInSquadron() : void
      {
         var squad:MSquadron = getSquadron(1, Owner.PLAYER, 1, getGalaxy(0, 0, 0), null, [getUnit(1, "Trooper")]);
         squad.client_internal::rebuildCachedUnits();
         var anotherSquad:MSquadron = getSquadron(2, Owner.PLAYER, 1, getGalaxy(0, 0, 0), null, [getUnit(2, "Trooper")]);
         anotherSquad.client_internal::rebuildCachedUnits();
         
         assertThat(
            function():void{ squad.separateUnits(anotherSquad) },
            throws (ArgumentError)
         );
      };
      
      
      [Test]
      public function shouldReturnTrueWhenAtLeastOneUnitIsLeftInASquadronAfterSeparation() : void
      {
         var squad:MSquadron = getSquadron(
            1, Owner.PLAYER, 1, getGalaxy(0, 0, 0), null,
            [getUnit(1, "Trooper"), getUnit(2, "Spy")]
         );
         squad.client_internal::rebuildCachedUnits();
         var anotherSquad:MSquadron = getSquadron(2, Owner.PLAYER, 1, getGalaxy(0, 0, 0), null, [getUnit(2, "Spy")]);
         anotherSquad.client_internal::rebuildCachedUnits();
         
         assertThat( squad.separateUnits(anotherSquad), isTrue() );
      };
      
      
      [Test]
      public function shouldReturnFalseWhenNoUnitsAreLeftInASquadronAfterSeparation() : void
      {
         var squad:MSquadron = getSquadron(1, Owner.PLAYER, 1, getGalaxy(0, 0, 0), null, [getUnit(2, "Spy")]);
         squad.client_internal::rebuildCachedUnits();
         var anotherSquad:MSquadron = getSquadron(2, Owner.PLAYER, 1, getGalaxy(0, 0, 0), null, [getUnit(2, "Spy")]);
         anotherSquad.client_internal::rebuildCachedUnits();
         
         assertThat( squad.separateUnits(anotherSquad), isFalse() );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function getGalaxy(x:int, y:int, index:int) : MHop
      {
         return getHop(LocationType.GALAXY, x, y, index);
      }
      
      
      private function getSolarSystem(x:int, y:int, index:int) : MHop
      {
         return getHop(LocationType.SOLAR_SYSTEM, x, y, index);
      }
      
      
      private function getPlanet(x:int, y:int, index:int) : MHop
      {
         return getHop(LocationType.PLANET, x, y, index);
      }
      
      
      private function getSquadron(id:int, owner:int, playerId:int, currentHop:MHop,
                                   cachedUnits:Array = null,
                                   units:Array = null) : MSquadron
      {
         var squad:MSquadron = new MSquadron();
         squad.id = id;
         squad.owner = owner;
         squad.playerId = playerId;
         squad.currentHop = currentHop;
         cachedUnits ? squad.cachedUnits = new ModelsCollection(cachedUnits) : void;
         units ? squad.addAllUnits(new ArrayCollection(units)) : void;
         return squad;
      }
      
      
      private function getHop(type:int, x:int, y:int, index:int) : MHop
      {
         var location:LocationMinimal = new LocationMinimal();
         location.x = x;
         location.y = y;
         location.type = type;
         var hop:MHop = new MHop();
         hop.index = index;
         hop.location = location;
         return hop;
      }
      
      
      private function getUnit(id:int, type:String) : Unit
      {
         var unit:Unit = new Unit();
         unit.id = id;
         unit.type = type;
         return unit;
      }
   }
}