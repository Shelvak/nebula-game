package components.map.planet
{
   import components.base.BaseContainer;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;
   import components.planetmapeditor.ObjectsEditorLayer;
   import components.planetmapeditor.TerrainEditorLayer;

   import flash.events.MouseEvent;
   import flash.geom.Point;

   import interfaces.ICleanable;

   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import models.planet.events.MPlanetEvent;

   import mx.collections.ArrayCollection;
   import mx.core.IVisualElement;


   /**
    * Responsible for laying out objects on top of the planet map, user
    * interaction with those objects and similar stuff.
    */
   public class PlanetObjectsLayer extends BaseContainer implements ICleanable
   {
      /* ###################################### */
      /* ### INITIALIZATION AND DESTRUCTION ### */
      /* ###################################### */

      public function PlanetObjectsLayer(map: PlanetMap,
                                         planet: MPlanet,
                                         objectsEditor: ObjectsEditorLayer = null,
                                         terrainEditor: TerrainEditorLayer = null) {
         super();
         _map = map;
         _planet = planet;
         _objectsEditor = objectsEditor;
         _terrainEditor = terrainEditor;
         addPlanetEventHandlers(planet);
         doubleClickEnabled = true;
         addSelfEventHandlers();
      }

      private var _objectsEditor: ObjectsEditorLayer = null;
      private var _terrainEditor: TerrainEditorLayer = null;
      private var _map: PlanetMap = null;
      private var _planet: MPlanet = null;

      protected override function createChildren(): void {
         super.createChildren();
         createVLs();
      }

      private var f_cleanupCalled: Boolean = false;
      public function cleanup(): void {
         if (f_cleanupCalled) {
            return;
         }

         destroyVLs();
         deselectSelectedObject();
         takeOverMouseEvents();
         removeSelfEventHandlers();

         if (_planet != null) {
            removePlanetEventHandlers(_planet);
            _planet = null;
         }

         if (_map != null) {
            _map = null;
         }
      }
      
      public function reset(): void {
         resetAllInteractiveObjectsState();
         deselectSelectedObject();
         takeOverMouseEvents();
         forEachVL(
            function(layer: PlanetVirtualLayer): void {
               layer.reset();
            }
         );
      }
      
      
      /* ############ */
      /* ### SIZE ### */
      /* ############ */

      protected override function measure(): void {
         if (_map != null) {
            var size: Point = _map.getSize();
            measuredWidth = size.x;
            measuredHeight = size.y;
         }
      }
      
      
      /* ###################### */
      /* ### VIRTUAL LAYERS ### */
      /* ###################### */
      
      private var _virtualLayers:Vector.<PlanetVirtualLayer> =
                     new Vector.<PlanetVirtualLayer>();
      /**
       * Invokes given <code>callback</code> function on each virtual layer.
       * <p>Signature of the callback function:
       * <code>function(layer:PlanetVirtualLayer) : void</code>.</p>
       */
      private function forEachVL(callback: Function): void {
         for each (var layer: PlanetVirtualLayer in _virtualLayers) {
            callback.call(this, layer);
         }
      }

      private function createVLs(): void {
         if (_objectsEditor != null) {
            _virtualLayers.push(
               _objectsEditor,
               _terrainEditor
            );
            _objectsEditor = null;
            _terrainEditor = null;
         }
         else {
            _virtualLayers.push(
               new BuildingsLayer(),
               new BlockingFolliagesLayer(),
               new NonblockingFolliagesLayer()
            );
         }
         initializeVLs();
      }

      private function destroyVLs(): void {
         forEachVL(
            function(layer: PlanetVirtualLayer): void {
               layer.cleanup();
            }
         );
         _virtualLayers.splice(0, _virtualLayers.length);
      }

      private function initializeVLs(): void {
         forEachVL(
            function(layer: PlanetVirtualLayer): void {
               layer.initialize(this, _map, _planet);
            }
         );
      }

      private function notifyVLsOfObjSelection(object: IInteractivePlanetMapObject): void {
         forEachVL(
            function(layer: PlanetVirtualLayer): void {
               layer.objectSelected(object);
            }
         );
      }

      private function notifyVLsOfObjDeselection(object: IInteractivePlanetMapObject): void {
         forEachVL(
            function(layer: PlanetVirtualLayer): void {
               layer.objectDeselected(object);
            }
         );
      }

      private function notifyVLsOfObjAdd(object: MPlanetObject): void {
         forEachVL(
            function(layer: PlanetVirtualLayer): void {
               layer.addObject(object);
            }
         );
      }

      private function notifyVLsOfObjRemove(object: IPrimitivePlanetMapObject): void {
         forEachVL(
            function(layer: PlanetVirtualLayer): void {
               layer.objectRemoved(object);
            }
         );
      }

      private function notifyVLsOfObjDoubleClick(object: IPrimitivePlanetMapObject): void {
         forEachVL(
            function(layer: PlanetVirtualLayer): void {
               layer.openObject(object);
            }
         );
      }
      
      
      /* ########################### */
      /* ### MOUSE EVENTS FILTER ### */
      /* ########################### */
      
      
      /**
       * One of virtual layers that is responsible for handling majority of
       * mouse events. If this is <code>null</code>,
       * <code>PlanetObjectsLayer</code> itself is responsible for handling
       * all mouse events.
       */
      private var mouseEventsOwner: PlanetVirtualLayer = null;

      /**
       * <code>true</code> if this instance of <code>PlanetObjectsLayer</code>
       * is directly responsible for handling mouse events or <code>false</code>
       * if most of the events should be passed over to one of virtual layers
       * (<code>mouseEventsOwner</code>).
       */
      private function get ownsMouseEvents(): Boolean {
         return mouseEventsOwner == null;
      }

      /**
       * Called by one of virtual layers to take over mouse events handling.
       */
      public function passOverMouseEventsTo(layer: PlanetVirtualLayer): void {
         mouseEventsOwner = layer;
      }

      /**
       * Called by one of virtual layers to return mouse events handling to
       * <code>PlanetObjectsLayer</code>. This method should be called
       * by the same <code>PlanetVirtualLayer</code> that has called
       * <code>passOverMouseEventsTo(layer:PlanetVirtualLayer) : void</code>
       * method.
       */
      public function takeOverMouseEvents(): void {
         mouseEventsOwner = null;
      }

      /**
       * An object that is currently under the mouse pointer or was under it
       * just a moment ago.
       */
      private var objectUnderMouse: IInteractivePlanetMapObject = null;
      
      /**
       * This component has a sophisticated mouse events handling logic:
       * <ul>
       *    <li>MOUSE_OVER, MOUSE_OUT, CLICK, DOUBLE_CLICK, MOUSE_DOWN, MOUSE_UP
       *        events are canceled and redispatched from the
       *        <code>map.background</code> object.</li>
       *    <li>MOUSE_OVER, MOUSE_OUT events are dispatched also from
       *        <code>map.background</code> when mouse rolls out, rolls over,
       *        moves out and moves over the object respectively.</li>
       *    <li>If CLICK, DOUBLE_CLICK, MOUSE_OVER, MOUSE_OUT, MOUSE_DOWN,
       *        MOUSE_UP occurs while mouse is over the basement of an object,
       *        appropriate handler of that object component is called and event
       *        is canceled.</li>
       * </ul>
       */
      private function this_mouseEventFilter(event: MouseEvent): void {
         // If event originated from the map background we must pass it
         // to upper layers in order map dragging could work properly.
         // If it has originated form InteractivePlanetMapObject
         // that means this event has been redispatched from that object by
         // this component and should be passed to upper layers.
         if (event.target == _map
                || event.target is IInteractivePlanetMapObject) {
            return;
         }

         event.stopImmediatePropagation();

         if (event.type == MouseEvent.MOUSE_OVER
                || event.type == MouseEvent.MOUSE_OUT) {
            redispatchEventFromMap(event);
         }

         // If one of the layers have taken over mouse events it will do the rest
         if (!ownsMouseEvents) {
            mouseEventsOwner.handleMouseEvent(event);
            return;
         }

         var tileCoords: Point = _map.coordsTransform.realToLogicalTileCoords(mouseX, mouseY);
         var object: IInteractivePlanetMapObject =
                tileCoords != null
                   ? getInteractiveObjectOnTile(tileCoords.x, tileCoords.y)
                   : null;

         // There is an interactive object under the mouse
         if (object) {
            // Do not respond to user interaction if that object is busy right now
            if (object.model.pending) {
               return;
            }
            switch (event.type) {
               case MouseEvent.MOUSE_MOVE:
                  if (!objectUnderMouse) {
                     dispatchMapEvent(MouseEvent.MOUSE_OUT, event);
                     object_mouseOverHandler(object, event);
                  }
                  else if (objectUnderMouse != object) {
                     object_mouseOutHandler(objectUnderMouse, event);
                     object_mouseOverHandler(object, event);
                  }
                  break;

               case MouseEvent.CLICK:
                  object_clickHandler(object, event);
                  break;

               case MouseEvent.DOUBLE_CLICK:
                  object_doubleClickHandler(object, event);
                  break;
            }
            objectUnderMouse = object;
         }

         // No object under mouse pointer
         else {
            if (objectUnderMouse) {
               object_mouseOutHandler(objectUnderMouse, event);
               objectUnderMouse = null;
               dispatchMapEvent(MouseEvent.MOUSE_OVER, event);
            }

            switch (event.type) {
               case MouseEvent.CLICK:
                  deselectSelectedObject();
                  redispatchEventFromMap(event);
                  break;

               default:
                  redispatchEventFromMap(event);
            }
         }
      }

      /**
       * Dispatches given mouse event form the <code>map</code> component but
       * of the the given <code>type</code> (copy of the given event is created
       * actually).
       */
      public function dispatchMapEvent(type: String, source: MouseEvent): void {
         _map.dispatchEvent(getMouseEvent(type, source));
      }

      /**
       * Cancels propagation of a given event and dispatches if form the
       * <code>map.background</code> component.
       */
      public function redispatchEventFromMap(event: MouseEvent): void {
         _map.dispatchEvent(event);
      }

      /**
       * Creates a copy of a given <code>MouseEvent</code> object
       * (<code>source</code>) but the returned event object will have
       * <code>type</code> property set to a given string (<code>type</code>).
       */
      private function getMouseEvent(type: String,
                                     source: MouseEvent): MouseEvent {
         return new MouseEvent(
            type,
            source.bubbles, source.cancelable,
            source.localX, source.localY,
            source.relatedObject,
            source.ctrlKey, source.altKey, source.shiftKey,
            source.buttonDown,
            source.delta
         );
      }
      
      
      /* #################################### */
      /* ### OBJECTS MOUSE EVENT HANDLERS ### */
      /* #################################### */
      
      /*
      * The reason I have decided to realize these handlers in this class rather than
      * in PlanetMapObject class itself is that there is too much going on with (considering 
      * mouse interaction) related with all objects on the map and very little with
      * the object that is targeted by the mouse.
      * In all of these handlers the case were parameter object is null should be considered.
       */

      private function object_mouseOverHandler(object: IInteractivePlanetMapObject,
                                               event: MouseEvent): void {
         if (!object) {
            return;
         }
         object.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
      }

      private function object_mouseOutHandler(object: IInteractivePlanetMapObject,
                                              event: MouseEvent): void {
         if (!object) {
            return;
         }
         object.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
         resetAllInteractiveObjectsState();
      }

      private function object_clickHandler(object: IInteractivePlanetMapObject,
                                           event: MouseEvent): void {
         if (!object) {
            return;
         }
         selectObject(object);
      }

      private function object_doubleClickHandler(object: IInteractivePlanetMapObject,
                                                 event: MouseEvent): void {
         if (!object) {
            return;
         }
         notifyVLsOfObjDoubleClick(object);
      }


      /* ######################################### */
      /* ### OBJECTS SELECTION AND DESELECTION ### */
      /* ######################################### */

      private var _selectedObject: IInteractivePlanetMapObject = null;

      /**
       * Selects given object. If there is another object selected,
       * deselects it.
       */
      internal function selectObject(object: IInteractivePlanetMapObject): void {
         if (_selectedObject == object) {
            return;
         }
         deselectSelectedObject();
         _selectedObject = object;
         _selectedObject.select();
         notifyVLsOfObjSelection(object);
      }

      /**
       * Deselects selected object if there is one.
       */
      internal function deselectSelectedObject(): void {
         if (_selectedObject) {
            _selectedObject.deselect();
            notifyVLsOfObjDeselection(_selectedObject);
            _selectedObject = null;
         }
      }


      /* ######################################## */
      /* ### OBJECTS CREATION AND DESTRUCTION ### */
      /* ######################################## */

      /**
       * Lets you add a new object to this layer. Typically this is called
       * by one of virtual layers.
       */
      public function addObject(object: IPrimitivePlanetMapObject,
                                addEventHandlers: Boolean = true): void {
         addElement(object);
         positionObject(object);
      }

      /**
       * This is called when an object from a planet has been removed.
       *
       * @param model instance of <code>MPlanetObject</code> that has been
       * removed from the planet.
       * @param vlNotification if <code>true</code>, virtual layers will be
       * notified about this event, however, they will be passed component
       * instead of the model.
       */
      public function removeObject(model: MPlanetObject,
                                   vlNotification: Boolean = true): void {
         var object: IPrimitivePlanetMapObject = getObjectByModel(model);
         if (object == null) {
            throw new Error(
               "Could not find component that represents given MPlanetObject!"
            );
         }
         if (_selectedObject != null && _selectedObject.model.equals(model)) {
            deselectSelectedObject();
         }
         removeElement(object);
         object.cleanup();
         if (vlNotification) {
            notifyVLsOfObjRemove(object);
         }
      }


      /* ################################ */
      /* ### OBJECTS LOOKUP FUNCTIONS ### */
      /* ################################ */

      /**
       * Lets you filter out objects from the display list you don't need.
       *
       * @param filterFunction Function that should return <code>true</code> for an
       * object that should be included in the resulting collection. Signature of this
       * function is as follows: <code>function(object:IVisualElement) : Boolean</code>.
       *
       * @return Collection of display list objects for which the function returned <code>true</code>.
       * Changes to this list won't have effect on display list.
       */
      private function filterDisplayList(filterFunction: Function): ArrayCollection {
         var list: ArrayCollection = new ArrayCollection();
         for (var i: int = 0; i < numElements; i++) {
            if (filterFunction.call(this, getElementAt(i) as IVisualElement)) {
               list.addItem(getElementAt(i));
            }
         }
         return list;
      }

      /**
       * Collection of all <code>IPrimitivePlanetMapObject</code> (that includes all
       * <code>IInteractivePlanetMapObject</code> also) instances in the display list.
       * Changes to this list won't have effect on display list.
       */
      private function get primitiveAndInteractiveObjects(): ArrayCollection {
         return filterDisplayList(
            function(object: IVisualElement): Boolean {
               return object is IPrimitivePlanetMapObject;
            }
         );
      }

      /**
       * Collection of all <code>IInteractivePlanetMapObject</code> instance in the display list.
       * Changes to this list won't have effect on display list.
       */
      private function get interactiveObjects(): ArrayCollection {
         return filterDisplayList(
            function(object: IVisualElement): Boolean {
               return object is IInteractivePlanetMapObject;
            }
         );
      }

      /**
       * Looks for a component that represents the given model instance.
       *
       * @param model a model for which you need to find it's component.
       *
       * @return instance of <code>PlanetMapObject<code> that represents the
       * given model or <code>null</code> if one can't be found.
       */
      public function getObjectByModel(model: MPlanetObject): IPrimitivePlanetMapObject {
         for each (var object: IPrimitivePlanetMapObject in primitiveAndInteractiveObjects) {
            if (object.model == model) {
               return object;
            }
         }
         return null;
      }

      /**
       * Loops through all objects and finds the one that is on the tile
       * with given logical coordinates. Returns null if no object is on the
       * tile.
       */
      public function getObjectOnTile(logicalX: int,
                                      logicalY: int): IPrimitivePlanetMapObject {
         for each (var object: IPrimitivePlanetMapObject in primitiveAndInteractiveObjects) {
            if (object.model.standsOn(logicalX, logicalY)) {
               return object;
            }
         }
         return null;
      }

      /**
       * Does the same as <code>getObjectOnTile()</code> but returns
       * instance of <code>InteractivePlanetMapObject</code> if there is
       * one on the given tile.
       */
      public function getInteractiveObjectOnTile(logicalX: int,
                                                 logicalY: int): IInteractivePlanetMapObject {
         var object: IPrimitivePlanetMapObject =
                getObjectOnTile(logicalX, logicalY);
         if (object && object is IInteractivePlanetMapObject) {
            return object as IInteractivePlanetMapObject;
         }
         else {
            return null;
         }
      }

      /**
       * Returns a list of interactive obejcts that migh overlap the given
       * object. If no such objects could be found, empty array is returned.
       *
       * @return list of <code>InteractivePlanetMapObjects<code> that overlap
       * the given object.
       */
      public function getOverlappingObjects(object: IPrimitivePlanetMapObject): Array {
         var result: Array = new Array();

         /**
          * Overlapping objects might be on the tiles that are of distStart to
          * distEnd tiles distance (distEnd - distStart + 1 tiles gap between
          * buildings) from the given object to logical west, south and
          * south-west.
          */
         var distStart: int = 2;
         var distEnd: int = 2;

         var model: MPlanetObject = object.model;

         var xMinStart: int = model.x - distStart;
         var xMinEnd: int = model.x - distEnd;
         var xMax: int = model.xEnd;

         var yMinStart: int = model.y - distStart;
         var yMinEnd: int = model.y - distEnd;
         var yMax: int = model.yEnd;

         for each (var comp: IInteractivePlanetMapObject in interactiveObjects) {
            if (// Logical horizontal area of tiles that might have overlapping objects
                comp.model.fallsIntoArea(xMinEnd, xMax, yMinEnd, yMinStart) ||
                // Logical vertical area of tiles that might have overlapping objects
                comp.model.fallsIntoArea(xMinEnd, xMinStart, yMinEnd, yMax))
            {
               result.push(comp);
            }
         }

         return result;
      }

      /**
       * Resets all building components to their default state. This
       * does not change selection of those objects.
       */
      public function resetAllInteractiveObjectsState(): void {
         for each (var object: IInteractivePlanetMapObject in interactiveObjects) {
            object.faded = false;
         }
      }

      /**
       * Moves planet object's component to its position.
       *
       * @param object planet object component to position.
       */
      public function positionObject(object: IPrimitivePlanetMapObject): void {
         var model: MPlanetObject = object.model;
         object.x = _map.coordsTransform.logicalToReal_X(model.x, model.yEnd);
         object.y = _map.coordsTransform.logicalToReal_Y(model.xEnd, model.yEnd)
                       - (object.height - model.realBasementHeight);
      }

      public function repositionAllObjects(): void {
         for each (var object: IPrimitivePlanetMapObject
               in primitiveAndInteractiveObjects) {
            positionObject(object);
         }
      }


      /* ####################### */
      /* ### EVENTS HANDLERS ### */
      /* ####################### */

      private function addPlanetEventHandlers(planet: MPlanet): void {
         planet.addEventListener(
            MPlanetEvent.OBJECT_ADD, planet_objectAddHandler, false, 0, true
         );
         planet.addEventListener(
            MPlanetEvent.OBJECT_REMOVE,
            planet_objectRemoveHandler, false, 0, true
         );
      }

      private function removePlanetEventHandlers(planet: MPlanet): void {
         planet.removeEventListener(
            MPlanetEvent.OBJECT_ADD, planet_objectAddHandler, false
         );
         planet.removeEventListener(
            MPlanetEvent.OBJECT_REMOVE, planet_objectRemoveHandler, false
         );
      }

      private function planet_objectAddHandler(event: MPlanetEvent): void {
         notifyVLsOfObjAdd(event.object);
      }

      private function planet_objectRemoveHandler(event: MPlanetEvent): void {
         removeObject(event.object);
      }

      private function addSelfEventHandlers(): void {
         addEventListener(
            MouseEvent.CLICK, this_mouseEventFilter, false, 0, true
         );
         addEventListener(
            MouseEvent.DOUBLE_CLICK, this_mouseEventFilter, false, 0, true
         );
         addEventListener(
            MouseEvent.MOUSE_UP, this_mouseEventFilter, false, 0, true
         );
         addEventListener(
            MouseEvent.MOUSE_DOWN, this_mouseEventFilter, false, 0, true
         );
         addEventListener(
            MouseEvent.MOUSE_MOVE, this_mouseEventFilter, false, 0, true
         );
         addEventListener(
            MouseEvent.MOUSE_OUT, this_mouseEventFilter, false, 0, true
         );
         addEventListener(
            MouseEvent.MOUSE_OVER, this_mouseEventFilter, false, 0, true
         );
      }

      private function removeSelfEventHandlers(): void {
         removeEventListener(MouseEvent.CLICK, this_mouseEventFilter, false);
         removeEventListener(
            MouseEvent.DOUBLE_CLICK, this_mouseEventFilter, false
         );
         removeEventListener(MouseEvent.MOUSE_UP, this_mouseEventFilter, false);
         removeEventListener(
            MouseEvent.MOUSE_DOWN, this_mouseEventFilter, false
         );
         removeEventListener(
            MouseEvent.MOUSE_MOVE, this_mouseEventFilter, false
         );
         removeEventListener(
            MouseEvent.MOUSE_OUT, this_mouseEventFilter, false
         );
         removeEventListener(
            MouseEvent.MOUSE_OVER, this_mouseEventFilter, false
         );
      }
   }
}