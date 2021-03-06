package controllers.units
{
   import components.map.space.SquadronsController;

   import controllers.startup.StartupInfo;
   import controllers.timedupdate.MasterUpdateTrigger;

   import interfaces.IUpdatable;

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
   import models.notification.MSuccessEvent;
   import models.unit.MCUnitScreen;
   import models.unit.Unit;
   import models.unit.UnitKind;

   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.logging.ILogger;
   import mx.utils.ObjectUtil;

   import utils.DateUtil;
   import utils.Objects;
   import utils.SingletonFactory;
   import utils.datastructures.Collections;
   import utils.locale.Localizer;
   import utils.logging.IMethodLoggerFactory;
   import utils.logging.Log;


   /**
    * Works with <code>MSquadron</code> objects and <code>ModelLocator.squadrons</code> list.
    */
   public class SquadronsController implements IUpdatable
   {
      public static function getInstance() : SquadronsController {
         return SingletonFactory.getSingletonInstance(SquadronsController);
      }
      
      
      /**
       * @see components.map.space.SquadronsController#MOVE_EFFECT_DURATION
       */
      private static const MOVE_EFFECT_DURATION: int = // milliseconds
                              components.map.space.SquadronsController
                                 .MOVE_EFFECT_DURATION;
      private const ML: ModelLocator = ModelLocator.getInstance();
      private const SQUADS: SquadronsList = ML.squadrons;
      private const ROUTES: ModelsCollection = ML.routes;
      private const UNITS: ModelsCollection = ML.units;

      private const loggerFactory: IMethodLoggerFactory = Log.getMethodLoggerFactory("MOVEMENT");
      
      
      /**
       * Use to add a hop to any squadron when that hop is received from the server. Will
       * ignore given hop if squadron to add the hop to can't be found.
       */
      public function addHopToSquadron(hop:MHop) : void {
         const squad: MSquadron = findSquad(hop.routeId);
         if (squad != null && !squad.hasLocationEqualTo(hop.location)) {
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
      public function addHopsToSquadrons(hops: Array): void {
         for each (var hop: MHop in hops) {
            addHopToSquadron(hop);
         }
      }

      /**
       * Attaches <code>jumpsAt</code> to hostile squadrons in the given list.
       * Used in <code>galaxies|show</code>, <code>solarSystems|show</code> and
       * <code>planets|show</code> actions only.
       */
      public function attachJumpsAtToHostileSquads(squads: IList, jumpsAtHash: Object): void {
         Objects.paramNotNull("squads", squads);
         Objects.paramNotNull("jumpsAtHash", jumpsAtHash);
         for each (var squad: MSquadron in squads.toArray()) {
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
      public function destroySquadron(id: int): Boolean {
         Objects.paramIsId("id", id);
         const logger: ILogger = loggerFactory.getLogger("destroySquadron");

         logger.debug("Will try to destroy squad {0}", id);
         const squad: MSquadron = SQUADS.remove(id, true);
         if (squad != null) {
            logger.debug("Destroying squadron {0}", squad);
            const fromPlanet: Boolean = squad.currentHop.location.isSSObject;
            const unitIds: Array = squad.units.toArray().map(
               function (unit: Unit, index: int, array: Array): int {
                  return unit.id;
               }
            );
            logger.debug("removing units {0}", unitIds);
            Collections.cleanListOfICleanables(squad.units);
            squad.cleanup();
            // If units navigate from planet we need to refresh some getters
            if (ML.latestPlanet != null && fromPlanet) {
               ML.latestPlanet.units.refresh();
               ML.latestPlanet.invalidateUnitCachesAndDispatchEvent();
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
               if (StartupInfo.relaxedServerMessagesHandlingMode) {
                  return;
               }
               throw new ArgumentError(
                  "Unable to update route and squadron: route with id " + routeId +
                  " could not be found. New route data was: " + ObjectUtil.toString(routeData));
            }
            route = squad.route;
         }
         // sometimes server sends objects|updated with route before client
         // runs another periodic update. So if ships are jumping, the jump will be delayed
         // and they will remain in the wrong map therefore screwing things up a little
         const jumpsAtString: String = routeData["jumpsAt"];
         const jumpsAt: Date = jumpsAtString != null ? DateUtil.parseServerDTF(jumpsAtString) : null;
         if (squad != null) {

            // Not using squad.jumpsAtEvent.hasOccurred here to allow slight errors.
            // The size of the error is worth to consider since client and server clocks are not
            // in perfect sync. I think a situation might occur - although *very rarely* - when
            // old jumpsAt and the new jumpsAt differ more than 200 ms but they actually define
            // the same jump. In such case ships will be removed a bit too early but players
            // might not even notice that as we have 500 ms errors anyway due to duration of effects
            const shouldHaveJumped: Boolean =
               squad.jumpPending &&
               (jumpsAt == null || DateUtil.subtractTime(squad.jumpsAtEvent.occursAt, jumpsAt) < -200);

            if (!squad.hasHopsRemaining && shouldHaveJumped) {
               loggerFactory.getLogger("updateRoute").debug(
                  "Received new jumpsAt {0} form server for squad {1} before the old " +
                  "jumpsAt {2} was cleared. Forcing the jump (removing squad) before update.",
                  jumpsAt, squad, squad.jumpsAtEvent);
               UnitJumps.setPreJumpLocations(squad.units, squad.currentHop.location);
               destroySquadron(squad.id);
               squad = null;
            }
         }
         SquadronFactory.attachJumpsAt(route, jumpsAtString);
         route.currentLocation = Objects.create(Location, routeData["current"]);
         route.cachedUnits.removeAll();
         route.cachedUnits.addAll(UnitFactory.createCachedUnits(routeData["cachedUnits"]));
         if (squad != null) {
            if (squad.currentHop.location.equals(route.currentLocation)) {
               squad.pending = false;
            }
         }
      }
      
      
      /**
       * Use to stop a squadron which is moving. Will ignore IDs of squadrons not present in
       * <code>ModelLocator.squadrons</code>.
       */
      public function stopSquadron(id:int, atLastHop:Boolean) : void {

         function refreshUnitsInUnitScreenModel() : void {
            if (ML.latestPlanet != null) {
               // TODO: Find out why some filters don't refresh if you don't
               // call refresh function on the list
               var US:MCUnitScreen = MCUnitScreen.getInstance();
               if (US.units != null) {
                  US.units.refresh();
                  US.refreshScreen();
               }
            }
         }

         const logger: ILogger = loggerFactory.getLogger("stopSquadron");
         
         if (id <= 0) {
            throwIllegalMovingSquadId(id);
         }
         ROUTES.remove(id, true);
         var squadToStop:MSquadron = SQUADS.remove(id, true);
         if (squadToStop == null) {
            logger.warn("unable to find squad with id {0} (atLastHop: {1})", id, atLastHop);
            return;
         }
         if (atLastHop) {
            logger.debug("stopping squad {0} at last hop", squadToStop);
            squadToStop.moveToLastHop();
            // This behaviour (destruction of squad) relies on the fact that the server
            // will send units|movement *before* objects|destroyed with a route. Because it does that
            // this squad is already in the map that it needs to be and jumpsAt is null when squad
            // needs to be stopped in that map. If it needs to be stopped just in another map in an
            // immediate sector after jump, squad has to be destroyed because that map is not cached.
            if (squadToStop.jumpPending) {
               logger.debug("squad {0} is waiting for a jump. Cleaning up:", squadToStop.id);
               const units:Array = squadToStop.units.toArray();
               if (units.length > 0) {
                  logger.debug("   removing units: {0}", units.join(", "));
               }
               else {
                  logger.error("   squad does not have any units!");
               }
               Collections.cleanListOfICleanables(squadToStop.units);
               // were those units removed from a map?
               const squadLoc:LocationMinimal = squadToStop.currentHop.location;
               const map:MMap = squadLoc.isGalaxy
                                   ? ML.latestGalaxy
                                   : squadLoc.isSSObject
                                        ? ML.latestPlanet
                                        : ML.latestSSMap;
               var unit: Unit = null;
               if (map != null) {
                  for each (unit in units) {
                     if (Collections.findFirstWithId(map.units,unit.id) != null) {
                        logger.error("   unit {0} has not been removed from map units list!", unit);
                     }
                  }
               }
               // were those units removed from the global list?
               for each (unit in units) {
                  if (ML.units.find(unit.id) != null) {
                     logger.error("   unit {0} has not been removed from global units list!", unit);
                  }
               }
               squadToStop.cleanup();
               refreshUnitsInUnitScreenModel();
               return;
            }
         }
         squadToStop.id = 0;
         squadToStop.route = null;
         var squadStationary:MSquadron = findSquad(
            0, squadToStop.playerId, squadToStop.currentHop.location);
         if (squadStationary != null) {
            squadStationary.units.refresh();
            squadToStop.cleanup();
         }
         else if (!squadToStop.currentHop.location.isSSObject) {
            // Don't use squadToStop again: asynchronously problems arise. See
            // components.map.space.SquadronsController#destroySquadron() for more explanation on this
            squadStationary = new MSquadron();
            squadStationary.owner = squadToStop.owner;
            squadStationary.player = squadToStop.player;
            squadStationary.currentHop = squadToStop.currentHop;
            
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
      public function recreateRoutes(routes: Array, playersHash: Object): void {
         ROUTES.removeAll();
         createRoutes(routes, playersHash);
         for each (var route: MRoute in ROUTES) {
            var squad: MSquadron = SQUADS.find(route.id);
            if (squad != null) {
               squad.route = route;
            }
         }
      }
      
      
      /**
       * Use to create all routes and add them to </code>ModelLocator</code> when they are received
       * from the server after player has logged in.
       */
      public function createRoutes(routes: Array, playersHash: Object): void {
         const players: Object = PlayerFactory.fromHash(playersHash);
         for each (var routeData: Object in routes) {
// TODO: use this code when server supports this
//            const playerId: int = routeData["playerId"];
//            const route: MRoute = createRoute(
//               routeData, playerId == ML.player.id ? Owner.PLAYER : Owner.ALLY);
//            route.player = players[playerId];

            const route: MRoute = createRoute(
               routeData, routeData["player"]["id"] == ML.player.id ? Owner.PLAYER : Owner.ALLY);
            route.player = players[route.player.id];
         }
      }
      
      
      /**
       * Use to create an instance of <code>MRoute</code> form generic object and add it to
       * <code>ModelLocator.routes</code> list.
       * 
       * @return route model which has been created.
       */
      public function createRoute(data: Object, owner: int = Owner.NPC): MRoute {
         var route: MRoute = ROUTES.find(data["id"]);
         if (route != null) {
            if (!Objects.containsSameData(route, data)) {
               Objects.throwStateOutOfSyncError(route, data);
            }
            else {
               // TODO: do we really need to check cached units?
               return route;
            }
         }
         route = Objects.create(MRoute, data);
         route.cachedUnits.addAll(UnitFactory.createCachedUnits(data["cachedUnits"]));
         if (owner != Owner.NPC) {
            route.owner = owner;
         }
         ROUTES.addItem(route);
         return route;
      }
      
      /**
       * Call this when any units have made a jump between maps (new batch of hops is received form 
       * the server) or when some units have jumped into player's visible area.
       */
      public function executeJump(units: IList, hops: IList, jumpsAt: String): void {
         Objects.paramNotNull("units", units);
         Objects.paramNotNull("hops", hops);
         const sampleUnit: Unit = Unit(units.getItemAt(0));
         // OK. We do this the simple way: if we got squad already, we wipe it out and we will recreate it.
         // Because update is too difficult and I always get it wrong.
         var squad: MSquadron = findSquad(sampleUnit.squadronId);
         if (squad != null) {
            destroySquadron(squad.id);
         }
         else {
            const existingUnit: Unit = UNITS.find(sampleUnit.id);
            if (existingUnit != null) {
               if (!existingUnit.isMoving && sampleUnit.isMoving) {
                  // If we ended up in this branch it means that:
                  // 1. some_map|show has been received prior units|movement
                  // 2. that map contains probably newer data than units|movement
                  // 3. we still destroy that stationary squad and create the moving variant
                  //    (the code inside the next if does just that)
                  // 4. soon objects|destroyed for the route involved will be received
                  //    which should then stop this moving squadron for good
                  const removedUnits: ArrayList = new ArrayList();
                  var removedUnit: Unit;
                  for each (var unit: Unit in units.toArray()) {
                     removedUnit = UNITS.remove(unit.id, true);
                     if (removedUnit != null) {
                        removedUnits.addItem(removedUnit);
                     }
                  }
                  destroyEmptySquadrons(removedUnits);
               }
            }
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
       * @param $unitIds array of ids on units to be moved
       */
      public function startMovement(route: Object, $unitIds: Array): void {
         const unitIds: ArrayCollection = new ArrayCollection($unitIds);
         const currentLocation: LocationMinimal =
                Objects.create(LocationMinimal, route["current"]);
         if (currentLocation.isSSObject) {
            currentLocation.setDefaultCoordinates();
         }

         // get the units we need to move
         const units: ListCollectionView = Collections.filter(
            UNITS,
            function (unit: Unit): Boolean {
               return unitIds.contains(unit.id);
            }
         );

         // we found units
         // that means we have a cached map in which those units are located:
         // create a squadron
         const ordersCtrl: OrdersController = OrdersController.getInstance();
         if (units.length != 0) {
            var unit: Unit = Unit(units.getItemAt(0));
            const oldUnitsSquad: MSquadron = findSquad(
               unit.squadronId, unit.playerId, currentLocation
            );
            route["status"] = unit.owner;
            const squad: MSquadron = SquadronFactory.fromObject(route);
            squad.player = unit.player;
            squad.addAllHops(Objects.fillCollection(
               new ArrayCollection(), MHop, route["hops"]
            ));
            units.disableAutoUpdate();
            for each (unit in units) {
               unit.squadronId = squad.id;
            }
            if (unit.location.isSSObject) {
               ML.latestPlanet.invalidateUnitCachesAndDispatchEvent();
            }
            units.enableAutoUpdate();
            if (squad.isFriendly) {
               squad.route = createRoute(route);
               squad.route.player = squad.player;
            }
            else {
               SquadronFactory.createHostileRoute(squad, route["jumpsAt"]);
            }
            if (oldUnitsSquad != null) {
               if (oldUnitsSquad.hasUnits) {
                  if (oldUnitsSquad.route != null) {
                     oldUnitsSquad.rebuildCachedUnits();
                  }
               }
               else {
                  SQUADS.removeExact(oldUnitsSquad);
                  oldUnitsSquad.cleanup();
               }
            }
            const duplicate: MSquadron = SQUADS.find(squad.id);
            if (duplicate != null) {
               if (!Objects.containsSameData(duplicate, route)) {
                  Objects.throwStateOutOfSyncError(duplicate, route);
               }
            }
            else {
               SQUADS.addItem(squad);
            }
            if (squad.owner == Owner.PLAYER && ordersCtrl.issuingOrders) {
               ordersCtrl.orderComplete();
               new MSuccessEvent(Localizer.string("Movement", "message.orderComplete"));
            }
         }
         // ALLY or PLAYER units are starting to move but we don't have that map open: create route then
         else if (route["target"] !== undefined) {
            const owner: int = route["player"]["id"] == ML.player.id ? Owner.PLAYER : Owner.ALLY;
            createRoute(route, owner);
            if (owner == Owner.PLAYER && ordersCtrl.issuingOrders) {
               ordersCtrl.orderComplete();
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
      public function createSquadronsForUnits(units:IList, map:MMap) : void {
         var squad: MSquadron;
         for each (var unit: Unit in units.toArray()) {
            if (unit.kind != UnitKind.SPACE
                  || !unit.isMoving && (!unit.location || unit.location.isSSObject)) {
               continue;
            }
            
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
      
      
      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */


      public function update(): void {
         MasterUpdateTrigger.updateList(ROUTES);
         const currentTime: Number = DateUtil.now;
         for each (var squad: MSquadron in SQUADS.toArray()) {
            if (squad.isMoving && !squad.pending) {
               const squadId: int = squad.id;
               if (squad.hasHopsRemaining) {
                  squad.moveToNextHop(currentTime + MOVE_EFFECT_DURATION);
                  const loc: LocationMinimal = squad.currentHop.location;
                  if (!loc.isObserved &&
                         (squad.isHostile || squad.isFriendly && !loc.isGalaxy)) {
                     destroySquadron(squadId);
                  }
               }
               else if (squad.jumpPending && squad.jumpsAtEvent.hasOccurred) {
                  UnitJumps.setPreJumpLocations(
                     squad.units, squad.currentHop.location
                  );
                  destroySquadron(squadId);
               }
            }
         }
      }

      public function resetChangeFlags(): void {
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function findSquad(
         id: int, playerId: int = 0, loc: LocationMinimal = null) : MSquadron
      {
         if (id != 0) {
            return SQUADS.find(id);
         }
         else {
            return SQUADS.findStationary(loc, playerId);
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