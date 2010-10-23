package models.movement
{
   import ext.flex.mx.collections.IList;
   
   import flash.errors.IllegalOperationError;
   
   import models.BaseModel;
   import models.ModelsCollection;
   import models.Owner;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.movement.events.MRouteEvent;
   import models.movement.events.MRouteEventChangeKind;
   import models.movement.events.MSquadronEvent;
   import models.unit.Unit;
   import models.unit.UnitEntry;
   
   import namespaces.client_internal;
   
   import utils.ClassUtil;
   
   
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
   
   /**
    * Dispatched when "showRoute" property changes.
    * 
    * @eventType models.movement.events.MSquadronEvent.SHOW_ROUTE_CHANGE
    */
   [Event(name="showRouteChange", type="models.movement.events.MSquadronEvent")]
   
   
   public class MSquadron extends BaseModel
   {
      /**
       * Constructor.
       */
      public function MSquadron() : void
      {
         super();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      [Required]
      [Bindable]
      /**
       * Id of a player this squadron belongs to.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [Bindable]</i></p>
       * 
       * @default 0
       */
      public var playerId:int = 0;
      
      
      /**
       * Lets you identify owner (one of constants in <code>Owner</code> class) of this squadron.
       * 
       * @default Owner.UNDEFINED
       */
      public var owner:int = Owner.UNDEFINED;
      
      
      public function get isFriendly() : Boolean
      {
         return owner == Owner.PLAYER || owner == Owner.ALLY;
      }
      
      
      public function get isHostile() : Boolean
      {
         return !isFriendly;
      }
      
      
      [Required]
      [Bindable]
      /**
       * Time (local) when this squadron will reach its destination.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]</i></p>
       * 
       * @default null
       */
      public var arrivesAt:Date = null;
      
      
      [Required(alias="source")]
      [Bindable]
      /**
       * Location from which the squadron has been dispatched (where order has been issued).
       * If not known - <code>null</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required(alias="source")]<br/>
       * [Bindable]</i></p>
       * 
       * @default null
       */
      public var sourceLocation:Location = null;
      
      
      [Required(alias="target")]
      [Bindable]
      /**
       * Final destination of the squadron. If not known - <code>null</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required(alias="target")]<br/>
       * [Bindable]</i></p>
       * 
       * @default null
       */
      public var targetLocation:Location = null;
      
      
      [Required(alias="current")]
      [Bindable]
      /**
       * Current location of a squadron.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required(alias="current")]<br/>
       * [Bindable]</i></p>
       * 
       * @default null
       */
      public var currentLocation:Location = null;
      
      
      /**
       * Current hop (minimized location variant) of the squadron. Must be set at all times.
       */
      public var currentHop:MHop = null;
      
      
      [Bindable]
      /**
       * Collection of <code>SquadronEntry</code> instances.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]</i></p>
       * 
       * @default empty collection
       */
      public var cachedUnits:ModelsCollection = new ModelsCollection();
      
      
      [Bindable]
      /**
       * List of units in this squadron.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]</i></p>
       * 
       * @default empty collection
       */
      public var units:ModelsCollection = new ModelsCollection();
      
      
      /**
       * Indicates if there are any units in <code>units</code> list.
       */
      public function get hasUnits() : Boolean
      {
         return !units.isEmpty;
      }
      
      
      [ArrayElementType("models.movement.MHop")]
      [Optional]
      /**
       * Hops that make up the route of this squadron. Do not modify this list directly: use
       * <code>addHop(), addAllHops(), moveToNextHop()</code> methods instead.
       * 
       * p><i><b>Metadata</b>:<br/>
       * [Optional]</i></p>
       */
      public var hops:ModelsCollection = new ModelsCollection();
      
      
      /**
       * Last hop of the route of the squadron.
       */
      public function get lastHop() : MHop
      {
         return MHop(hops.getLastItem());
      }
      
      
      /**
       * Next hop this squadron will move to.
       */
      public function get nextHop() : MHop
      {
         return MHop(hops.getFirstItem());
      }
      
      
      /**
       * Indicates if the squadron has any hops remaining in its route.
       */
      public function get hasHopsRemaining() : Boolean
      {
         return !hops.isEmpty;
      }
      
      
      /**
       * Indicates if a squadron is moving.
       */
      public function get isMoving() : Boolean
      {
         return id > 0;
      }
      
      
      private var _showRoute:Boolean = false;
      /**
       * Indicates if route of the squadron should be shown or hidden.
       */
      public function set showRoute(value:Boolean) : void
      {
         if (_showRoute != value)
         {
            _showRoute = value;
            dispatchShowRouteChangeEvent();
         }
      }
      /**
       * @private
       */
      public function get showRoute() : Boolean
      {
         return _showRoute;
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
         currentHop = new MHop();
         currentHop.index = 0;
         currentHop.routeId = id;
         currentHop.location = currentLocation;
      }
      
      
      /**
       * Clears <code>cachedUnits</code> list and builds it from the <code>units</code> list.
       */
      client_internal function rebuildCachedUnits() : void
      {
         cachedUnits.removeAll();
         for each (var unit:Unit in units)
         {
            var entry:UnitEntry = findEntryByType(unit.type);
            if (!entry)
            {
               entry = new UnitEntry(unit.type);
               cachedUnits.addItem(entry);
            }
            entry.count++;
         }
      }
      
      
      /**
       * Looks for and returns <code>SquadronEntry</code> which has <code>type</code> equal to
       * <code>unitType</code>.
       * 
       * @param unitType type of a unit in a squadron
       * 
       * @return instance of <code>UnitEntry</code> or <code>null</code> if search has
       * failed
       * 
       * @throws ArgumentError if <code>unitType</code> is <code>null</code>
       */
      public function findEntryByType(unitType:String) : UnitEntry
      {
         ClassUtil.checkIfParamNotEquals("unitType", unitType, [null, ""]);
         for each (var entry:UnitEntry in cachedUnits)
         {
            if (entry.type == unitType)
            {
               return entry;
            }
         }
         return null;
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
         for each (var hop:MHop in hops)
         {
            addHop(hop);
         }
      }
      
      
      /**
       * Moves squadron to the next hop: sets the <code>current</code> property to the next hop in
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
         dispatchMoveEvent(fromHop ? fromHop.location : null, currentHop.location);
         return currentHop;
      }
      
      
      /**
       * Merges given squadron into this squadron: transfers units, cached units.
       * Can only merge if both squadrons are not moving, both belong to the same owner and both
       * are in the same location.
       */
      public function merge(squad:MSquadron) : void
      {
         if (this == squad)
         {
            throwMergeError(squad, "both squadrons can't be the same instance");
         }
         if (!currentHop.location.equals(squad.currentHop.location))
         {
            throwMergeError(squad, "squadrons must be in the same location")
         }
         if (isMoving || squad.isMoving)
         {
            throwMergeError(squad, "both squadrons should not be moving");
         }
         if (playerId != squad.playerId || owner != squad.owner)
         {
            throwMergeError(squad, "both squadrons must belong to the same owner");
         }
         units.addAll(squad.units);
         
         for each (var entry:UnitEntry in squad.cachedUnits)
         {
            var existingEntry:UnitEntry = findEntryByType(entry.type);
            if (existingEntry)
            {
               existingEntry.count += entry.count;
            }
            else
            {
               cachedUnits.addItem(entry);
            }
         }
      }
      
      
      /**
       * Separates units in the given squadron from this squadron. Will throw errors if there is
       * no unit in this squadron but it is in the given squadron.
       * 
       * @return <code>true</code> if at least one unit is left in this squadron after separation
       * or <code>false</code> otherwise
       */
      public function separateUnits(squad:MSquadron) : Boolean
      {
         for each (var unit:Unit in squad.units)
         {
            units.removeItem(units.findExactModel(unit));
         }
         for each (var unitEntry:UnitEntry in squad.cachedUnits)
         {
            var entry:UnitEntry = findEntryByType(unitEntry.type);
            entry.count--;
            if (entry.count == 0)
            {
               cachedUnits.removeItem(entry);
            }
         }
         return !units.isEmpty;
      }
      
      
      public override function equals(o:Object) : Boolean
      {
         if (!super.equals(o))
         {
            return false;
         }
         var squad:MSquadron = MSquadron(o);
         if (squad.isMoving)
         {
            return squad.playerId == squad.playerId && squad.currentHop.equals(currentHop);
         }
         return true;
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
         return !hops.filterItems(
            function(hopInRoute:MHop) : Boolean
            {
               return hopInRoute.location.equals(location);
            }
         ).isEmpty;
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchShowRouteChangeEvent() : void
      {
         if (hasEventListener(MSquadronEvent.SHOW_ROUTE_CHANGE))
         {
            dispatchEvent(new MSquadronEvent(MSquadronEvent.SHOW_ROUTE_CHANGE));
         }
      }
      
      
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
   }
}