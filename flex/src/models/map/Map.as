package models.map
{
   import flash.errors.IllegalOperationError;
   
   import models.BaseModel;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.map.events.MapEvent;
   import models.movement.MSquadron;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   import utils.datastructures.Collections;
   
   
   /**
    * Signals component to zoom a given object in.
    */
   [Event(name="uicmdZoomObject", type="models.map.events.MapEvent")]
   
   /**
    * Signals component to select a given object.
    */
   [Event(name="uicmdSelectObject", type="models.map.events.MapEvent")]
   
   /**
    * Dispatched when <code>objects</code> property is set to a new
    * collection.
    * 
    * @eventType models.map.events.MapEvent.OBJECTS_LIST_CHANGE
    */
   [Event(name="objectsListChange", type="models.map.events.MapEvent")]
   
   /**
    * Dispatched when a squadron enters (is added to) this map.
    * 
    * @eventType models.map.events.MapEvent.SQUADRON_ENTER
    */
   [Event(name="squadronEnter", type="models.map.events.MapEvent")]
   
   /**
    * Dispatched when a squadron leaves (is removed from) this map.
    * 
    * @eventType models.map.events.MapEvent.SQUADRON_LEAVE
    */
   [Event(name="squadronLeave", type="models.map.events.MapEvent")]
   
   
   public class Map extends BaseModel
   {
      public function Map()
      {
         super();
         _squadrons = Collections.filter(ML.squadrons,
            function(squad:MSquadron) : Boolean
            {
               return definesLocation(squad.currentHop.location);
            }
         );
         addSquadronsCollectionEventHandlers(_squadrons);
      }
      
      
      protected override function afterCreateModel(data:Object) : void
      {
         _squadrons.refresh();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
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
       * 
       * @return 
       */
      public function isOfType(type:int) : Boolean
      {
         return mapType == type;
      }
      
      
      private var _objects:ArrayCollection = new ArrayCollection();
      /**
       * List of all objects this map holds.
       * 
       * @default empty collection
       */
      public function get objects() : ArrayCollection
      {
         return _objects;
      }
      
      
      private var _squadrons:ListCollectionView;
      /**
       * Collection of squadrons in this map.
       */
      public function get squadrons() : ListCollectionView
      {
         return _squadrons;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
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
            throwUndefinedLocationError(x, y);
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
         dispatchUiCommand(MapEvent.UICMD_ZOOM_OBJECT, object, operationCompleteHandler);
      }
      
      
      public function selectObject(object:*, operationCompleteHandler:Function = null) : void
      {
         dispatchUiCommand(MapEvent.UICMD_SELECT_OBJECT, object, operationCompleteHandler);
      }
      
      
      protected function dispatchUiCommand(type:String, object:*, operationCompleteHandler:Function) : void
      {
         if (hasEventListener(type))
         {
            var event:MapEvent = new MapEvent(type);
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
         squadrons.addEventListener(CollectionEvent.COLLECTION_CHANGE, squadrons_collectionChangeHandler);
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
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      protected function dispatchObjectsListChangeEvent() : void
      {
         if (hasEventListener(MapEvent.OBJECTS_LIST_CHANGE))
         {
            dispatchEvent(new MapEvent(MapEvent.OBJECTS_LIST_CHANGE));
         }
      }
      
      
      private function dispatchSquadronEnterEvent(squadron:MSquadron) : void
      {
         if (hasEventListener(MapEvent.SQUADRON_ENTER))
         {
            var event:MapEvent = new MapEvent(MapEvent.SQUADRON_ENTER);
            event.squadron = squadron;
            dispatchEvent(event);
         }
      }
      
      
      private function dispatchSquadronLeaveEvent(squadron:MSquadron) : void
      {
         if (hasEventListener(MapEvent.SQUADRON_LEAVE))
         {
            var event:MapEvent = new MapEvent(MapEvent.SQUADRON_LEAVE);
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
      
      
      private function throwUndefinedLocationError(x:int, y:int) : void
      {
         throw new IllegalOperationError("Map " + this + " does not define location with " +
                                         "coordinates [x: " + x + ", y: " + y + "]");
      }
   }
}