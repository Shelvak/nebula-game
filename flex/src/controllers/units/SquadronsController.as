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
   import models.movement.MHop;
   import models.movement.MRoute;
   import models.movement.MSquadron;
   import models.movement.SquadronsList;
   import models.unit.Unit;
   import models.unit.UnitBuildingEntry;
   import models.unit.UnitKind;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   
   import utils.StringUtil;
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
      private var UNITS:ModelsCollection = ML.units;
      
      
      public function SquadronsController()
      {
         _timer = new Timer(MOVEMENT_TIMER_DELAY);
         _timer.addEventListener(TimerEvent.TIMER, movementTimer_timerHandler);
      }
      
      
      /**
       * Use to add a hop to any squadron when that hop is received from the server. Will
       * ignore given hop if squadron to add the hop to can't be found.
       */
      public function addHopToSquadron(hop:Object) : void
      {
         var hopM:MHop = BaseModel.createModel(MHop, hop);
         var squad:MSquadron = findSquad(hopM.routeId);
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
       * Will also remove all units in the squadron and corresponding <code>MRoute</code> (if
       * <code>removeRoute</code> is <code>true</code>)
       * 
       * @param id id of moving squadron. If a squadron with given id could not be found, nothing happens
       * @param removeRoute if <code>false</code>, corresponding route will not be removed
       */
      public function destroySquadron(id:int, removeRoute:Boolean = true) : void
      {
         if (id <= 0)
         {
            throw new ArgumentError("Illegal moving squadron id: " + id);
         }
         var squad:MSquadron = SQUADS.remove(id, true);
         if (squad)
         {
            squad.units.removeAll();
            squad.cleanup();
         }
         if (removeRoute)
         {
            ROUTES.remove(id, true);
         }
      }
      
      
      /**
       * Use to update <code>currentLocation</code> of a route.
       * 
       * @param id id of a route (and moving squadron) wich belongs to either the player or an ally
       */
      public function updateRoute(id:int, location:Location) : void
      {
         if (id <= 0)
         {
            throwIllegalMovingSquadId(id);
         }
         var route:MRoute = findRoute(id);
         if (!route)
         {
            throw new ArgumentError("Unable to update route and squadron: route with id " + id + " could not be found");
         }
         route.currentLocation = location;
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
         ROUTES.remove(id, true);
         var squadToStop:MSquadron = SQUADS.remove(id, true);
         if (!squadToStop)
         {
            return;
         }
         squadToStop.id = 0;
         squadToStop.route = null;
         squadToStop.removeAllHops();
         var squadStationary:MSquadron = findSquad(0, squadToStop.owner, squadToStop.currentHop.location);
         if (squadStationary)
         {
            squadToStop.cleanup();
            return;
         }
         else if (!squadToStop.currentHop.location.isSSObject)
         {
            SQUADS.addItem(squadToStop);
         }
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
         for (var unitType:String in data.cachedUnits)
         {
            var entry:UnitBuildingEntry = new UnitBuildingEntry(
               "unit::" + StringUtil.firstToUpperCase(unitType),
               data.cachedUnits[unitType]
            );
            route.cachedUnits.addItem(entry);
         }
         ROUTES.addItem(route);
         return route;
      }
      
      
      /**
       * Call this when any units have made a jump between maps or when hostile units have jumped
       * into player's visible area.
       */
      public function executeJump(units:IList, hops:IList) : void
      {
         var sampleUnit:Unit = Unit(units.getItemAt(0));
         // either move existing squadron to another map
         var squad:MSquadron = findSquad(sampleUnit.squadronId);
         if (squad)
         {
            // if we don't see location given units have jumped to, destroy the squadron (units are
            // removed by destroySquadron() method)
            if (!sampleUnit.location.isObserved)
            {
               destroySquadron(squad.id, false);
            }
            // otherwise make the jump
            else
            {
               squad.createCurrentHop(sampleUnit.location);
               squad.addHop(squad.currentHop);
               squad.moveToNextHop();
               squad.addAllHops(hops);
            }
         }
         // or create new squadron which must be hostile
         else if (sampleUnit.owner == Owner.NAP || sampleUnit.owner == Owner.ENEMY)
         {
            if (sampleUnit.location.isObserved)
            {
               UNITS.addAll(units);
               squad = SquadronFactory.fromUnit(sampleUnit);
               squad.addAllHops(hops);
               SQUADS.addItem(squad);
            }
         }
         else
         {
            throw new Error(
               "Unable to execute jump: units " + units + " belong to a friendly player but " +
               "corresponding squadron could not be found"
            );
         }
      }
      
      
      /**
       * Use when you need to create new squadron when any stationary units need to be moved or
       * when units moving already need to be dispatched different way.
       * 
       * @param route generic object representing a squadron. It must have hops array
       * @param unitIds array of ids on units to be moved
       */
      public function startMovement(route:Object, $unitIds:Array) : void
      {
         var squad:MSquadron;
         var unitIds:ArrayCollection = new ArrayCollection($unitIds);
         var currentLocation:LocationMinimal = BaseModel.createModel(LocationMinimal, route.current);
         
         // get the units we need to move
         var units:ListCollectionView = Collections.filter(UNITS,
            function(unit:Unit) : Boolean
            {
               return unitIds.contains(unit.id);
            }
         );
         
         // we found units
         // that means we have a cached map in which those units are located: create a squadron
         if (units.length != 0)
         {
            var unit:Unit = Unit(units.getItemAt(0));
            var squadExisting:MSquadron = findSquad(unit.squadronId, unit.owner, currentLocation);
            route.status = unit.owner; 
            squad = SquadronFactory.fromObject(route);
            squad.addAllHops(BaseModel.createCollection(ArrayCollection, MHop, route.hops));
            for each (unit in units)
            {
               unit.squadronId = squad.id;
            }
            if (squad.isFriendly)
            {
               squad.route = createRoute(route);
            }
            if (squadExisting && !squadExisting.hasUnits)
            {
               SQUADS.removeExact(squadExisting);
               squadExisting.cleanup();
            }
            SQUADS.addItem(squad);
         }
         // ALLY or PLAYER units are starting to move but we don't have that map open: create route then
         else if (route.target !== undefined)
         {
            createRoute(route);
         }
         
         units.list = null;
         units.filterFunction = null;
      }
      
      
      /**
       * Creates squadrons for given units.
       * 
       * <p>Do not use for starting units movement. Use <code>createSquadron()</code> for that.</p>
       */
      public function createSquadronsForUnits(units:IList) : void
      {
         var squad:MSquadron;
         for each (var unit:Unit in units.toArray())
         {
            if (unit.kind != UnitKind.SPACE || !unit.isMoving && (!unit.location || unit.location.isSSObject))
            {
               continue;
            }
            
            var unitOwner:int = unit.owner != Owner.UNDEFINED ? unit.owner : Owner.ENEMY;
            squad = findSquad(unit.squadronId, unitOwner, unit.location);
            
            // No squadron for the unit: create one
            if (!squad)
            {
               squad = SquadronFactory.fromUnit(unit);
               if (squad.isMoving && squad.isFriendly)
               {
                  squad.route = ROUTES.find(squad.id);
               }
               SQUADS.addItem(squad);
            }
         }
      }
      
      
      /**
       * Will destroy all squadrons (and routes) that previously aggregated given units (wich have been
       * destroyed) and currently do not have any units. Call only when <code>objects|destroyed</code>
       * with <code>objectClass == ObjectClass.UNIT</code> has been received from server.
       * 
       * @param units collection of units wich have been destroyed for some reason
       */
      public function destroyEmptySquadrons(units:IList) : void
      {
         for each (var unit:Unit in units.toArray())
         {
            if (unit.kind == UnitKind.SPACE)
            {
               var squad:MSquadron = findSquad(unit.squadronId, unit.owner, unit.location);
               if (!squad.hasUnits)
               {
                  SQUADS.removeExact(squad);
                  if (squad.isMoving && squad.isFriendly)
                  {
                     ROUTES.remove(squad.id);
                  }
                  squad.cleanup();
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
            return SQUADS.find(id);
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