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
   import mx.collections.ListCollectionView;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   import utils.datastructures.Collections;
   
   
   /**
    * Signals component to zoom a given object in.
    * 
    * @eventType models.map.events.MMapEvent.UICMD_ZOOM_OBJECT
    */
   [Event(name="uicmdZoomObject", type="models.map.events.MMapEvent")]
   
   
   /**
    * Signals component to select a given object.
    * 
    * @eventType models.map.events.MMapEvent.UICMD_SELECT_OBJECT
    */
   [Event(name="uicmdSelectObject", type="models.map.events.MMapEvent")]
   
   
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
    * 
    * @eventType models.map.events.MMapEvent.OBJECT_ADD
    */
   [Event(name="objectAdd", type="models.map.events.MMapEvent")]
   
   
   /**
    * Dispatched when static objects has been added to the map.
    * 
    * @eventType models.map.events.MMapEvent.OBJECT_REMOVE
    */
   [Event(name="objectRemove", type="models.map.events.MMapEvent")]
   
   
   public class MMap extends BaseModel implements ICleanable
   {
      public function MMap()
      {
         super();
         _squadrons = Collections.filter(ML.squadrons,
            function(squad:MSquadron) : Boolean
            {
               return definesLocation(squad.currentHop.location);
            }
         );
         _units = Collections.filter(ML.units,
            function(unit:Unit) : Boolean
            {
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
      public function cleanup() : void
      {
         if (_squadrons)
         {
            Collections.cleanListOfICleanables(_squadrons);
            _squadrons.list = null;
            _squadrons.filterFunction = null;
            _squadrons = null;
         }
         if (_units)
         {
            Collections.cleanListOfICleanables(_units);
            _units.list = null;
            _units.filterFunction = null;
            _units = null;
         }
         if (_objects)
         {
            Collections.cleanListOfICleanables(_objects);
            _objects.list = null;
            _objects.filterFunction = null;
            _objects = null;
         }
      }
      
      
      protected override function get collectionsFilterProperties() : Object
      {
         return {
            "squadrons": ["id"],
            "units":     ["id"]
         };
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      /**
       * Returns <code>true</code> if this instance has a valid cached map instance in
       * <code>ModelLocator</code>. However this <b>does not</b> necessary mean that <code>this</code>
       * is actually a cached map itsef nor does it mean that a property that holds a cached map object
       * is empty.
       *  
       * <p>Getter in <code>MMap</code> throws <code>IllegalOperationError</code> if not overriden.</p>
       */
      public function get cached() : Boolean
      {
         throw new IllegalOperationError("Getter is abstract!");
         return false;  // unreachable
      }
      
      
      /**
       * Type of the map. Use values form <code>MapType</code>.
       * 
       * @default <code>MapType.GALAXY</code>
       */
      public function get mapType():int
      {
         return MapType.GALAXY;
      }
      
      
      /**
       * Type of locations this map defines inside itself.
       */
      protected function get definedLocationType() : int
      {
         throwAbstractMethodError();
         return 0;   // unreachable
      }
      
      
      /**
       * Location of this map-like object in the parent map object. Returns <code>null</code> by default.
       */
      public function get currentLocation() : LocationMinimal
      {
         return null;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Lets you determine if this map is of a given type.
       * 
       * @param type Type of a map to test. Use values from <code>MapType</code>.
       */
      public function isOfType(type:int) : Boolean
      {
         return mapType == type;
      }
      
      
      private var _objects:ArrayCollection = new ArrayCollection();
      [Bindable(event="willNotChange")]
      /**
       * List of all static objects this map holds.
       * 
       * @default empty collection
       */
      public function get objects() : ArrayCollection
      {
         return _objects;
      }
      
      
      private var _squadrons:ListCollectionView;
      [Bindable(event="willNotChange")]
      /**
       * Collection of squadrons in this map.
       */
      public function get squadrons() : ListCollectionView
      {
         return _squadrons;
      }
      
      
      private var _units:ListCollectionView;
      [Bindable(event="willNotChange")]
      /**
       * Collection of units in this map.
       */
      public function get units() : ListCollectionView
      {
         return _units
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Adds given object to objects list.
       */
      public function addObject(object:BaseModel) : void
      {
         _objects.addItem(object);
      }
      
      
      /**
       * Removes an object equal to the given one from objects list and returns it.
       * 
       * @throws IllegalOperationError if object to remove could not be found and <code>silent</code>
       * is <code>false</code>
       */
      public function removeObject(object:BaseModel, silent:Boolean = false) : *
      {
         var objectIdx:int = Collections.findFirstIndexEqualTo(_objects, object);
         if (objectIdx >= 0)
         {
            return _objects.removeItemAt(objectIdx);
         }
         else if (!silent)
         {
            throw new IllegalOperationError("Can't remove object " + object + ": the equal object " +
                                            "could not be found");
         }
      }
      
      
      /**
       * Creates and returns location in this map with given coordinates.
       */
      public function getLocation(x:int, y:int) : Location
      {
         var loc:Location = new Location();
         loc.type = definedLocationType;
         loc.id = id;
         loc.x = x;
         loc.y = y;
         if (!definesLocation(loc))
         {
            throw new IllegalOperationError("Map " + this + " does not define location with " +
                                            "coordinates [x: " + x + ", y: " + y + "]");
         }
         setCustomLocationFields(loc);
         return loc;
      }
      
      
      /**
       * Called by <code>getLocation()</code>. You should set fields of given <code>Location</code>
       * relevant to concrete type of <code>Map</code>.
       */
      protected function setCustomLocationFields(location:Location) : void
      {
         throwAbstractMethodError();
      }
      
      
      /**
       * Returns <code>true</code> if given location is defined in this map only.
       * 
       * <p>Override <code>definesLocationImpl()</code> rather than this method: it will only be
       * called if <code>location</code> is not <code>null</code>.</p>
       */
      public function definesLocation(location:LocationMinimal) : Boolean
      {
         if (!location)
         {
            return false;
         }
         return definesLocationImpl(location);
      }
      
      
      /**
       * @param location will never be <code>null</code>
       * 
       * @see #definesLocation()
       */
      protected function definesLocationImpl(location:LocationMinimal) : Boolean
      {
         throwAbstractMethodError();
         return false;   // unreachable
      }
      
      
      /* ################### */
      /* ### UI COMMANDS ### */
      /* ################### */
      
      
      public function zoomObject(object:*, operationCompleteHandler:Function = null) : void
      {
         dispatchUiCommand(MMapEvent.UICMD_ZOOM_OBJECT, object, operationCompleteHandler);
      }
      
      
      public function selectObject(object:*, operationCompleteHandler:Function = null) : void
      {
         dispatchUiCommand(MMapEvent.UICMD_SELECT_OBJECT, object, operationCompleteHandler);
      }
      
      
      public function moveTo(location:LocationMinimal, operationCompleteHandler:Function = null) : void
      {
         dispatchUiCommand(MMapEvent.UICMD_MOVE_TO, location, operationCompleteHandler);
      }
      
      
      protected function dispatchUiCommand(type:String, object:*, operationCompleteHandler:Function) : void
      {
         if (hasEventListener(type))
         {
            var event:MMapEvent = new MMapEvent(type);
            event.object = object;
            event.operationCompleteHandler = operationCompleteHandler;
            dispatchEvent(event);
         }
      }
      
      
      /* ########################################### */
      /* ### SQUADRONS COLLECTION EVENT HANDLERS ### */
      /* ########################################### */
      
      
      private function addSquadronsCollectionEventHandlers(squadrons:ListCollectionView) : void
      {
         squadrons.addEventListener(CollectionEvent.COLLECTION_CHANGE, squadrons_collectionChangeHandler,
                                    false, 0, true);
      }
      
      
      private function squadrons_collectionChangeHandler(event:CollectionEvent) : void
      {
         if (event.kind != CollectionEventKind.ADD &&
             event.kind != CollectionEventKind.REMOVE)
         {
            return;
         }
         for each (var squad:MSquadron in event.items)
         {
            switch (event.kind)
            {
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
      
      
      private function addObjectsCollectionEventHandlers(objects:ListCollectionView) : void
      {
         objects.addEventListener(CollectionEvent.COLLECTION_CHANGE, objects_collectionChangeHandler,
                                  false, 0, true);
      }
      
      
      private function objects_collectionChangeHandler(event:CollectionEvent) : void
      {
         if (event.kind != CollectionEventKind.ADD &&
             event.kind != CollectionEventKind.REMOVE)
         {
            return;
         }
         for each (var object:* in event.items)
         {
            switch (event.kind)
            {
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
      
      
      private function dispatchObjectAddEvent(object:*) : void
      {
         if (hasEventListener(MMapEvent.OBJECT_ADD))
         {
            var event:MMapEvent = new MMapEvent(MMapEvent.OBJECT_ADD);
            event.object = object;
            dispatchEvent(event);
         }
      }
      
      
      private function dispatchObjectRemoveEvent(object:*) : void
      {
         if (hasEventListener(MMapEvent.OBJECT_REMOVE))
         {
            var event:MMapEvent = new MMapEvent(MMapEvent.OBJECT_REMOVE);
            event.object = object;
            dispatchEvent(event);
         }
      }
      
      
      private function dispatchSquadronEnterEvent(squadron:MSquadron) : void
      {
         if (hasEventListener(MMapEvent.SQUADRON_ENTER))
         {
            var event:MMapEvent = new MMapEvent(MMapEvent.SQUADRON_ENTER);
            event.squadron = squadron;
            dispatchEvent(event);
         }
      }
      
      
      private function dispatchSquadronLeaveEvent(squadron:MSquadron) : void
      {
         if (hasEventListener(MMapEvent.SQUADRON_LEAVE))
         {
            var event:MMapEvent = new MMapEvent(MMapEvent.SQUADRON_LEAVE);
            event.squadron = squadron;
            dispatchEvent(event);
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function throwAbstractMethodError() : void
      {
         throw new IllegalOperationError("This method is abstract");
      }
   }
}