package models.map
{
   import flash.errors.IllegalOperationError;

   import interfaces.ICleanable;

   import models.BaseModel;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.map.events.MMapEvent;
   import models.movement.MSquadron;
   import models.unit.Unit;

   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.logging.ILogger;
   import mx.logging.Log;

   import utils.Objects;
   import utils.datastructures.Collections;


   /**
    * Signals component to zoom a given object in.
    * 
    * @eventType models.map.events.MMapEvent.UICMD_ZOOM_OBJECT
    */
   [Event(name="uicmdZoomObject", type="models.map.events.MMapEvent")]

   /**
    * Signals component to deselect selected object if one is selected.
    *
    * @eventType models.map.events.MMapEvent.UICMD_DESELECT_SELECTED_OBJECT
    */
   [Event(name="uicmdDeselectSelectedObject", type="models.map.events.MMapEvent")]
   
   /**
    * Signals component to move the map to given location. <code>object</code> property holds
    * instance of <code>LocationMinimal</code>.
    * 
    * @eventType models.map.events.MMapEvent.UICMD_MOVE_TO
    */
   [Event(name="uicmdMoveTo", type="models.map.events.MMapEvent")]
   
   /**
    * Dispatched when a squadron enters (is added to) this map.
    * 
    * @eventType models.map.events.MMapEvent.SQUADRON_ENTER
    */
   [Event(name="squadronEnter", type="models.map.events.MMapEvent")]
   
   /**
    * Dispatched when a squadron leaves (is removed from) this map.
    * 
    * @eventType models.map.events.MMapEvent.SQUADRON_LEAVE
    */
   [Event(name="squadronLeave", type="models.map.events.MMapEvent")]
   
   /**
    * Dispatched when static objects has been added to the map.
    */
   [Event(name="objectAdd", type="models.map.events.MMapEvent")]
   
   /**
    * Dispatched when static objects has been added to the map.
    */
   [Event(name="objectRemove", type="models.map.events.MMapEvent")]
   
   public class MMap extends BaseModel implements ICleanable
   {
      private function get logger() : ILogger {
         return Log.getLogger("MAP");
      }
      
      public function MMap() {
         super();
         _squadrons = Collections.filter(ML.squadrons,
            function(squad:MSquadron) : Boolean {
               return definesLocation(squad.currentHop.location);
            }
         );
         _units = Collections.filter(ML.units,
            function(unit:Unit) : Boolean {
               return definesLocation(unit.location);
            }
         );
         addSquadronsCollectionEventHandlers(_squadrons);
         addObjectsCollectionEventHandlers(_objects);
      }
      
      /**
       * <ul>
       *    <li>calls <code>cleanup()</code> on all squadrons, removes them, sets <code>squadrons</code>
       *        to <code>null</code></li>
       *    <li>removes all units, sets <code>units</code> to <code>null</code></li>
       * </ul>
       * 
       * @see ICleanable#cleanup()
       */
      public function cleanup() : void {
         if (_squadrons != null) {
            var squadIds:Array = _squadrons.toArray().map(
               function(squad:MSquadron, index:int, array:Array) : int {
                  return squad.id
               }
            );
            logger.debug("Cleaning up squadrons {0} of map {1}", squadIds.join(", "), this);
            _squadrons.disableAutoUpdate();
            Collections.cleanListOfICleanables(_squadrons);
            _squadrons.enableAutoUpdate();
            _squadrons.list = null;
            _squadrons.filterFunction = null;
            _squadrons = null;
         }
         if (_units != null) {
            var unitIds:Array = _units.toArray().map(
               function(unit:Unit, index:int, array:Array) : int {
                  return unit.id
               }
            );
            logger.debug("Cleaning up units {0} of map {1}", unitIds.join(", "), this);
            ML.units.disableAutoUpdate();
            _units.disableAutoUpdate();
            Collections.cleanListOfICleanables(_units);
            _units.enableAutoUpdate();
            ML.units.enableAutoUpdate();
            _units.list = null;
            _units.filterFunction = null;
            _units = null;
         }
         if (_objects != null) {
            _objects.disableAutoUpdate();
            Collections.cleanListOfICleanables(_objects);
            _objects.enableAutoUpdate();
            _objects.list = null;
            _objects.filterFunction = null;
            _objects = null;
         }
      }
      
      protected override function get collectionsFilterProperties() : Object {
         return {
            "squadrons": ["id"],
            "units":     ["id"]
         };
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      /**
       * Returns <code>true</code> if this instance has a valid cached map
       * instance in <code>ModelLocator</code>. However this <b>does not</b>
       * necessary mean that <code>this</code> is actually a cached map itself
       * nor does it mean that a property that holds a cached map object is
       * empty.
       *  
       * <p>Getter in <code>MMap</code> throws
       * <code>IllegalOperationError</code> if not overriden.</p>
       */
      public function get cached() : Boolean {
         Objects.throwAbstractPropertyError();
         return false;  // unreachable
      }
      
      /**
       * Type of the map. Use values form <code>MapType</code>.
       * 
       * @default <code>MapType.GALAXY</code>
       */
      public function get mapType():int {
         return MapType.GALAXY;
      }
      
      /**
       * Type of locations this map defines inside itself.
       */
      protected function get definedLocationType() : int {
         Objects.throwAbstractPropertyError();
         return 0;   // unreachable
      }
      
      /**
       * Location of this map-like object in the parent map object. Returns <code>null</code> by default.
       */
      public function get currentLocation() : LocationMinimal {
         return null;
      }
      
      [Bindable(event="willNotChange")]
      /**
       * Lets you determine if this map is of a given type.
       * 
       * @param type Type of a map to test. Use values from <code>MapType</code>.
       */
      public function isOfType(type:int) : Boolean {
         return mapType == type;
      }
      
      private var _objects:ArrayCollection = new ArrayCollection();
      [Bindable(event="willNotChange")]
      /**
       * List of all static objects this map holds.
       * 
       * @default empty collection
       */
      public function get objects() : ArrayCollection {
         return _objects;
      }
      
      private var _squadrons:ListCollectionView;
      [Bindable(event="willNotChange")]
      /**
       * Collection of squadrons in this map.
       */
      public function get squadrons() : ListCollectionView {
         return _squadrons;
      }
      
      private var _units:ListCollectionView;
      [Bindable(event="willNotChange")]
      /**
       * Collection of units in this map.
       */
      public function get units() : ListCollectionView {
         return _units
      }
      
      public function get hasUnits() : Boolean {
         return _units.length > 0;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      /**
       * Adds given object to objects list.
       */
      public function addObject(object:BaseModel) : void {
         _objects.addItem(Objects.paramNotNull("object", object));
      }
      
      /**
       * Adds all objects in the given list to objects list.
       */
      public function addAllObjects(list:IList) : void {
         Objects.paramNotNull("list", list);
         objects.disableAutoUpdate();
         for each (var object:BaseModel in list) {
            addObject(object);
         }
         objects.enableAutoUpdate();
      }
      
      /**
       * Removes an object equal to the given one from objects list and returns it.
       * 
       * @throws IllegalOperationError if object to remove could not be found and <code>silent</code>
       * is <code>false</code>
       */
      public function removeObject(object:BaseModel, silent:Boolean = false) : * {
         var objectIdx:int = Collections.findFirstIndexEqualTo(_objects, object);
         if (objectIdx >= 0) {
            return _objects.removeItemAt(objectIdx);
         }
         else if (!silent) {
            throw new IllegalOperationError(
               "Can't remove object " + object + ": the equal object "
                  + "could not be found"
            );
         }
      }
      
      /**
       * Removes all given objects from objects list.
       */
      public function removeAllObjects(list:IList, silent:Boolean = false) : void {
         Objects.paramNotNull("list", list);
         for (var idx:int; idx < list.length; idx++) {
            removeObject(BaseModel(list.getItemAt(idx)), silent);
         }
      }
      
      /**
       * Creates and returns location in this map with given coordinates.
       */
      public function getLocation(x:int, y:int): Location {
         var loc:Location = new Location();
         loc.type = definedLocationType;
         loc.id = id;
         loc.x = x;
         loc.y = y;
         if (!definesLocation(loc)) {
            throw new IllegalOperationError(
               "Map " + this + " does not define location with coordinates "
                  + "[x: " + x + ", y: " + y + "]"
            );
         }
         setCustomLocationFields(loc);
         return loc;
      }
      
      /**
       * Called by <code>getLocation()</code>. You should set fields of given <code>Location</code>
       * relevant to concrete type of <code>Map</code>.
       */
      protected function setCustomLocationFields(location: Location) : void {
         Objects.throwAbstractMethodError();
      }
      
      /**
       * Returns <code>true</code> if given location is defined in this map only.
       * 
       * <p>Override <code>definesLocationImpl()</code> rather than this method: it will only be
       * called if <code>location</code> is not <code>null</code>.</p>
       */
      public function definesLocation(location: LocationMinimal) : Boolean {
         if (location == null) {
            return false;
         }
         return definesLocationImpl(location);
      }
      
      /**
       * @param location will never be <code>null</code>
       * 
       * @see #definesLocation()
       */
      protected function definesLocationImpl(location: LocationMinimal) : Boolean {
         Objects.throwAbstractMethodError();
         return false;   // unreachable
      }
      
      
      /* ################### */
      /* ### UI COMMANDS ### */
      /* ################### */

      public function zoomLocation(location: LocationMinimal,
                                   instant: Boolean = false,
                                   operationCompleteHandler: Function = null): void {
         dispatchUiCommand(
            MMapEvent.UICMD_ZOOM_LOCATION,
            location, instant, false, operationCompleteHandler
         );
      }

      public function selectLocation(location: LocationMinimal,
                                     openOnSecondCall:Boolean,
                                     instant: Boolean = false,
                                     operationCompleteHandler: Function = null): void {
         dispatchUiCommand(
            MMapEvent.UICMD_SELECT_LOCATION,
            location, instant, openOnSecondCall, operationCompleteHandler
         );
      }

      public function deselectSelectedLocation(instant: Boolean = false,
                                               operationCompleteHandler: Function = null): void {
         dispatchUiCommand(
            MMapEvent.UICMD_DESELECT_SELECTED_LOCATION,
            null, instant, false, operationCompleteHandler
         );
      }

      public function moveToLocation(location: LocationMinimal,
                                     instant: Boolean = false,
                                     operationCompleteHandler: Function = null): void {
         dispatchUiCommand(
            MMapEvent.UICMD_MOVE_TO_LOCATION,
            location, instant, false, operationCompleteHandler
         );
      }

      protected function dispatchUiCommand(type: String,
                                           location: LocationMinimal,
                                           instant: Boolean,
                                           openOnSecondCall: Boolean,
                                           operationCompleteHandler: Function): void {
         if (hasEventListener(type)) {
            var event: MMapEvent = new MMapEvent(type);
            event.object = location;
            event.instant = instant;
            event.openOnSecondCall = openOnSecondCall;
            event.operationCompleteHandler = operationCompleteHandler;
            dispatchEvent(event);
         }
      }
      
      
      /* ########################################### */
      /* ### SQUADRONS COLLECTION EVENT HANDLERS ### */
      /* ########################################### */

      private function addSquadronsCollectionEventHandlers(squadrons: ListCollectionView): void {
         squadrons.addEventListener(
            CollectionEvent.COLLECTION_CHANGE,
            squadrons_collectionChangeHandler,
            false, int.MIN_VALUE, true
         );
      }

      private function squadrons_collectionChangeHandler(event: CollectionEvent): void {
         if (event.kind != CollectionEventKind.ADD
                && event.kind != CollectionEventKind.REMOVE) {
            return;
         }
         for each (var squad: MSquadron in event.items) {
            switch (event.kind) {
               case CollectionEventKind.ADD:
                  dispatchSquadronEnterEvent(squad);
                  break;
               case CollectionEventKind.REMOVE:
                  dispatchSquadronLeaveEvent(squad);
                  break;
            }
         }
      }


      /* ######################################### */
      /* ### OBJECTS COLLECTION EVENT HANDLERS ### */
      /* ######################################### */


      private function addObjectsCollectionEventHandlers(objects:ListCollectionView) : void {
         objects.addEventListener(
            CollectionEvent.COLLECTION_CHANGE, objects_collectionChangeHandler,
            false, int.MIN_VALUE, true
         );
      }


      private function objects_collectionChangeHandler(event:CollectionEvent) : void {
         if (event.kind != CollectionEventKind.ADD &&
             event.kind != CollectionEventKind.REMOVE) {
            return;
         }
         for each (var object:* in event.items) {
            switch (event.kind) {
               case CollectionEventKind.ADD:
                  dispatchObjectAddEvent(object);
                  break;
               case CollectionEventKind.REMOVE:
                  dispatchObjectRemoveEvent(object);
                  break;
            }
         }
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      private function dispatchObjectAddEvent(object:*) : void {
         if (hasEventListener(MMapEvent.OBJECT_ADD)) {
            var event:MMapEvent = new MMapEvent(MMapEvent.OBJECT_ADD);
            event.object = object;
            dispatchEvent(event);
         }
      }
      
      private function dispatchObjectRemoveEvent(object:*) : void {
         if (hasEventListener(MMapEvent.OBJECT_REMOVE)) {
            var event:MMapEvent = new MMapEvent(MMapEvent.OBJECT_REMOVE);
            event.object = object;
            dispatchEvent(event);
         }
      }
      
      private function dispatchSquadronEnterEvent(squadron:MSquadron) : void {
         if (hasEventListener(MMapEvent.SQUADRON_ENTER)) {
            var event:MMapEvent = new MMapEvent(MMapEvent.SQUADRON_ENTER);
            event.squadron = squadron;
            dispatchEvent(event);
         }
      }
      
      private function dispatchSquadronLeaveEvent(squadron:MSquadron) : void {
         if (hasEventListener(MMapEvent.SQUADRON_LEAVE)) {
            var event:MMapEvent = new MMapEvent(MMapEvent.SQUADRON_LEAVE);
            event.squadron = squadron;
            dispatchEvent(event);
         }
      }
   }
}