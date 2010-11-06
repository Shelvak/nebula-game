package controllers.units
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import components.map.space.SquadronsController;
   
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.Owner;
   import models.factories.SquadronFactory;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.Map;
   import models.map.MapType;
   import models.movement.MHop;
   import models.movement.MSquadron;
   import models.movement.SquadronsList;
   import models.unit.Unit;
   import models.unit.UnitKind;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   import namespaces.client_internal;
   
   import utils.datastructures.Collections;

   
   /**
    * Works with <code>MSquadron</code> objects and <code>ModelLocator.squadrons</code> list.
    */
   public class SquadronsController
   {
      public static function getInstance() : SquadronsController
      {
         return SingletonFactory.getSingletonInstance(SquadronsController);
      }
      
      
      private static const MOVEMENT_TIMER_DELAY:int = 1000; // Milliseconds
      
      
      private var ML:ModelLocator = ModelLocator.getInstance();
      private var SQUADS:SquadronsList = ML.squadrons;
      
      
      public function SquadronsController()
      {
         _timer = new Timer(MOVEMENT_TIMER_DELAY);
         _timer.addEventListener(TimerEvent.TIMER, movementTimer_timerHandler);
      }
      
      
      /**
       * Use to add next hop to hostile squadron when that hop is received from the server. Will
       * ignore given hop if squadron to add the hop to can't be found.
       */
      public function addHopToHostileSquadron(hop:MHop) : void
      {
         var squad:MSquadron = SQUADS.findMoving(hop.routeId);
         if (squad)
         {
            squad.addHop(hop);
         }
      }
      
      
      /**
       * Use when:
       * <ul>
       *    <li>ENEMY or NAP squadron leaves visible area of a galaxy</li>
       *    <li>when any squadron has been destroyed</li>
       * </ul>
       * 
       * @param id must be id of moving squadron. If a squadron with given id could not be found,
       * nothing happens.
       */
      public function destroyMovingSquadron(id:int) : void
      {
         if (id <= 0)
         {
            throw new ArgumentError("Illegal moving squadron id: " + id);
         }
         destroyMovingSquad(SQUADS.findMoving(id));
      }
      private function destroyMovingSquad(squad:MSquadron) : void
      {
         if (squad)
         {
            SQUADS.removeSquadron(squad);
         }
      }
      
      
      /**
       * Call this when a map is to be destroyed and all stationary squadrons and squads that do not belong to the
       * player must be removed from squadrons list.
       * 
       * @param map can be either instance of <code>Planet</code> or <code>SolarSystem</code>
       */
      public function destroyAlienAndStationarySquadrons(map:Map) : void
      {
         var locId:int = map.id;
         var locType:int = map.isOfType(MapType.SOLAR_SYSTEM) ? LocationType.SOLAR_SYSTEM : LocationType.SS_OBJECT;
         Collections.filter(
            map.squadrons,
            function(squad:MSquadron) : Boolean
            {
               var loc:LocationMinimal = squad.currentHop.location;
               return loc.id == locId && loc.type == locType && (!squad.isMoving || squad.owner != Owner.PLAYER);
            }
         ).removeAll();
      }
      
      
      /**
       * Use to update <code>currentLocation</code> of frienldy squadron.
       * 
       * @param squadron must be a moving squadron and must belong to either the player or an ally
       */
      public function updateMovingFriendlySquadron(id:int, location:Location) : void
      {
         if (id <= 0)
         {
            throwIllegalMovingSquadId(id);
         }
         var squad:MSquadron = SQUADS.findMoving(id);
         if (!squad)
         {
            throw new ArgumentError("Squadron with id " + id + " could not be found");
         }
         if (squad.isHostile)
         {
            throw new ArgumentError("Squadron " + squad + " must be friendly");
         }
         squad.currentLocation = location;
      }
      
      
      /**
       * Use to stop a squadron which is moving. Will ignore IDs of squadrons not present in
       * <code>ModelLocator.squadrons</code>.
       */
      public function stopSquadron(id:int) : void
      {
         if (id <= 0)
         {
            throwIllegalMovingSquadId(id);
         }
         
         var squadToStop:MSquadron = SQUADS.findMoving(id);
         if (!squadToStop)
         {
            return;
         }
         SQUADS.removeSquadron(squadToStop);
         squadToStop.id = 0;
         squadToStop.arrivesAt = null;
         squadToStop.sourceLocation = null;
         squadToStop.targetLocation = null;
         squadToStop.removeAllHops();
         for each (var unit:Unit in squadToStop.units)
         {
            unit.squadronId = 0;
         }
         var squadStationary:MSquadron = SQUADS.findStationary(squadToStop.currentHop.location, squadToStop.owner);
         if (squadStationary)
         {
            squadStationary.merge(squadToStop);
         }
         else
         {
            SQUADS.addItem(squadToStop);
         }
      }
      
      
      /**
       * Use to create all squadrons when they are received from the server after player has logged in.
       */
      public function createMovingPlayerSquadrons(routes:Array) : void
      {
         for each (var data:Object in routes)
         {
            createMovingFriendlySquadron(data);
         }
      }
      
      
      /**
       * Use to create friendly squadrons when they start moving but map defining their location has
       * not been opened, you don't have units that should be moved and you are unable to use
       * <code>startMovement()</code> method.
       * 
       * @param data should have <code>hops</code> list
       */
      public function createMovingFriendlySquadron(data:Object) : void
      {
         var newSquad:MSquadron = SquadronFactory.fromObject(data);
         newSquad.owner = newSquad.playerId == ML.player.id ? Owner.PLAYER : Owner.ALLY;
         
         if (!newSquad.isMoving)
         {
            throw new ArgumentError(
               "Squadron " + newSquad + " is not moving: this method supports only moving squadrons"
            );
         }
         
         SQUADS.addItem(newSquad);
      }
      
      
      /**
       * Call this when any units have made a jump between maps or when hostile units have jumped
       * into player's visible area.
       */
      public function executeJump(units:IList, hops:IList) : void
      {
         var sampleUnit:Unit = Unit(units.getItemAt(0));
         // either move existing squadron to another map
         var squad:MSquadron = SQUADS.findMoving(sampleUnit.squadronId);
         if (squad)
         {
            squad.currentLocation = sampleUnit.location;
            squad.client_internal::createCurrentHop();
            squad.addAllHops(hops);
            if (!squad.currentLocation.isObserved)
            {
               if (squad.isHostile)
               {
                  destroyMovingSquad(squad);
               }
               else
               {
                  squad.units.removeAll();
               }
            }
         }
         // or create new squadron wich must be hostile
         else if (sampleUnit.owner == Owner.NAP || sampleUnit.owner == Owner.ENEMY)
         {
            if (sampleUnit.location.isObserved)
            {
               squad = SquadronFactory.fromUnit(sampleUnit);
               squad.addAllUnits(units);
               squad.addAllHops(hops);
               SQUADS.addItem(squad);
            }
         }
         else
         {
            throw new Error("Unable to execute jump: units " + units + " belong to a friendly " +
                            "player but corresponding squadron could not be found");
         }
      }
      
      
      /**
       * Use when you need to create new squadron when any stationary units need to be moved or
       * when units moving already need to be dispatched different way.
       * 
       * <p>If given units belong to the same moving squadron already in <code>ModelLocator.squadrons</code>
       * list, this squadron is destroyed first and the new one is created.</p>
       * 
       * @param route generic object representing a squadron. It must have hops array
       * @param unitIds array of ids on units to be moved
       */
      public function startMovement(route:Object, $unitIds:Array) : void
      {
         var squad:MSquadron;
         var units:IList = new ArrayCollection();
         var unitIds:ArrayCollection = new ArrayCollection($unitIds);
         var currentLocation:LocationMinimal = BaseModel.createModel(LocationMinimal, route.current);
         
         // looking for units that need to be moved
         function findUnitsWithIdsIn(units:IList) : IList
         {
            return Collections.filter(units,
               function(unit:Unit) : Boolean
               {
                  return unitIds.contains(unit.id);
               }
            );
         };
         if (currentLocation.isObserved)
         {
            if (currentLocation.isSSObject)
            {
               units = findUnitsWithIdsIn(ML.latestPlanet.units);
            }
            else
            {
               for each (squad in SQUADS)
               {
                  units = findUnitsWithIdsIn(squad.units);
                  if (units.length != 0) break;
               }
            }
         }
         
         // we found units
         // that means we have a cached map in which those units are located so just create a squadron
         if (units.length != 0)
         {
            var sampleUnit:Unit = Unit(units.getItemAt(0));
            var existingSquad:MSquadron = findSquad(sampleUnit.squadronId, sampleUnit.owner, currentLocation);
            squad = SquadronFactory.fromObject(route);
            squad.owner = sampleUnit.owner;
            squad.addAllUnits(units);
            if (existingSquad)
            {
               if (!existingSquad.separateUnits(squad))
               {
                  SQUADS.removeSquadron(existingSquad);
               }
            }
            SQUADS.addItem(squad);
         }
         // ALLY or PLAYER units are starting to move but we don't have that map open
         else if (route.target !== undefined)
         {
            createMovingFriendlySquadron(route);
         }
      }
      
      
      /**
       * Use when new units have been received to distribute them to squadrons. This method will add new squadrons
       * (if any has been created) to <code>ModelLocator.squadrons</code> list.
       * 
       * <p>
       * Do not use for starting units movement. Use <code>createSquadron()</code> or
       * <code>createFriendlySquadron()</code> for that.
       * </p>
       */
      public function distributeUnitsToSquadrons(units:IList) : void
      {
         var squad:MSquadron;
         var newSquads:Array = new Array();
         for each (var unit:Unit in units.toArray())
         {
            if (unit.kind != UnitKind.SPACE || !unit.isMoving && (!unit.location || unit.location.isSSObject))
            {
               continue;
            }
            
            squad = findSquad(unit.squadronId, unit.owner, unit.location);
            
            // No squadron for the unit: create one
            if (!squad)
            {
               // this should never be true, but just in case
               if (unit.isMoving)
               {
                  throw new Error(
                     "Could not find squadron for moving unit " + unit + ". All moving squadrons " +
                     "should have been created before calling distributeUnitsToSquadrons()"
                  );
               }
               squad = SquadronFactory.fromUnit(unit);
               SQUADS.addItem(squad);
               newSquads.push(squad);
            }
            
            // we only need to add units if they have not been added earlier
            if (!squad.units.find(unit.id))
            {
               squad.units.addItem(unit);
            }
         }
         
         for each (squad in newSquads)
         {
            squad.client_internal::rebuildCachedUnits()
         }
      }
      
      
      /**
       * Removes given units from squadrons, if they are in any squadron. Will destroy any stationary
       * squadron that does not have units anymore after this operation.
       */
      public function removeUnitsFromSquadrons(units:IList) : void
      {
         for (var i:int = 0; i < units.length; i++)
         {
            var unit:Unit = Unit(units.getItemAt(i));
            var squad:MSquadron = SQUADS.findFirst(
               function(squad:MSquadron) : Boolean
               {
                  return squad.units.findExact(unit) != null;
               }
            );
            if (squad)
            {
               squad.units.remove(unit.id);
               if (!squad.isMoving && !squad.hasUnits)
               {
                  SQUADS.removeSquadron(squad);
               }
            }
         }
      }
      
      
      /* ################################## */
      /* ### SQUADS MOVEMENT AUTOMATION ### */
      /* ################################## */
      
      
      private var _timer:Timer;
      
      
      private function movementTimer_timerHandler(event:TimerEvent) : void
      {
         var aheadTime:Number = components.map.space.SquadronsController.MOVE_EFFECT_DURATION + 500;
         var currentTime:Number = new Date().time;
         for each (var squad:MSquadron in SQUADS)
         {
            if (squad.isMoving && squad.hasHopsRemaining && squad.nextHop.arrivesAt.time - aheadTime <= currentTime)
            {
               squad.moveToNextHop();
            }
         }
      }
      
      
      public function startMovementTimer() : void
      {
         _timer.start();
      }
      
      
      public function stopMovementTimer() : void
      {
         _timer.stop();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function findSquad(id:int, owner:int = Owner.UNDEFINED, loc:LocationMinimal = null) : MSquadron
      {
         return SQUADS.findFirst(
            function(squad:MSquadron) : Boolean
            {
               if (squad.isMoving)
               {
                  return squad.id == id;
               }
               return squad.owner == owner && squad.currentHop.location.equals(loc);
            }
         );
      }
      
      
      private function throwIllegalMovingSquadId(id:int) : void
      {
         throw new ArgumentError("Illegal moving squadron id: " + id);
      }
   }
}