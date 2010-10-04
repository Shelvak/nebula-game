package models.map
{
   import flash.errors.IllegalOperationError;
   
   import models.BaseModel;
   import models.IModelsList;
   import models.ModelsCollection;
   import models.ModelsCollectionSlave;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.map.events.MapEvent;
   import models.movement.MSquadron;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   import utils.ClassUtil;
   
   
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
      
      
      [Bindable("willNotChange")]
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
      
      
      private var _squadrons:ModelsCollection = new ModelsCollection();
      private var _squadronsUnmodifiable:ModelsCollectionSlave = new ModelsCollectionSlave(_squadrons);
      /**
       * Unmodifiable collection of all squadrons in the map.
       */
      public function get squadrons() : IModelsList
      {
         return _squadronsUnmodifiable;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Adds all squadrons in the this to this map. <code>SQUADRON_ENTER</code> event won't be
       * dispatched.
       */
      public function addAllSquadrons(list:IList) : void
      {
         ClassUtil.checkIfParamNotNull("list", list);
         _squadrons.addAll(list);
      }
      
      
      /**
       * Adds a squadron to this map.
       * 
       * @param squadron a squadron to add
       * 
       * @throws ArgumentError if <code>squadron</code> is <code>null</code>
       */
      public function addSquadron(squadron:MSquadron) : void
      {
         ClassUtil.checkIfParamNotNull("squadron", squadron);
         _squadrons.addItem(squadron);
         dispatchSquadronEnterEvent(squadron);
      }
      
      
      /**
       * Removes a squadron from this map if that squadron is in the map.
       * 
       * @param squadron a squadron to remove
       * 
       * @return removed squadron
       * 
       * @throws ArgumentError if <code>squadron</code> is <code>null</code>
       */
      public function removeSquadron(squadron:MSquadron) : MSquadron
      {
         ClassUtil.checkIfParamNotNull("squadron", squadron);
         var removedSquadron:MSquadron = MSquadron(_squadrons.removeItem(squadron));
         dispatchSquadronLeaveEvent(removedSquadron);
         return removedSquadron;
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
       * Returns <code>true</code> if given location is defined on this map.
       */
      public function definesLocation(location:LocationMinimal) : Boolean
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
         var event:MapEvent = new MapEvent(type);
         event.object = object;
         event.operationCompleteHandler = operationCompleteHandler;
         dispatchEvent(event);
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