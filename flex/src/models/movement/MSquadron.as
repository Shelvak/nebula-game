package models.movement
{
   import controllers.objects.ObjectClass;
   
   import flash.errors.IllegalOperationError;
   
   import interfaces.ICleanable;
   
   import models.BaseModel;
   import models.ModelsCollection;
   import models.Owner;
   import models.location.ILocationUser;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.movement.events.MRouteEvent;
   import models.movement.events.MRouteEventChangeKind;
   import models.movement.events.MSquadronEvent;
   import models.player.PlayerId;
   import models.player.PlayerMinimal;
   import models.time.MTimeEventFixedMoment;
   import models.unit.Unit;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   
   import namespaces.client_internal;
   
   import utils.ModelUtil;
   import utils.Objects;
   import utils.datastructures.Collections;
   
   
   /**
    * Dispatched when a hop has been added to or removed from the route. Event is not dispatched when a move
    * occures between two different maps.
    */
   [Event(name="change", type="models.movement.events.MRouteEvent")]
   
   /**
    * Dispatched when the squadron moves to a new location. Event is not dispatched when a move occures
    * between two different maps.
    */
   [Event(name="move", type="models.movement.events.MSquadronEvent")]
   
   /**
    * @see models.movement.events.MRouteEvent.JUMPS_AT_CHANGE
    */
   [Event(name="jumpsAtChange", type="models.movement.events.MRouteEvent")]
   
   
   /**
    * Squadrons that have <code>pending</code> set to <code>true</code> are not moved.
    */
   public class MSquadron extends BaseModel implements ICleanable, ILocationUser
   {
      public function MSquadron() : void
      {
         super();
         units = Collections.filter(ML.units,
            function(unit:Unit) : Boolean {
               if (isMoving)
                  return id == unit.squadronId;
               else if (!unit.isMoving && currentHop != null)
                  return unit.location.equals(currentHop.location) && unit.playerId == playerId;
               return false;
            }
         );
      }
      
      
      /**
       * <ul>
       *    <li>sets <code>units</code> to <code>null</code></li>
       *    <li>Sets <code>route</code> to <code>null</code></li>
       * </ul>
       * 
       * @see ICleanable#cleanup()
       */
      public function cleanup() : void {
         if (units != null) {
            units.list = null;
            units.filterFunction = null;
            units = null;
         }
         if (_route != null) {
            _route = null;
         }
      }
      
      protected override function get collectionsFilterProperties() : Object {
         return {"units": ["id", "currentHop", "playerId"]};
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      [Optional]
      [Bindable(event="modelIdChange")]
      /**
       * Setting id of a squadron will also set <code>squadronId</code> on all units
       * belonging to this squadron.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable(event="modelIdChange")]</i></p>
       */
      public override function set id(value:int) : void {
         if (super.id != value) {
            if (hasUnits) {
               units.disableAutoUpdate();
               for each (var unit:Unit in units.toArray()) {
                  unit.squadronId = value;
               }
               units.enableAutoUpdate();
               if(Unit(units.getItemAt(0)).location.isSSObject && ML.latestPlanet != null) {
                  ML.latestPlanet.dispatchUnitRefreshEvent();
               }
            }
            super.id = value;
         }
      }
      
      private var _playerId:int = PlayerId.NO_PLAYER;
      [Required]
      [Bindable]
      /**
       * Setting <code>playerId</code> of a squadron will also set <code>palyerId</code> on all units
       * in this squadron.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable]</i></p>
       */
      public function set playerId(value:int) : void {
         if (_playerId != value) {
            units.disableAutoUpdate();
            for each (var unit:Unit in units.toArray()) {
               unit.playerId = value;
            }
            units.enableAutoUpdate();
            _playerId = value;
         }
      }
      /**
       * @private
       */
      public function get playerId() : int {
         return _playerId;
      }
      
      private var _player:PlayerMinimal = null;
      [Optional]
      [Bindable]
      /**
       * Setting <code>player</code> of a squadron will also set <code>player</code> on all units
       * in this squadron.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable]</i></p>
       */
      public function set player(value:PlayerMinimal) : void {
         if (_player != value) {
            units.disableAutoUpdate();
            for each (var unit:Unit in units.toArray()) {
               unit.player = value;
            }
            units.enableAutoUpdate();
            _player = value;
         }
      }
      /**
       * @private
       */
      public function get player() : PlayerMinimal {
         return _player;
      }
      
      
      private var _route:MRoute;
      [Bindable]
      /**
       * Holds additional information about the squadron. This property should only be set if this squadron
       * is moving and is friendly. Changing <code>id</code>, <code>currentLocation</code>, <code>owner</code>,
       * <code>player</code> or <code>playerId</code> properties of this squadron will not update those
       * properties on <code>route</code> and vise versa. Synchronisation between those two <b>must be
       * performed manually</b>. 
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]</i></p>
       */
      public function set route(value:MRoute) : void {
         if (_route != value) {
            if (_route != null) {
               _route.addEventListener(MRouteEvent.JUMPS_AT_CHANGE, route_jumpsAtChangeHandler, false, 0, true);
            }
            _route = value;
            if (_route != null) {
               _route.removeEventListener(MRouteEvent.JUMPS_AT_CHANGE, route_jumpsAtChangeHandler, false);
            }
            route_jumpsAtChangeHandler(null);
         }
      }
      
      private function route_jumpsAtChangeHandler(event:MRouteEvent) : void {
         dispatchSimpleEvent(MRouteEvent, MRouteEvent.JUMPS_AT_CHANGE);
      }
      
      /**
       * @private
       */
      public function get route() : MRoute {
         return _route;
      }
      
      private var _owner:int = Owner.ENEMY;
      [Bindable]
      [Optional(alias="status")]
      /**
       * Owner type of this squadron. Settings this property will also set <code>owner</code> property on all units
       * that belong to this squadron.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional]</i></p>
       */
      public function set owner(value:int) : void {
         if (_owner != value ) {
            _owner = value;
            units.disableAutoUpdate();
            for each (var unit:Unit in units) {
               unit.owner = _owner;
            }
            units.enableAutoUpdate();
         }
      }
      /**
       * @private
       */
      public function get owner() : int {
         return _owner;
      }
      
      public function get isFriendly() : Boolean {
         return owner == Owner.PLAYER || owner == Owner.ALLY;
      }
      
      public function get isHostile() : Boolean {
         return !isFriendly;
      }
      
      [Bindable]
      /**
       * Current hop (minimized location variant) of the squadron. Must be set at all times. This is
       * where the client assumes this squadron is now (may be different from <code>currentLocation</code>).
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]</i></p>
       */
      public var currentHop:MHop = null;
      
      /**
       * @see models.movement.MRoute#jumpsAtEvent
       */
      public function set jumpsAtEvent(value:MTimeEventFixedMoment) : void {
         route.jumpsAtEvent = value;
      }
      public function get jumpsAtEvent() : MTimeEventFixedMoment {
         return route.jumpsAtEvent;
      }
      
      /**
       * @see models.movement.MRoute#jumpPending
       */
      public function get jumpPending() : Boolean {
         return route.jumpPending;
      }
      
      [Bindable(event="willNotChange")]
      /**
       * List of units in this squadron.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]</i></p>
       */
      public var units:ListCollectionView;
      
      /**
       * Indicates if there are any units in <code>units</code> list.
       */
      public function get hasUnits() : Boolean {
         return units != null && units.length > 0;
      }
      
      /**
       * Hops that make up the route of this squadron. Do not modify this list directly: use
       * <code>addHop(), addAllHops(), moveToNextHop()</code> methods instead.
       */
      public var hops:ModelsCollection = new ModelsCollection();
      
      /**
       * Last hop of the route of the squadron.
       */
      public function get lastHop() : MHop {
         return MHop(hops.getLast());
      }
      
      /**
       * Next hop this squadron will move to.
       */
      public function get nextHop() : MHop {
         return MHop(hops.getFirst());
      }
      
      /**
       * Indicates if the squadron has any hops remaining in its route.
       */
      public function get hasHopsRemaining() : Boolean {
         return !hops.isEmpty;
      }
      
      [Bindable(event="modelIdChange")]
      /**
       * Indicates if a squadron is moving.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="modelIdChange")]</i></p>
       */
      public function get isMoving() : Boolean {
         return id > 0;
      }
      
      
      /* ######################## */
      /* ### ITERFACE METHODS ### */
      /* ######################## */
      
      
      /**
       * Clears <code>cachedUnits</code> list in <code>route</code> and builds it from the
       * <code>units</code> list.
       * 
       * @throws IllegalOperationError if <code>route</code> has not been set
       */
      client_internal function rebuildCachedUnits() : void {
         var type:String;
         var entry:UnitBuildingEntry;
         var unit:Unit;
         checkRoute();
         _route.cachedUnits = new ModelsCollection();
         for each (unit in units) {
            type = ModelUtil.getModelType(ObjectClass.UNIT, unit.type);
            entry = _route.findEntryByType(type);
            if (!entry) {
               entry = new UnitBuildingEntry(type);
               _route.cachedUnits.addItem(entry);
            }
            entry.count++;
         }
         
      }
      
      /**
       * Caches <code>owner</code> and <code>id</code> values from <code>route</code>
       * in private variables. Creates current hop form <code>route.currentLocation</code>. 
       * 
       * @throws IllegalOperationError if <code>route</code> has not been set
       */
      client_internal function captureRouteValues() : void {
         checkRoute();
         id = _route.id;
         owner = _route.owner;
         createCurrentHop(_route.currentLocation);
      }
      
      /**
       * Creates and sets <code>currentHop</code> from given location. <code>currentHop.index</code>
       * is set to <code>0</code>. 
       */
      public function createCurrentHop(location:LocationMinimal) : void {
         var hop:MHop = new MHop();
         hop.index = 0;
         hop.routeId = id;
         hop.location = location;
         currentHop = hop;
      }
      
      /**
       * Adds new hop to the route of this squadron.
       * 
       * @param hop a hop to add to the route
       * 
       * @throws ArgumentError if:
       * <ul>
       *    <li><code>hop</code> is <code>null</code></li>
       *    <li>another location defining the same point in space equal to <code>location</code>
       *        already exists</li>
       * </ul>
       * Other rules are not checked.
       */
      public function addHop(hop:MHop) : void {
         Objects.paramNotNull("hop", hop);
         if (hasLocationEqualTo(hop.location))
            throwLocationAlreadyInRouteError(hop.location);
         if (lastHop && hop.index - lastHop.index != 1)
            throwHopOutOfOrderError(hop);
         hops.addItem(hop);
         dispatchHopAddEvent(hop);
      }
      
      /**
       * Adds all hops to the route of this squadron. <code>MRouteEvent.UPDATE</code> event is dispatched
       * for each added hop.
       * 
       * @param hops list of all hops to add
       */
      public function addAllHops(hops:IList) : void {
         for each (var hop:MHop in hops.toArray()) {
            addHop(hop);
         }
      }
      
      /**
       * Moves squadron to the next hop: sets the <code>currentHop</code> property to the next hop in
       * the hops list, removes that hop from the list, dispatches <code>MRouteEvent.UPDATE</code>
       * with <code>kind</code> set to <code>RouteEventUpdateKind.HOP_REMOVE</code> and
       * <code>MSquadronEvent.MOVE</code> events. Updates <code>location</code> property of all units in this
       * squadron.
       * 
       * <p>If you provide time parameter, squadron will jump to a hop closest to a given time but not a hop
       * in the future. <code>MRouteEvent.UPDATE</code> will be dispatched for each hop skipped plus the last
       * hop (only one <code>MSquadronEvent.MOVE</code> event will be dispatched) unless the squad would end
       * up in another map. <code>location</code> of units will be updated once the squad has jumped to the
       * last hop. If all the hops are in the future, the method will do nothing.</p>
       * 
       * @param time current time if you want squadron to jump to the closest past time to the given time
       * 
       * @param current hop of the squadron after the operation
       * 
       * @throws IllegalOperationError if there are no hops
       */
      public function moveToNextHop(time:Number) : MHop {
         if (!hasHopsRemaining)
            throw new IllegalOperationError(
               "No hops in the route of squadron " + this + ": you can't call this method if " +
               "there are no hops in a route of a squadron."
            );
         
         var startHop:MHop = currentHop;
         var endHop:MHop = null;
         var hop:MHop = null;
         
         // look for the last hop the squad has to jump to
         for each (hop in hops) {
            if (hop.arrivesAt.time <= time) {
               endHop = hop;
            }
            else {
               break;
            }
         }
         
         // no hops in the past
         if (endHop == null)
            return currentHop;
         
         hop = null;
         // jump between maps: don't need dispatching any events
         if (endHop.location.type != startHop.location.type ||
             endHop.location.id   != startHop.location.id) {
            while (hop != endHop) {
               hop = MHop(hops.removeItemAt(0));
            }
            currentHop = hop;
         }
         // jump in the same map
         else {
            while (hop != endHop) {
               hop = MHop(hops.removeItemAt(0));
               dispatchHopRemoveEvent(hop);
            }
            currentHop = hop;
            dispatchMoveEvent(startHop.location, endHop.location);
         }
         
         if (hasUnits) {
            var loc:Location = currentHop.location.toLocation();
            var fromPlanet: Boolean = Unit(units.getItemAt(0)).location.isSSObject;
            units.disableAutoUpdate();
            for each (var unit:Unit in units.toArray()) {
               unit.location = loc;
            }
            units.enableAutoUpdate();
            // If units navigate from or to planet we need to refresh some getters
            if ((loc.isSSObject || fromPlanet) && ML.latestPlanet != null) {
               ML.latestPlanet.dispatchUnitRefreshEvent();
            }
         }
         return currentHop;
      }
      
      /**
       * Moves this squadron to the last hop if it has hops remaining.
       */ 
      public function moveToLastHop() : void {
         if (hasHopsRemaining) {
            moveToNextHop(new Date(2200, 0, 1).time);
         }
      }
      
      public function removeAllHops() : void {
         hops.removeAll();
      }
      
      public function removeAllHopsButNext() : void {
         var nextHop:MHop = this.nextHop;
         hops.removeAll();
         if (nextHop != null)
            addHop(nextHop);
      }
      
      
      /* ##################### */
      /* ### ILocationUser ### */
      /* ##################### */
      
      public function updateLocationName(id:int, name:String) : void {
         if (currentHop != null)
            currentHop.updateLocationName(id, name);
         for each (var hop:MHop in hops) {
            hop.updateLocationName(id, name);
         }
      }
      
      
      /* ########################### */
      /* ### BaseModel OVERRIDES ### */
      /* ########################### */
      
      public override function equals(o:Object) : Boolean {
         if (!super.equals(o))
            return false;
         var squad:MSquadron = MSquadron(o);
         if (!squad.isMoving)
            return squad.owner == owner && squad.currentHop.equals(currentHop);
         return true;
      }
      
      /**
       * <code>MSquadron.hashKey()</code> returns string of the following format: </br>
       * <pre>{super.hashKey()},{owner}</pre>
       */
      public override function hashKey() : String {
         return super.hashKey() + "," + owner;
      }
      
      public override function toString() : String {
         return "[class: " + className + ", id: " + id + ", owner: " + owner + ", currentHop: " + currentHop +
            ", playerId: " + playerId + ", player: " + player + "]";
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      /**
       * Lets you check if a location in hops list already defines the point in space defined by
       * the given location.
       * 
       * @param location a location defining a point in space
       * 
       * @return <code>true</code> if a location defining the same point in space defined by the
       * given hop already exists in the route of the squadron or <code>false</code> otherwise
       */
      private function hasLocationEqualTo(location:LocationMinimal) : Boolean {
         return !hops.filter(
            function(hopInRoute:MHop) : Boolean {
               return hopInRoute.location.equals(location);
            }
         ).isEmpty;
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      private function dispatchHopAddEvent(hop:MHop) : void {
         if (hasEventListener(MRouteEvent.CHANGE)) {
            var event:MRouteEvent = new MRouteEvent(MRouteEvent.CHANGE);
            event.kind = MRouteEventChangeKind.HOP_ADD;
            event.hop = hop;
            dispatchEvent(event);
         }
      }
      
      private function dispatchHopRemoveEvent(hop:MHop) : void {
         if (hasEventListener(MRouteEvent.CHANGE)) {
            var event:MRouteEvent = new MRouteEvent(MRouteEvent.CHANGE);
            event.kind = MRouteEventChangeKind.HOP_REMOVE;
            event.hop = hop;
            dispatchEvent(event);
         }
      }
      
      private function dispatchMoveEvent(from:LocationMinimal, to:LocationMinimal) : void {
         if (hasEventListener(MSquadronEvent.MOVE)) {
            var event:MSquadronEvent = new MSquadronEvent(MSquadronEvent.MOVE);
            event.moveFrom = from;
            event.moveTo = to;
            dispatchEvent(event);
         }
      }
      
      
      /* ############################## */
      /* ### ERROR THROWING HELPERS ### */
      /* ############################## */

      private function throwHopOutOfOrderError(hop:MHop) : void {
         throw new ArgumentError(
            "A hop you are trying to add to the route of this squadron is out of order: hops - " +
            hops + ", new hop - " + hop + "."
         );
      }
      
      private function throwLocationAlreadyInRouteError(location:LocationMinimal) : void {
         throw new ArgumentError(
            "A hop defining the same point in space (" + location + ") is already in the route of " +
            "this squadron: a route can't have two hops defining the same point in space."
         );
      }
      
      private function checkRoute() : void {
         if (_route == null)
            throw new IllegalOperationError("Unable to perform operation: [prop route] has not been set");
      }
   }
}