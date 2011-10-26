package controllers.units
{
   import components.map.space.SquadronsController;
   
   import controllers.GlobalFlags;
   import controllers.Messenger;
   
   import globalevents.GlobalEvent;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.ModelsCollection;
   import models.Owner;
   import models.factories.PlayerFactory;
   import models.factories.SquadronFactory;
   import models.factories.UnitFactory;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.map.MMap;
   import models.movement.MHop;
   import models.movement.MRoute;
   import models.movement.MSquadron;
   import models.movement.SquadronsList;
   import models.player.PlayerId;
   import models.unit.MCUnitScreen;
   import models.unit.Unit;
   import models.unit.UnitKind;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.ObjectUtil;
   
   import utils.DateUtil;
   import utils.Objects;
   import utils.SingletonFactory;
   import utils.datastructures.Collections;
   import utils.locale.Localizer;
   
   
   /**
    * Works with <code>MSquadron</code> objects and <code>ModelLocator.squadrons</code> list.
    */
   public class SquadronsController
   {
      public static function getInstance() : SquadronsController {
         return SingletonFactory.getSingletonInstance(SquadronsController);
      }
      
      
      /**
       * @see components.map.space.SquadronsController#MOVE_EFFECT_DURATION
       */
      private static const MOVE_EFFECT_DURATION:int =              // milliseconds
         components.map.space.SquadronsController.MOVE_EFFECT_DURATION
      
      
      private var ORDERS_CTRL:OrdersController = OrdersController.getInstance();
      private var GF:GlobalFlags = GlobalFlags.getInstance();
      private var ML:ModelLocator = ModelLocator.getInstance();
      private var SQUADS:SquadronsList = ML.squadrons;
      private var ROUTES:ModelsCollection = ML.routes;
      private var UNITS:ModelsCollection = ML.units;
      
      private function get logger() : ILogger {
         return Log.getLogger("MOVEMENT");
      }
      
      public function SquadronsController()
      {
         GlobalEvent.subscribe_TIMED_UPDATE(global_timedUpdateHandler);
      }
      
      
      /**
       * Use to add a hop to any squadron when that hop is received from the server. Will
       * ignore given hop if squadron to add the hop to can't be found.
       */
      public function addHopToSquadron(hop:MHop) : void {
         var squad:MSquadron = findSquad(hop.routeId);
         if (squad != null) {
            squad.addHop(hop);
         }
      }
      
      
      /**
       * Use to add hops to squadrons.
       * 
       * @param hops an array of <code>MHop</code> instances. May hold hops for different squadrons.
       * 
       * @see #addHopToSquadron()
       */
      public function addHopsToSquadrons(hops:Array) : void
      {
         for each (var hop:MHop in hops) {
            addHopToSquadron(hop);
         }
      }
      
      
      /**
       * Attaches <code>jumpsAt</code> (creates route and) to hostile squadrons in the given list.
       * Used in <code>galaxies|show</code>, <code>solarSystems|show</code> and <code>planets|show</code>
       * actions only.
       */
      public function attachJumpsAtToHostileSquads(squads:IList, jumpsAtHash:Object) : void {
         Objects.paramNotNull("squads", squads);
         Objects.paramNotNull("jumpsAtHash", jumpsAtHash);
         for each (var squad:MSquadron in squads) {
            if (squad.isMoving && squad.isHostile) {
               SquadronFactory.attachJumpsAt(squad.route, jumpsAtHash[squad.id]);
            }
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
       * 
       * @return <code>true</code> if squad has been destroyed or <code>false</code> otherwise
       */
      public function destroySquadron(id:int) : Boolean
      {
         if (id <= 0)
         {
            throw new ArgumentError("Illegal moving squadron id: " + id);
         }
         logger.debug("Will try to destroy squad {0}", id);
         var squad:MSquadron = SQUADS.remove(id, true);
         if (squad != null)
         {
            logger.debug("Destroying squadron {0}", squad);
            var fromPlanet: Boolean = squad.currentHop.location.isSSObject;
            var unitIds:Array = squad.units.toArray().map(
               function(unit:Unit, index:int, array:Array) : int {
                  return unit.id;
               }
            );
            logger.debug("   removing units {0}", unitIds);
            Collections.cleanListOfICleanables(squad.units);
            squad.cleanup();
            // If units navigate from planet we need to refresh some getters
            if (ML.latestPlanet != null && fromPlanet) {
               ML.latestPlanet.units.refresh();
               ML.latestPlanet.dispatchUnitRefreshEvent();
            }
         }
         return squad != null;
      }
      
      
      /**
       * Use to update <code>currentLocation</code>, <code>cachedUnits</code> and <code>jumpsAt</code> 
       * of a route.
       * 
       * @param routeData generic object that represents a route to update
       */
      public function updateRoute(routeData:Object) : void
      {
         var routeId:int = routeData["id"]; 
         if (routeId <= 0) {
            throwIllegalMovingSquadId(routeId);
         }
         
         var route:MRoute = findRoute(routeId);
         var squad:MSquadron = findSquad(routeId);
         if (route == null) {
            if (squad == null) {
               throw new ArgumentError(
                  "Unable to update route and squadron: route with id " + routeId + " could not be found." +
                  "New route data was: " + ObjectUtil.toString(routeData)
               );
            }
            route = squad.route;
         }
         // sometimes server sends objects|updated with route before client
         // runs another periodic update. So if ships are jumping, the jump will be delayed
         // and they will remain in the wrong map therefore screwing things up a little
         var jumpsAtString:String = routeData["jumpsAt"];
         var jumpsAt:Date = jumpsAtString != null ? DateUtil.parseServerDTF(jumpsAtString) : null;
         if (squad != null
               && !squad.hasHopsRemaining
               && squad.jumpPending
               // Not using squad.jumpsAtEvent.hasOccured here to allow slight errors.
               // The size of the error is worth to consider since client and server clocks are not
               // in perfect sync. I think a situation might occure - although *very rarely* - when
               // old jumpsAt and the new jumpsAt differ more than 200 ms but they actually define
               // the same jump. In such case ships will be removed a bit too early but players
               // might not even notice that as we have 500 ms errors anyway due to duration of effects
               && (jumpsAt == null || (squad.jumpsAtEvent.occuresAt.time - jumpsAt.time) < -200)) {
            logger.debug(
               "Received new jumpsAt {0} form server for squad {1} before the old " +
               "jumpsAt {2} was cleared. Forcing the jump (removing squad) before update.",
               jumpsAt, squad, squad.jumpsAtEvent.occuresAt
            );
            destroySquadron(squad.id);
         }
         SquadronFactory.attachJumpsAt(route, jumpsAtString);
         route.currentLocation = BaseModel.createModel(Location, routeData["current"]);
         route.cachedUnits.removeAll();
         route.cachedUnits.addAll(UnitFactory.createCachedUnits(routeData["cachedUnits"]));
      }
      
      
      /**
       * Use to stop a squadron which is moving. Will ignore IDs of squadrons not present in
       * <code>ModelLocator.squadrons</code>.
       */
      public function stopSquadron(id:int, atLastHop:Boolean) : void
      {
         function refreshUnitsInUnitScreenModel() : void {
            if (ML.latestPlanet != null) {
               // TODO: Find out why some filters don't refresh if you dont call 
               // refresh function on the list
               var US:MCUnitScreen = MCUnitScreen.getInstance();
               if (US.units != null) {
                  US.units.refresh();
                  US.refreshScreen();
               }
            }
         }
         
         if (id <= 0) {
            throwIllegalMovingSquadId(id);
         }
         ROUTES.remove(id, true);
         var squadToStop:MSquadron = SQUADS.remove(id, true);
         if (squadToStop == null) {
            return;
         }
         if (atLastHop) {
            squadToStop.moveToLastHop();
            // This behaviour (destruction of squad) relies on the fact that the server
            // will send units|movement *before* objects|destroyed with a route. Because it does that
            // this squad is already in the map that it needs to be and jumpsAt is null when squad
            // needs to be stopped in that map. If it needs to be stopped just in another map in an
            // immediate sector after jump, squad has to be destroyed because that map is not cached.
            if (squadToStop.jumpPending && squadToStop.jumpsAtEvent.hasOccured) {
               squadToStop.cleanup();
               refreshUnitsInUnitScreenModel();
               return;
            }
         }
         squadToStop.id = 0;
         squadToStop.route = null;
         var squadStationary:MSquadron = findSquad(0, squadToStop.player.id, squadToStop.currentHop.location);
         if (squadStationary != null)
         {
            squadStationary.units.refresh();
            squadToStop.cleanup();
         }
         else if (!squadToStop.currentHop.location.isSSObject)
         {
            // Don't use squadToStop again: asynchronousity problems arise. See
            // components.map.space.SquadronsController#destroySquadron() for more explanation on this
            squadStationary = new MSquadron();
            with (squadStationary)
            {
               owner = squadToStop.owner;
               player = squadToStop.player;
               currentHop = squadToStop.currentHop;
            }
            
            SQUADS.addItem(squadStationary);
            squadToStop.cleanup();
         }
         else {
            refreshUnitsInUnitScreenModel();
         }
      }
      
      /**
       * Use when new routes are pushed by the server in the middle of the game. This method removes all
       * existing routes, creates new ones, adds them to routes list and attaches them to squadrons.
       */ 
      public function recreateRoutes(routes:Array, playersHash:Object) : void {
         ROUTES.removeAll();
         createRoutes(routes, playersHash);
         for each (var route:MRoute in ROUTES) {
            var squad:MSquadron = SQUADS.find(route.id);
            if (squad != null)
               squad.route = route;
         }
      }
      
      
      /**
       * Use to create all routes and add them to </code>ModelLocator</code> when they are received
       * from the server after player has logged in.
       */
      public function createRoutes(routes:Array, playersHash:Object) : void
      {
         var players:Object = PlayerFactory.fromHash(playersHash);
         for each (var routeData:Object in routes)
         {
            var route:MRoute = createRoute
               (routeData, routeData["player"]["id"] == ML.player.id ? Owner.PLAYER : Owner.ALLY);
            route.player = players[route.player.id];
         }
      }
      
      
      /**
       * Use to create an instance of <code>MRoute</code> form generic object and add it to
       * <code>ModelLocator.routes</code> list.
       * 
       * @return route model which has been created.
       */
      public function createRoute(data:Object, owner:int = Owner.NPC) : MRoute
      {
         var route:MRoute = BaseModel.createModel(MRoute, data);
         route.cachedUnits.addAll(UnitFactory.createCachedUnits(data["cachedUnits"]));
         if (owner != Owner.NPC)
            route.owner = owner;
         ROUTES.addItem(route);
         return route;
      }
      
      /**
       * Call this when any units have made a jump between maps (new batch of hops is received form 
       * the server) or when some units have jumped into player's visible area.
       */
      public function executeJump(units:IList, hops:IList, jumpsAt:String) : void {
         Objects.paramNotNull("units", units);
         Objects.paramNotNull("hops", hops);
         var sampleUnit:Unit = Unit(units.getItemAt(0));
         // OK. We do this the simple way: if we got squad already, we wipe it out and we will recreate it.
         // Because update is too difficult and I always get it wrong.
         var squad:MSquadron = findSquad(sampleUnit.squadronId);
         if (squad != null) {
            destroySquadron(squad.id);
         }
         if (sampleUnit.location.isObserved
               ||  sampleUnit.location.isGalaxy
               && (sampleUnit.owner == Owner.PLAYER || sampleUnit.owner == Owner.ALLY)) {
            UNITS.addAll(units);
            squad = SquadronFactory.fromUnit(sampleUnit);
            squad.addAllHops(hops);
            if (squad.isFriendly) {
               squad.route = findRoute(squad.id);
               SquadronFactory.attachJumpsAt(squad.route, jumpsAt);
            }
            else {
               SquadronFactory.createHostileRoute(squad, jumpsAt);
            }
            SQUADS.addItem(squad);
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
         var currentLocation:LocationMinimal = BaseModel.createModel(LocationMinimal, route["current"]);
         if (currentLocation.isSSObject) {
            currentLocation.setDefaultCoordinates();
         }
         
         // get the units we need to move
         var units:ListCollectionView = Collections.filter(UNITS,
            function(unit:Unit) : Boolean {
               return unitIds.contains(unit.id);
            }
         );
         
         // we found units
         // that means we have a cached map in which those units are located: create a squadron
         if (units.length != 0) {
            var unit:Unit = Unit(units.getItemAt(0));
            var squadExisting:MSquadron = findSquad(unit.squadronId, unit.playerId, currentLocation);
            route["status"] = unit.owner; 
            squad = SquadronFactory.fromObject(route);
            squad.player = unit.player;
            squad.addAllHops(BaseModel.createCollection(ArrayCollection, MHop, route["hops"]));
            units.disableAutoUpdate();
            for each (unit in units) {
               unit.squadronId = squad.id;
            }
            if (unit.location.isSSObject) {
               ML.latestPlanet.dispatchUnitRefreshEvent();
            }
            units.enableAutoUpdate();
            if (squad.isFriendly) {
               squad.route = createRoute(route);
               squad.route.player = squad.player;
            }
            else {
               SquadronFactory.createHostileRoute(squad, route["jumpsAt"]);
            }
            if (squadExisting != null && !squadExisting.hasUnits) {
               SQUADS.removeExact(squadExisting);
               squadExisting.cleanup();
            }
            SQUADS.addItem(squad);
            if (squad.owner == Owner.PLAYER && ORDERS_CTRL.issuingOrders) {
               ORDERS_CTRL.orderComplete();
               GF.lockApplication = false;
               Messenger.show(Localizer.string("Movement", "message.orderComplete"), Messenger.MEDIUM);
            }
         }
         // ALLY or PLAYER units are starting to move but we don't have that map open: create route then
         else if (route["target"] !== undefined) {
            var owner:int = route["player"]["id"] == ML.player.id ? Owner.PLAYER : Owner.ALLY;
            createRoute(route, owner);
            if (owner == Owner.PLAYER && ORDERS_CTRL.issuingOrders) {
               ORDERS_CTRL.orderComplete();
               GF.lockApplication = false;
            }
         }
         
         units.list = null;
         units.filterFunction = null;
      }
      
      
      /**
       * Creates squadrons for given units.
       * 
       * <p>Do not use for starting units movement. Use <code>createSquadron()</code> for that.</p>
       */
      public function createSquadronsForUnits(units:IList, map:MMap) : void
      {
         var squad:MSquadron;
         for each (var unit:Unit in units.toArray()) {
            if (unit.kind != UnitKind.SPACE || !unit.isMoving && (!unit.location || unit.location.isSSObject))
               continue;
            
            squad = findSquad(unit.squadronId, unit.playerId, unit.location);
            
            // No squadron for the unit: create one
            if (squad == null) {
               squad = SquadronFactory.fromUnit(unit);
               if (squad.isMoving) {
                  if (squad.isFriendly) {
                     squad.route = ROUTES.find(squad.id);
                  }
                  else {
                     SquadronFactory.createHostileRoute(
                        squad, null, map.getLocation(unit.location.x, unit.location.y)
                     );
                  }
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
      public function destroyEmptySquadrons(units:IList) : void {
         for each (var unit:Unit in units.toArray()) {
            if (unit.kind == UnitKind.SPACE) {
               var squad:MSquadron = findSquad(unit.squadronId, unit.playerId, unit.location);
               if (squad != null) {
                  squad.units.refresh();
                  if (!squad.hasUnits) {
                     SQUADS.removeExact(squad);
                     if (squad.isMoving && squad.isFriendly) {
                        ROUTES.remove(squad.id);
                     }
                     squad.cleanup();
                  }
               }
            }
         }
      }
      
      
      /* ################################## */
      /* ### SQUADS MOVEMENT AUTOMATION ### */
      /* ################################## */
      
      private function global_timedUpdateHandler(event:GlobalEvent) : void {
         var currentTime:Number = DateUtil.now;
         var squadId:int;
         for each (var squad:MSquadron in SQUADS.toArray()) {
            if (squad.isMoving && !squad.pending) {
               squadId = squad.id;
               if (squad.hasHopsRemaining) {
                  squad.moveToNextHop(currentTime + MOVE_EFFECT_DURATION);
                  var loc:LocationMinimal = squad.currentHop.location;
                  if (!loc.isObserved && (squad.isHostile || squad.isFriendly && !loc.isGalaxy)) {
                     destroySquadron(squadId);
                  }
               }
               else if (squad.jumpPending && squad.jumpsAtEvent.hasOccured) {
                  destroySquadron(squadId);
               }
            }
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function findSquad(id:int,
                                 palyerId:int = PlayerId.NO_PLAYER,
                                 loc:LocationMinimal = null) : MSquadron {
         if (id != 0) {
            return SQUADS.find(id);
         }
         else {
            return SQUADS.findStationary(loc, palyerId);
         }
      }
      
      private function findRoute(id:int) : MRoute {
         return ROUTES.find(id);
      }
      
      private function throwIllegalMovingSquadId(id:int) : void {
         throw new ArgumentError("Illegal moving squadron id: " + id);
      }
   }
}