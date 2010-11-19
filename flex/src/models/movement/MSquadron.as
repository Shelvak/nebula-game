package models.movement
{
   import flash.errors.IllegalOperationError;
   
   import interfaces.ICleanable;
   
   import models.BaseModel;
   import models.ModelsCollection;
   import models.Owner;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.movement.events.MRouteEvent;
   import models.movement.events.MRouteEventChangeKind;
   import models.movement.events.MSquadronEvent;
   import models.unit.Unit;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   
   import namespaces.client_internal;
   
   import utils.ClassUtil;
   import utils.datastructures.Collections;
   
   
   /**
    * Dispatched when a hop has been added to or removed from the route.
    * 
    * @eventType models.movement.events.MRouteEvent.CHANGE
    */
   [Event(name="change", type="models.movement.events.MRouteEvent")]
   
   /**
    * Dispatched when the squadron moves to a new location.
    * 
    * @eventType models.movement.events.MSquadronEvent.MOVE
    */
   [Event(name="move", type="models.movement.events.MSquadronEvent")]
   
   
   public class MSquadron extends BaseModel implements ICleanable
   {
      public function MSquadron() : void
      {
         super();
         units = Collections.filter(ML.units,
            function(unit:Unit) : Boolean
            {
               if (isMoving)
               {
                  return id == unit.squadronId;
               }
               else if (currentHop)
               {
                  return unit.location.equals(currentHop.location);
               }
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
      public function cleanup() : void
      {
         if (units)
         {
            units.list = null;
            units.filterFunction = null;
            units = null;
         }
         if (_route)
         {
            _route = null;
         }
      }
      
      
      protected override function get collectionsFilterProperties() : Object
      {
         return {"units": ["id", "currentHop"]};
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      [Optional]
      [Bindable(event="modelIdChange")]
      /**
       * Setting id of a squadron will also set <code>route.id</code> and <code>squadronId</code> on all units
       * belonging to this squadron.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable(event="modelIdChange")]</i></p>
       */
      public override function set id(value:int):void
      {
         if (super.id != value)
         {
            units.disableAutoUpdate();
            for each (var unit:Unit in units.toArray())
            {
               unit.squadronId = value;
            }
            units.enableAutoUpdate();
            super.id = value;
         }
      }
      
      
      private var _route:MRoute;
      [Bindable]
      /**
       * Holds additional information about the squadron. This property should only be set if this squadron is moving
       * and is friendly. Changing <code>id</code>, <code>currentLocation</code> or <code>owner</code> properties
       * of this squadron will not update those properties on <code>route</code> and vise versa. Synchronisation between
       * those two <b>must be performed manually</b>. 
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]</i></p>
       */
      public function set route(value:MRoute) : void
      {
         if (_route != value)
         {
            _route = value;
         }
      }
      /**
       * @private
       */
      public function get route() : MRoute
      {
         return _route;
      }
      
      
      private var _owner:int = Owner.ENEMY;
      [Bindable]
      /**
       * Owner type of this squadron. Settings this property will also set <code>owner</code> property on all units
       * that belong to this squadron. If you try setting this to <code>Owner.UNDEFINED</code> property will be set
       * to <code>Owner.ENEMY</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]</i></p>
       */
      public function set owner(value:int) : void
      {
         if (_owner != value )
         {
            _owner = value != Owner.UNDEFINED ? value : Owner.ENEMY;
            units.disableAutoUpdate();
            for each (var unit:Unit in units)
            {
               unit.owner = _owner;
            }
            units.enableAutoUpdate();
         }
      }
      /**
       * @private
       */
      public function get owner() : int
      {
         return _owner;
      }
      
      
      public function get isFriendly() : Boolean
      {
         return owner == Owner.PLAYER || owner == Owner.ALLY;
      }
      
      
      public function get isHostile() : Boolean
      {
         return !isFriendly;
      }
      
      
      private var _currentLocation:Location = null;
      [Bindable]
      /**
       * Current location (according to the server) of a squadron. All units in this squad will have
       * their location set to the same value if you set this property.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]</i></p>
       * 
       * @default null
       */
      public function set currentLocation(value:Location) : void
      {
         if (_currentLocation != value)
         {
            _currentLocation = value;
            units.disableAutoUpdate();
            for each (var unit:Unit in units)
            {
               unit.location = value;
            }
            units.enableAutoUpdate();
         }
      }
      /**
       * @private
       */
      public function get currentLocation() : Location
      {
         return _currentLocation;
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
      public function get hasUnits() : Boolean
      {
         return units.length > 0;
      }
      
      
      /**
       * Hops that make up the route of this squadron. Do not modify this list directly: use
       * <code>addHop(), addAllHops(), moveToNextHop()</code> methods instead.
       */
      public var hops:ModelsCollection = new ModelsCollection();
      
      
      /**
       * Last hop of the route of the squadron.
       */
      public function get lastHop() : MHop
      {
         return MHop(hops.getLast());
      }
      
      
      /**
       * Next hop this squadron will move to.
       */
      public function get nextHop() : MHop
      {
         return MHop(hops.getFirst());
      }
      
      
      /**
       * Indicates if the squadron has any hops remaining in its route.
       */
      public function get hasHopsRemaining() : Boolean
      {
         return !hops.isEmpty;
      }
      
      
      [Bindable(event="idChange")]
      /**
       * Indicates if a squadron is moving.
       */
      public function get isMoving() : Boolean
      {
         return id > 0;
      }
      
      
      /* ######################## */
      /* ### ITERFACE METHODS ### */
      /* ######################## */
      
      
      /**
       * Creates <code>currentHop</code> from <code>currentLocation</code>.
       * <code>currentHop.index</code> is set to <code>0</code>. 
       */
      client_internal function createCurrentHop() : void
      {
         var hop:MHop = new MHop();
         hop.index = 0;
         hop.routeId = id;
         hop.location = currentLocation;
         currentHop = hop;
      }
      
      
      /**
       * Clears <code>cachedUnits</code> list in <code>route</code> and builds it from the
       * <code>units</code> list.
       * 
       * @throws IllegalOperationError if <code>route</code> has not been set
       */
      client_internal function rebuildCachedUnits() : void
      {
         checkRoute();
         var source:Array = new Array();
         for each (var unit:Unit in units)
         {
            var entry:UnitBuildingEntry = route.findEntryByType(unit.type);
            if (!entry)
            {
               entry = new UnitBuildingEntry(unit.type);
               source.push(entry);
            }
            entry.count++;
         }
         _route.cachedUnits = new ModelsCollection(source);
      }
      
      
      /**
       * Caches <code>currentLocation</code>, <code>owner</code> and <code>id</code> values from <code>route</code>
       * in private variables.
       * 
       * @throws IllegalOperationError if <code>route</code> has not been set
       */
      client_internal function captureRouteValues() : void
      {
         checkRoute();
         id = _route.id;
         owner = _route.owner;
         currentLocation = _route.currentLocation;
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
      public function addHop(hop:MHop) : void
      {
         ClassUtil.checkIfParamNotNull("hop", hop);
         if (hasLocationEqualTo(hop.location))
         {
            throwLocationAlreadyInRouteError(hop.location);
         }
         if (lastHop && hop.index - lastHop.index != 1)
         {
            throwHopOutOfOrderError(hop);
         }
         hops.addItem(hop);
         dispatchHopAddEvent(hop);
      }
      
      
      /**
       * Adds all hops to the route of this squadron. 
       * 
       * @param hops list of all hops to add
       */
      public function addAllHops(hops:IList) : void
      {
         for each (var hop:MHop in hops.toArray())
         {
            addHop(hop);
         }
      }
      
      
      /**
       * Moves squadron to the next hop: sets the <code>currentHop</code> property to the next hop in
       * the hops list, removes that hop from the list, dispatches <code>MRouteEvent.UPDATE</code>
       * event with <code>kind</code> set to <code>RouteEventUpdateKind.MOVE</code>.
       * 
       * @throws IllegalOperationError if there are no hops
       */
      public function moveToNextHop() : MHop
      {
         if (!hasHopsRemaining)
         {
            throwNoHopsRemainingError();
         }
         var fromHop:MHop = currentHop;
         currentHop = MHop(hops.removeItemAt(0));
         dispatchHopRemoveEvent(currentHop);
         dispatchMoveEvent(fromHop.location, currentHop.location);
         return currentHop;
      }
      
      
      public function removeAllHops() : void
      {
         hops.removeAll();
      }
      
      
      public override function equals(o:Object) : Boolean
      {
         if (!super.equals(o))
         {
            return false;
         }
         var squad:MSquadron = MSquadron(o);
         if (!squad.isMoving)
         {
            return squad.owner == owner && squad.currentHop.equals(currentHop);
         }
         return true;
      }
      
      
      /**
       * <code>MSquadron.hashKey()</code> returns string of the following format: </br>
       * <pre>{super.hashKey()},{owner}</pre>
       */
      public override function hashKey() : String
      {
         return super.hashKey() + "," + owner;
      }
      
      
      public override function toString() : String
      {
         return "[class: " + className + ", id: " + id + ", owner: " + owner + ", currentHop: " + currentHop + "]";
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
      private function hasLocationEqualTo(location:LocationMinimal) : Boolean
      {
         return !hops.filter(
            function(hopInRoute:MHop) : Boolean
            {
               return hopInRoute.location.equals(location);
            }
         ).isEmpty;
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchHopAddEvent(hop:MHop) : void
      {
         if (hasEventListener(MRouteEvent.CHANGE))
         {
            var event:MRouteEvent = new MRouteEvent(MRouteEvent.CHANGE);
            event.kind = MRouteEventChangeKind.HOP_ADD;
            event.hop = hop;
            dispatchEvent(event);
         }
      }
      
      
      private function dispatchHopRemoveEvent(hop:MHop) : void
      {
         if (hasEventListener(MRouteEvent.CHANGE))
         {
            var event:MRouteEvent = new MRouteEvent(MRouteEvent.CHANGE);
            event.kind = MRouteEventChangeKind.HOP_REMOVE;
            event.hop = hop;
            dispatchEvent(event);
         }
      }
      
      
      private function dispatchMoveEvent(from:LocationMinimal, to:LocationMinimal) : void
      {
         if (hasEventListener(MSquadronEvent.MOVE))
         {
            var event:MSquadronEvent = new MSquadronEvent(MSquadronEvent.MOVE);
            event.moveFrom = from;
            event.moveTo = to;
            dispatchEvent(event);
         }
      }
      
      
      /* ############################## */
      /* ### ERROR THROWING HELPERS ### */
      /* ############################## */
      
      
      private function throwMergeError(squad:MSquadron, reason:String) : void
      {
         throw new ArgumentError
            ("Can not merge squadron " + squad + " into this " + this + ": " + reason);
      }
      
      
      private function throwHopOutOfOrderError(hop:MHop) : void
      {
         throw new ArgumentError(
            "A hop you are trying to add to the route of this squadron is out of order: last hop - " +
            lastHop + ", new hop - " + hop + "."
         );
      }
      

      private function throwLocationAlreadyInRouteError(location:LocationMinimal) : void
      {
         throw new ArgumentError(
            "A hop defining the same point in space (" + location + ") is already in the route of " +
            "this squadron: a route can't have two hops defining the same point in space."
         );
      }
      

      private function throwNoHopsRemainingError() : void
      {
         throw new IllegalOperationError(
            "No hops in the route of squadron " + this + ": you can't call this method if " +
            "there are no hops in a route of a squadron."
         );
      }
      
      
      private function checkRoute() : void
      {
         if (!_route)
         {
            throw new IllegalOperationError("Unable to perform operation: [prop route] has not been set");
         }
      }
   }
}