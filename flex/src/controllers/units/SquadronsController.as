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
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.movement.MHop;
   import models.movement.MRoute;
   import models.movement.MSquadron;
   import models.movement.SquadronsList;
   import models.player.PlayerId;
   import models.unit.MCUnitScreen;
   import models.unit.Unit;
   import models.unit.UnitBuildingEntry;
   import models.unit.UnitKind;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.utils.ObjectUtil;
   
   import utils.SingletonFactory;
   import utils.StringUtil;
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
         if (squad != null)
            squad.addHop(hop);
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
            Collections.cleanListOfICleanables(squad.units);
            squad.cleanup();
         }
         if (removeRoute)
         {
            ROUTES.remove(id, true);
         }
      }
      
      
      /**
       * Use to update <code>currentLocation</code> and <code>cachedUnits</code> of a route.
       * 
       * @param routeData generic object that represents a route to update
       */
      public function updateRoute(routeData:Object) : void
      {
         if (routeData.id <= 0)
            throwIllegalMovingSquadId(routeData.id);
         
         // TODO: Figure out a correct way for updating the corresponding MSquadron
         var route:MRoute = findRoute(routeData.id);
         if (route == null)
            throw new ArgumentError(
               "Unable to update route and squadron: route with id " + routeData.id + " could not be found." +
               "New route data was: " + ObjectUtil.toString(routeData)
            );
         
         route.currentLocation = BaseModel.createModel(Location, routeData.current);
         route.cachedUnits.removeAll();
         route.cachedUnits.addAll(createCachedUnits(routeData.cachedUnits));
      }
      
      
      /**
       * Use to stop a squadron which is moving. Will ignore IDs of squadrons not present in
       * <code>ModelLocator.squadrons</code>.
       */
      public function stopSquadron(id:int, atLastHop:Boolean) : void
      {
         if (id <= 0)
            throwIllegalMovingSquadId(id);
         ROUTES.remove(id, true);
         var squadToStop:MSquadron = SQUADS.remove(id, true);
         if (squadToStop == null)
         {
            return;
         }
         if (atLastHop)
         {
            squadToStop.moveToLastHop();
         }
         squadToStop.id = 0;
         squadToStop.route = null;
         var squadStationary:MSquadron = findSquad(0, squadToStop.playerId, squadToStop.currentHop.location);
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
               playerId = squadToStop.playerId;
               currentHop = squadToStop.currentHop;
            }
            
            SQUADS.addItem(squadStationary);
            squadToStop.cleanup();
         }
         else
         {
            if (ML.latestPlanet != null)
            {
               // TODO: Find out why some filters don't refresh if you dont call 
               // refresh function on the list
               var US: MCUnitScreen = MCUnitScreen.getInstance();
               if (US.units != null)
               {
                  US.units.refresh();
                  US.refreshScreen();
               }
            }
         }
      }
      
      /**
       * Use when new routes are pushed by the server in the middle of the game. This method removes all
       * existing routes, creates new ones, adds them to routes list and attached those routes to squadorns.
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
               (routeData, routeData["playerId"] == ML.player.id ? Owner.PLAYER : Owner.ALLY);
            route.player = players[route.playerId];
         }
      }
      
      
      /**
       * Use to create an instance of <code>MRoute</code> form generic object and add it to
       * <code>ModelLocator.routes</code> list.
       * 
       * @return route model which has been created.
       */
      public function createRoute(data:Object, owner:int = Owner.UNDEFINED) : MRoute
      {
         var route:MRoute = BaseModel.createModel(MRoute, data);
         route.cachedUnits.addAll(createCachedUnits(data["cachedUnits"]));
         if (owner != Owner.UNDEFINED)
            route.owner = owner;
         ROUTES.addItem(route);
         return route;
      }
      
      
      /**
       * Creates a list of <code>UnitBuildingEntry</code> from the given cached units generic object. 
       */
      private function createCachedUnits(cachedUnits:Object) : ArrayCollection
      {
         var result:ArrayCollection = new ArrayCollection();
         for (var unitType:String in cachedUnits)
         {
            var entry:UnitBuildingEntry = new UnitBuildingEntry(
               "unit::" + StringUtil.firstToUpperCase(unitType),
               cachedUnits[unitType]
            );
            result.addItem(entry);
         }
         return result;
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
            Collections.cleanListOfICleanables(units);
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
         // or create new squadron
         else if (sampleUnit.location.isObserved)
         {
            UNITS.addAll(units);
            squad = SquadronFactory.fromUnit(sampleUnit);
            squad.addAllHops(hops);
            if (squad.isFriendly)
            {
               squad.route = findRoute(squad.id);
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
         if (units.length != 0)
         {
            var unit:Unit = Unit(units.getItemAt(0));
            var squadExisting:MSquadron = findSquad(unit.squadronId, unit.playerId, currentLocation);
            route["status"] = unit.owner; 
            squad = SquadronFactory.fromObject(route);
            squad.player = unit.player;
            squad.addAllHops(BaseModel.createCollection(ArrayCollection, MHop, route["hops"]));
            units.disableAutoUpdate();
            for each (unit in units)
            {
               unit.squadronId = squad.id;
            }
            if (unit.location.isSSObject)
            {
               ML.latestPlanet.dispatchUnitRefreshEvent();
            }
            units.enableAutoUpdate();
            if (squad.isFriendly)
            {
               squad.route = createRoute(route);
               squad.route.player = squad.player;
            }
            if (squadExisting && !squadExisting.hasUnits)
            {
               SQUADS.removeExact(squadExisting);
               squadExisting.cleanup();
            }
            SQUADS.addItem(squad);
            if (squad.owner == Owner.PLAYER && ORDERS_CTRL.issuingOrders)
            {
               ORDERS_CTRL.orderComplete();
               GF.lockApplication = false;
               Messenger.show(Localizer.string("Movement", "message.orderComplete"), Messenger.MEDIUM);
            }
         }
            // ALLY or PLAYER units are starting to move but we don't have that map open: create route then
         else if (route["target"] !== undefined) {
            var owner:int = route["playerId"] == ML.player.id ? Owner.PLAYER : Owner.ALLY;
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
      public function createSquadronsForUnits(units:IList) : void
      {
         var squad:MSquadron;
         for each (var unit:Unit in units.toArray()) {
            if (unit.kind != UnitKind.SPACE || !unit.isMoving && (!unit.location || unit.location.isSSObject))
               continue;
            
            squad = findSquad(unit.squadronId, unit.playerId, unit.location);
            
            // No squadron for the unit: create one
            if (!squad) {
               squad = SquadronFactory.fromUnit(unit);
               if (squad.isMoving && squad.isFriendly)
                  squad.route = ROUTES.find(squad.id);
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
               var squad:MSquadron = findSquad(unit.squadronId, unit.playerId, unit.location);
               if (squad != null)
               {
                  squad.units.refresh();
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
      }
      
      
      /* ################################## */
      /* ### SQUADS MOVEMENT AUTOMATION ### */
      /* ################################## */
      
      
      
      private function global_timedUpdateHandler(event:GlobalEvent) : void
      {
         var currentTime:Number = new Date().time;
         for each (var squad:MSquadron in SQUADS)
         {
            if (squad.isMoving && squad.hasHopsRemaining && !squad.pending)
            {
               squad.moveToNextHop(currentTime + MOVE_EFFECT_DURATION);
            }
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function findSquad(id:int,
                                 palyerId:int = PlayerId.NO_PLAYER,
                                 loc:LocationMinimal = null) : MSquadron
      {
         if (id != 0)
         {
            return SQUADS.find(id);
         }
         else
         {
            return SQUADS.findStationary(loc, palyerId);
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