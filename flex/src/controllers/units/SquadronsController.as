package controllers.units
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import components.map.space.SquadronsController;
   
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.ModelsCollection;
   import models.Owner;
   import models.factories.SquadronFactory;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.map.Map;
   import models.movement.MHop;
   import models.movement.MRoute;
   import models.movement.MSquadron;
   import models.movement.SquadronsList;
   import models.planet.Planet;
   import models.unit.Unit;
   import models.unit.UnitKind;
   import models.unit.UnitsList;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   
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
      
      
      /**
       * How much earlier squadron will be moved to a next hop than it should be considering <code>arrivesAt</code>
       * value. This is needed due to synchronisation issues with server. Probably this is not the right solution
       * and might solve some problems while others will arise.
       */
      private static const EARLY_MOVEMENT_TIME_DIFF:int = 500;     // milliseconds
      /**
       * @see components.map.space.SquadronsController#MOVE_EFFECT_DURATION
       */
      private static const MOVE_EFFECT_DURATION:int =              // milliseconds
         components.map.space.SquadronsController.MOVE_EFFECT_DURATION
      private static const MOVEMENT_TIMER_DELAY:int = 500;         // milliseconds
      
      
      private var ML:ModelLocator = ModelLocator.getInstance();
      private var SQUADS:SquadronsList = ML.squadrons;
      private var ROUTES:ModelsCollection = ML.routes;
      private var UNITS:UnitsList = ML.units;
      
      
      public function SquadronsController()
      {
         _timer = new Timer(MOVEMENT_TIMER_DELAY);
         _timer.addEventListener(TimerEvent.TIMER, movementTimer_timerHandler);
         UNITS.addEventListener(CollectionEvent.COLLECTION_CHANGE, units_collectionChangeHandler);
      }
      
      
      /**
       * Use to add a hop to any squadron when that hop is received from the server. Will
       * ignore given hop if squadron to add the hop to can't be found.
       */
      public function addHopToSquadron(hop:Object) : void
      {
         var hopM:MHop = BaseModel.createModel(MHop, hop);
         var squad:MSquadron = SQUADS.findMoving(hopM.routeId);
         if (squad)
         {
            squad.addHop(hopM);
         }
      }
      
      
      /**
       * Use to add hops to squadrons.
       * 
       * @param hops an array of generic objects that represent hops. May hold hops for different squadrons
       * 
       * @see #addHopToSquadron()
       */
      public function addHopsToSquadrons(hops:Array) : void
      {
         for each (var hop:Object in hops)
         {
            addHopToSquadron(hop);
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
      public function destroySquadron(id:int) : void
      {
         if (id <= 0)
         {
            throw new ArgumentError("Illegal moving squadron id: " + id);
         }
         var squad:MSquadron = SQUADS.findMoving(id);
         if (squad)
         {
            SQUADS.removeSquadron(squad);
         }
      }
      
      
      /**
       * Use to update <code>currentLocation</code> of frienldy squadron.
       * 
       * @param id id of a moving squadron wich belongs to either the player or an ally
       */
      public function updateFriendlySquadron(id:int, location:Location) : void
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
//         if (id <= 0)
//         {
//            throwIllegalMovingSquadId(id);
//         }
//         
//         var squadToStop:MSquadron = SQUADS.findMoving(id);
//         if (!squadToStop)
//         {
//            return;
//         }
//         SQUADS.removeSquadron(squadToStop);
//         squadToStop.id = 0;
//         squadToStop.arrivesAt = null;
//         squadToStop.sourceLocation = null;
//         squadToStop.targetLocation = null;
//         squadToStop.removeAllHops();
//         for each (var unit:Unit in squadToStop.units)
//         {
//            unit.squadronId = 0;
//         }
//         var squadStationary:MSquadron = findSquad(0, squadToStop.owner, squadToStop.currentHop.location);
//         if (squadStationary)
//         {
//            squadStationary.merge(squadToStop);
//         }
//         else
//         {
//            if (squadToStop.hasUnits)
//            {
//               SQUADS.addItem(squadToStop);
//            }
//         }
      }
      
      
      /**
       * Use to create all routes and add them to </code>ModelLocator</code> when they are received
       * from the server after player has logged in.
       */
      public function createRoutes(dataArray:Array) : void
      {
         for each (var data:Object in dataArray)
         {
            createRoute(data);
         }
      }
      
      
      /**
       * Use to create an instance of <code>MRoute</code> form generic object and add it to
       * <code>ModelLocator.routes</code> list.
       * 
       * @return route model wich has been created.
       */
      public function createRoute(data:Object) : MRoute
      {
         var route:MRoute = BaseModel.createModel(MRoute, data);
         ROUTES.addItem(route);
      }
      
      
      /**
       * Call this when any units have made a jump between maps or when hostile units have jumped
       * into player's visible area.
       */
      public function executeJump(units:IList, hops:IList) : void
      {
//         var sampleUnit:Unit = Unit(units.getItemAt(0));
//         // either move existing squadron to another map
//         var squad:MSquadron = SQUADS.findMoving(sampleUnit.squadronId);
//         if (squad)
//         {
//            // remove units from the planet if it's a takeoff
//            if (squad.currentHop.location.isSSObject &&
//                squad.currentHop.location.isObserved)
//            {
//               var unitIds:Array = new Array();
//               for each (var unit:Unit in units.toArray())
//               {
//                  unitIds.push(unit.id);
//               }
//               ML.latestPlanet.removeUnits(unitIds);
//            }
//            // add units to a planet if it's a landing
//            if (sampleUnit.location.isSSObject &&
//                sampleUnit.location.isObserved)
//            {
//               ML.latestPlanet.addAllUnits(units);
//            }
//            squad.currentLocation = sampleUnit.location;
//            squad.client_internal::createCurrentHop();
//            squad.addAllHops(hops);
//            if (!squad.currentLocation.isObserved)
//            {
//               if (squad.isHostile)
//               {
//                  SQUADS.removeSquadron(squad);
//               }
//               else
//               {
//                  squad.removeAllUnits();
//               }
//            }
//         }
//            // or create new squadron wich must be hostile
//         else if (sampleUnit.owner == Owner.NAP || sampleUnit.owner == Owner.ENEMY)
//         {
//            if (sampleUnit.location.isObserved)
//            {
//               squad = SquadronFactory.fromUnit(sampleUnit);
//               squad.addAllUnits(units);
//               squad.addAllHops(hops);
//               SQUADS.addItem(squad);
//            }
//         }
//         else
//         {
//            throw new Error("Unable to execute jump: units " + units + " belong to a friendly " +
//               "player but corresponding squadron could not be found");
//         }
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
//         var squad:MSquadron;
//         var units:IList = new ArrayCollection();
//         var unitIds:ArrayCollection = new ArrayCollection($unitIds);
//         var currentLocation:LocationMinimal = BaseModel.createModel(LocationMinimal, route.current);
//         
//         // looking for units that need to be moved
//         function findUnitsWithIdsIn(units:IList) : IList
//         {
//            return Collections.filter(units,
//               function(unit:Unit) : Boolean
//               {
//                  return unitIds.contains(unit.id);
//               }
//            );
//         };
//         if (currentLocation.isObserved)
//         {
//            if (currentLocation.isSSObject)
//            {
//               units = findUnitsWithIdsIn(ML.latestPlanet.units);
//            }
//            else
//            {
//               for each (squad in SQUADS)
//               {
//                  units = findUnitsWithIdsIn(squad.units);
//                  if (units.length != 0)
//                  {
//                     break;
//                  }
//               }
//            }
//         }
//         
//         // we found units
//         // that means we have a cached map in which those units are located so just create a squadron
//         if (units.length != 0)
//         {
//            var sampleUnit:Unit = Unit(units.getItemAt(0));
//            var existingSquad:MSquadron = findSquad(sampleUnit.squadronId, sampleUnit.owner, currentLocation);
//            squad = SquadronFactory.fromObject(route);
//            squad.owner = sampleUnit.owner;
//            squad.addAllUnits(units);
//            // separate units from existing squadron if there is one
//            if (existingSquad)
//            {
//               if (!existingSquad.separateUnits(squad))
//               {
//                  SQUADS.removeSquadron(existingSquad);
//               }
//            }
//            SQUADS.addItem(squad);
//         }
//            // ALLY or PLAYER units are starting to move but we don't have that map open
//         else if (route.target !== undefined)
//         {
//            createMovingFriendlySquadron(route);
//         }
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
//      public function distributeUnitsToSquadrons(units:IList) : void
//      {
//         var squad:MSquadron;
//         var newSquads:Array = new Array();
//         for each (var unit:Unit in units.toArray())
//         {
//            if (unit.kind != UnitKind.SPACE || !unit.isMoving && (!unit.location || unit.location.isSSObject))
//            {
//               continue;
//            }
//            
//            var unitOwner:int = unit.owner != Owner.UNDEFINED ? unit.owner : Owner.ENEMY;
//            squad = findSquad(unit.squadronId, unitOwner, unit.location);
//            
//            // No squadron for the unit: create one
//            if (!squad)
//            {
//               squad = SquadronFactory.fromUnit(unit);
//               SQUADS.addItem(squad);
//               newSquads.push(squad);
//            }
//            
//            // we only need to add units if they have not been added earlier
//            if (!squad.units.find(unit.id))
//            {
//               squad.units.addItem(unit);
//            }
//         }
//         
//         for each (squad in newSquads)
//         {
//            squad.client_internal::rebuildCachedUnits()
//         }
//      }
      
      
      /* ################################## */
      /* ### UNITS LIST CHANGE HANDLING ### */
      /* ################################## */
      
      
      private function units_collectionChangeHandler(event:CollectionEvent) : void
      {
         switch (event.kind)
         {
            case CollectionEventKind.ADD:
               for each (var unit:Unit in event.items) unitAdded(unit);
               break;
            case CollectionEventKind.REMOVE:
               for each (var unit:Unit in event.items) unitRemoved(unit);
               break;
            case CollectionEventKind.UPDATE:
               for each (var pce:PropertyChangeEvent in event.items) unitUpdated(pce);
               break;
         }
      }
      
      
      private function unitAdded(unit:Unit) : void
      {
         
      }
      
      
      private function unitRemoved(unit:Unit) : void
      {
         
      }
      
      
      private function unitUpdated(pce:PropertyChangeEvent) : void
      {
         
      }
      
      
      /* ################################## */
      /* ### SQUADS MOVEMENT AUTOMATION ### */
      /* ################################## */
      
      
      private var _timer:Timer;
      
      
      private function movementTimer_timerHandler(event:TimerEvent) : void
      {
         var currentTime:Number = new Date().time;
         for each (var squad:MSquadron in SQUADS)
         {
            if (squad.isMoving && squad.hasHopsRemaining &&
                squad.nextHop.arrivesAt.time - MOVE_EFFECT_DURATION - EARLY_MOVEMENT_TIME_DIFF <= currentTime)
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
         if (id != 0)
         {
            return SQUADS.findMoving(id);
         }
         else
         {
            return SQUADS.findStationary(loc, owner);
         }
      }
      
      
      private function findRoute(id:int) : MRoute
      {
         return ROUTES.find(id);
      }
      
      
      private function throwIllegalMovingSquadId(id:int) : void
      {
         throw new ArgumentError("Illegal moving squadron id: " + id);
      }
   }
}