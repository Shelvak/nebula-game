package components.map.planet
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.base.BaseContainer;
   import components.gameobjects.planet.IInteractivePlanetMapObject;
   import components.gameobjects.planet.IPrimitivePlanetMapObject;
   
   import controllers.screens.MainAreaScreens;
   
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import globalevents.GBuildingEvent;
   import globalevents.GScreenChangeEvent;
   
   import models.planet.Planet;
   import models.planet.PlanetObject;
   import models.planet.events.PlanetEvent;
   
   import mx.collections.ArrayCollection;
   import mx.core.IVisualElement;
   
   
   /**
    * Responsible for laying out objects on top of the planet map, user
    * interaction with those objects and similar stuff.
    */
   public class PlanetObjectsLayer extends BaseContainer
   {
      /* ###################################### */
      /* ### INITIALIZATION AND DESTRUCTION ### */
      /* ###################################### */
      
      
      /**
       * Constructor. Register event listeners.
       */
      public function PlanetObjectsLayer(map:PlanetMap, planet:Planet)
      {
         super();
         this.map = map;
         this.planet = planet;
         addPlanetEventHandlers(planet);
         doubleClickEnabled = true;
         addEventListener (MouseEvent.CLICK, this_mouseEventFilter);
         addEventListener (MouseEvent.DOUBLE_CLICK, this_mouseEventFilter);
         addEventListener (MouseEvent.MOUSE_UP, this_mouseEventFilter);
         addEventListener (MouseEvent.MOUSE_DOWN, this_mouseEventFilter);
         addEventListener (MouseEvent.MOUSE_MOVE, this_mouseEventFilter);
         addEventListener (MouseEvent.MOUSE_OUT, this_mouseEventFilter);
         addEventListener (MouseEvent.MOUSE_OVER, this_mouseEventFilter);
      }
      
      
      private var map:PlanetMap = null;
      private var planet:Planet = null;
      
      
      protected override function createChildren():void
      {
         super.createChildren();
         createVLs();
      }
      
      
      /**
       * Call this method to unregister any event listeners in order instance
       * could be garbage-collected.
       */      
      public function cleanup() : void
      {
         if (planet)
         {
            removePlanetEventHandlers(planet);
         }
         destroyVLs();
         deselectSelectedObject();
         takeOverMouseEvents();
      }
      
      
      /**
       * @see components.map.BaseMap#reset()
       */
      public function reset() : void
      {
         resetAllInteractiveObjectsState();
         deselectSelectedObject();
         takeOverMouseEvents();
         forEachVL(
            function(layer:PlanetVirtualLayer) : void
            {
               layer.reset();
            }
         );
      }
      
      
      /* ############ */
      /* ### SIZE ### */
      /* ############ */
      
      
      protected override function measure() : void
      {
         var size:Point = map.getSize();
         measuredWidth = size.x;
         measuredHeight = size.y;
      }
      
      
      /* ###################### */
      /* ### VIRTUAL LAYERS ### */
      /* ###################### */
      
      
      private var virtualLayers:Array = [];
      /**
       * Invokes given <code>callback</code> function on each virtual layer.
       * <p>Signature of the callback function:
       * <code>function(layer:PlanetVirtualLayer) : void</code>.</p>
       */
      private function forEachVL(callback:Function) : void
      {
         for each (var layer:PlanetVirtualLayer in virtualLayers)
         {
            callback.call(this, layer);
         }
      }
      
      
      private function createVLs() : void
      {
         virtualLayers.push(
            new BuildingsLayer(),
            new BlockingFolliagesLayer(),
            new NonblockingFolliagesLayer()
         );
         initializeVLs();
      }
      
      
      private function destroyVLs() : void
      {
         forEachVL(
            function(layer:PlanetVirtualLayer) : void
            {
               layer.cleanup();
            }
         );
         virtualLayers = [];
      }
      
      
      private function initializeVLs() : void
      {
         forEachVL(
            function(layer:PlanetVirtualLayer) : void
            {
               layer.initialize(this, map, planet);
            }
         );
      }
      
      private function notifyVLsOfObjSelection(object:IInteractivePlanetMapObject) : void
      {
         forEachVL(
            function(layer:PlanetVirtualLayer) : void
            {
               layer.objectSelected(object);
            }
         );
      }
      
      
      private function notifyVLsOfObjDeselection(object:IInteractivePlanetMapObject) : void
      {
         forEachVL(
            function(layer:PlanetVirtualLayer) : void
            {
               layer.objectDeselected(object);
            }
         );
      }
      
      
      private function notifyVLsOfObjAdd(object:PlanetObject) : void
      {
         forEachVL(
            function(layer:PlanetVirtualLayer) : void
            {
               layer.addObject(object);
            }
         );
      }
      
      
      private function notifyVLsOfObjRemove(object:IPrimitivePlanetMapObject) : void
      {
         forEachVL(
            function(layer:PlanetVirtualLayer) : void
            {
               layer.objectRemoved(object);
            }
         );
      }
      
      
      private function notifyVLsOfObjDoubleClick(object:IPrimitivePlanetMapObject) : void
      {
         forEachVL(
            function(layer:PlanetVirtualLayer) : void
            {
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
      private var mouseEventsOwner:PlanetVirtualLayer = null;
      
      
      /**
       * <code>true</code> if this instance of <code>PlanetObjectsLayer</code>
       * is directly responsible for handling mouse events or <code>false</code>
       * if most of the events should be passed over to one of virtual layers
       * (<code>mouseEventsOwner</code>).
       */
      private function get ownsMouseEvents() : Boolean
      {
         return mouseEventsOwner == null;
      }
      
      
      /**
       * Called by one of virtual layers to take over mouse events handling.
       */
      public function passOverMouseEventsTo(layer:PlanetVirtualLayer) : void
      {
         mouseEventsOwner = layer;
      }
      
      
      /**
       * Called by one of virtual layers to return mouse events handling to
       * <code>PlanetObjectsLayer</code>. This method should be called
       * by the same <code>PlanetVirtualLayer</code> that has called
       * <code>passOverMouseEventsTo(layer:PlanetVirtualLayer) : void</code>
       * method. 
       */
      public function takeOverMouseEvents() : void
      {
         mouseEventsOwner = null;
      }
      
      
      /**
       * An object that is currenty under the mouse pointer or was under it just a moment ago.
       */
      private var objectUnderMouse:IInteractivePlanetMapObject = null;
      
      
      /**
       * This component has a sophisticated mouse events handling logic:
       * <ul>
       *    <li>MOUSE_OVER, MOUSE_OUT, CLICK, DOUBLE_CLICK, MOUSE_DOWN, MOUSE_UP events are
       *        canceled and redispached from the <code>map.background</code> object.</li>
       *    <li>MOUSE_OVER, MOUSE_OUT events are dispatched also from <code>map.background</code>
       *        when mouse rolls out, rolls over, moves out and moves over the object
       *        respectively.</li>
       *    <li>If CLICK, DOUBLE_CLICK, MOUSE_OVER, MOUSE_OUT, MOUSE_DOWN, MOUSE_UP occures
       *        while mouse is over the basement of an object, appropriate handler of that
       *        object component is called and event is canceled.</li>
       * </ul>
       */
      private function this_mouseEventFilter(event:MouseEvent) : void
      {
         // If event originated from the map background we must pass it
         // to upper layers in order map dragging could work properly.
         // If it has originated form InteractivePlanetMapObject
         // that means this event has be redispached from that object by
         // this component and should be passed to upper layers in order cursors
         // to work properly.
         if (event.target == map || event.target is IInteractivePlanetMapObject)
         {
            return;
         }
         
         event.stopImmediatePropagation ();
         
         if (event.type == MouseEvent.MOUSE_OVER || event.type == MouseEvent.MOUSE_OUT)
         {
            redispatchEventFromMap(event);
         }
         
         // If one of the layers have taken over mouse events it will do the rest
         if (!ownsMouseEvents)
         {
            mouseEventsOwner.handleMouseEvent(event);
            return;
         }
         
         var tileCoords:Point = map.getLogicalTileCoords(mouseX, mouseY);
         var object:IInteractivePlanetMapObject =
            tileCoords ? getInteractiveObjectOnTile(tileCoords.x, tileCoords.y) : null;
         
         // There is an interactive object under the mouse
         if (object)
         {
            switch (event.type)
            {
               case MouseEvent.MOUSE_MOVE:
                  if (!objectUnderMouse)
                  {
                     dispatchMapEvent(MouseEvent.MOUSE_OUT, event);
                     object_mouseOverHandler(object, event);
                  }
                  else if (objectUnderMouse != object)
                  {
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
         else
         {
            if (objectUnderMouse)
            {
               object_mouseOutHandler(objectUnderMouse, event);
               objectUnderMouse = null;
               dispatchMapEvent(MouseEvent.MOUSE_OVER, event);
            }
            
            switch(event.type)
            {
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
       * Dispatches given mouse event form the <code>map</code> component but of the the given
       * <code>type</code> (copy of the given event is created actually).
       */      
      public function dispatchMapEvent(type:String, source:MouseEvent) : void
      {
         map.dispatchEvent(getMouseEvent(type, source));
      } 
      
      /**
       * Cancels propagation of a given event and dispathces if form the <code>map.backrgound</code>
       * component.  
       */      
      public function redispatchEventFromMap(event:MouseEvent) : void
      {
         map.dispatchEvent(event);
      }
      
      /**
       * Creates a copy of a givent <code>MouseEvent</code> object (<code>source</code>)
       * but the returned event object will have <code>type</code> property set to a given
       * string (<code>type</code>).
       */      
      private function getMouseEvent(type:String, source:MouseEvent) : MouseEvent
      {
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
      
      
      private function object_mouseOverHandler(object:IInteractivePlanetMapObject, event:MouseEvent) : void
      {
         if (!object)
         {
            return;
         }
         object.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
//         for each (var current:IInteractivePlanetMapObject in getOverlappingObjects(object))
//         {
//            current.faded = true;
//         }
      }
      
      
      private function object_mouseOutHandler(object:IInteractivePlanetMapObject, event:MouseEvent) : void
      {
         if (!object)
         {
            return;
         }
         object.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
         resetAllInteractiveObjectsState();
      }
      
      
      private function object_clickHandler(object:IInteractivePlanetMapObject, event:MouseEvent) : void
      {
         if (!object)
         {
            return;
         }
         selectObject(object);
      }
      
      
      private function object_doubleClickHandler(object:IInteractivePlanetMapObject, event:MouseEvent) : void
      {
         if (!object)
         {
            return;
         }
         notifyVLsOfObjDoubleClick(object);
      }
      
      
      /* ######################################### */
      /* ### OBJECTS SELECTION AND DESELECTION ### */
      /* ######################################### */
      
      
      private var selectedObject:IInteractivePlanetMapObject = null;
      
      
      /**
       * Selects given object. If there is another object selected,
       * deselects it.
       */
      internal function selectObject(object:IInteractivePlanetMapObject) : void
      {
         if (selectedObject == object)
         {
            return;
         }
         deselectSelectedObject();
         selectedObject = object;
         selectedObject.select();
         notifyVLsOfObjSelection(object);
      }
      
      
      /**
       * Deselects selected building if there is one.
       */
      internal function deselectSelectedObject() : void
      {
         if (selectedObject)
         {
            selectedObject.deselect();
            notifyVLsOfObjDeselection(selectedObject);
            selectedObject = null;
         }
      }
      
      
      /* ######################################## */
      /* ### OBJECTS CREATION AND DESTRUCTION ### */
      /* ######################################## */
      
      
      /**
       * Lets you add a new object to this layer. Typically this is called
       * by one of virtual layers.
       */
      public function addObject(object:IPrimitivePlanetMapObject, addEventHandlers:Boolean = true) : void
      {
         addElement(object);
         positionObject(object);
      }
      
      
      /**
       * This is called when an object from a planet has been removed.
       * 
       * @param model instance of <code>PlanetObject</code> that has been
       * removed from the planet.
       * @param vlNotification if <code>true</code>, virtual layers will be
       * notified about this event, however, they will be passed component
       * instead of the model.
       */
      public function removeObject(model:PlanetObject, vlNotification:Boolean = true) : void
      {
         var object:IPrimitivePlanetMapObject = getObjectByModel(model);
         if (!object)
         {
            throw new Error("Could not find component that represents given PlanetObject!");
         }
         removeElement(object);
         object.cleanup();
         if (vlNotification)
         {
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
      private function filterDisplayList(filterFunction:Function) : ArrayCollection
      {
         var list:ArrayCollection = new ArrayCollection();
         for (var i:int = 0; i < numElements; i++)
         {
            if (filterFunction.call(this, getElementAt(i) as IVisualElement))
            {
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
      private function get primitiveAndInteractiveObjects() : ArrayCollection
      {
         return filterDisplayList(
            function(object:IVisualElement) : Boolean
            {
               return object is IPrimitivePlanetMapObject;
            }
         );
      }
      
      
      /**
       * Collection of all <code>IInteractivePlanetMapObject</code> instance in the display list.
       * Changes to this list won't have effect on display list.
       */
      private function get interactiveObjects() : ArrayCollection
      {
         return filterDisplayList(
            function(object:IVisualElement) : Boolean
            {
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
      public function getObjectByModel(model:PlanetObject) : IPrimitivePlanetMapObject
      {
         for each (var object:IPrimitivePlanetMapObject in primitiveAndInteractiveObjects)
         {
            if (object.model == model)
            {
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
      public function getObjectOnTile(logicalX:int, logicalY:int) : IPrimitivePlanetMapObject
      {
         for each (var object:IPrimitivePlanetMapObject in primitiveAndInteractiveObjects)
         {
            if (object.model.standsOn(logicalX, logicalY))
            {
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
      public function getInteractiveObjectOnTile(logicalX:int, logicalY:int) : IInteractivePlanetMapObject
      {
         var object:IPrimitivePlanetMapObject = getObjectOnTile(logicalX, logicalY);
         if (object && object is IInteractivePlanetMapObject)
         {
            return object as IInteractivePlanetMapObject;
         }
         else
         {
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
      public function getOverlappingObjects(object:IPrimitivePlanetMapObject) : Array
      {
         var result:Array = new Array();
         
         /**
          * Overlaping objects migh be on the tiles that are of distStart to
          * distEnd tiles distance (distEnd - distStart + 1 tiles gap between
          * buildings) from the given object to logical west, south and
          * south-west.
          */
         var distStart:int = 2;
         var distEnd:int = 2;
         
         var model:PlanetObject = object.model;
         
         var xMinStart:int = model.x - distStart;  
         var xMinEnd:int = model.x - distEnd; 
         var xMax:int = model.xEnd;
         
         var yMinStart:int = model.y - distStart;
         var yMinEnd:int = model.y - distEnd;
         var yMax:int = model.yEnd;
         
         for each (var comp:IInteractivePlanetMapObject in interactiveObjects)
         {
            if (// Logical horizontal area of tiles that might have overlaping objects
                comp.model.fallsIntoArea(xMinEnd, xMax, yMinEnd, yMinStart) ||
                // Logical vertical area of tiles that might have overlaping objects
                comp.model.fallsIntoArea(xMinEnd, xMinStart, yMinEnd, yMax))
            {
               result.push (comp);
            }
         }
         
         return result;
      }
      
      
      /**
       * Resets all building components to their default state. This
       * does not change selection of those objects.
       */
      public function resetAllInteractiveObjectsState() : void
      {
         for each (var object:IInteractivePlanetMapObject in interactiveObjects)
         {
            object.faded = false;
         }
      }
      
      
      /**
       * Moves palnet object's component to its position.
       *  
       * @param object planet object component to position.
       */
      public function positionObject(object:IPrimitivePlanetMapObject) : void
      {
         var model:PlanetObject = object.model;
         object.x = map.getRealTileX(model.x, model.yEnd);
         object.y = map.getRealTileY(model.xEnd, model.yEnd) -
                   (object.height - model.realBasementHeight);
      }
      
      
      /* ####################### */
      /* ### EVENTS HANDLERS ### */
      /* ####################### */
      
      
      private function addPlanetEventHandlers(planet:Planet) : void
      {
         planet.addEventListener(PlanetEvent.OBJECT_ADD, planet_objectAddHandler);
         planet.addEventListener(PlanetEvent.OBJECT_REMOVE, planet_objectRemoveHandler);
      }
      private function removePlanetEventHandlers(p:Planet) : void
      {
         planet.removeEventListener(PlanetEvent.OBJECT_ADD, planet_objectAddHandler);
         planet.removeEventListener(PlanetEvent.OBJECT_REMOVE, planet_objectRemoveHandler);
      }
      
      
      private function planet_objectAddHandler(event:PlanetEvent) : void
      {
         notifyVLsOfObjAdd(event.object);
      }
      
      
      private function planet_objectRemoveHandler(event:PlanetEvent) : void
      {
         removeObject(event.object);
      }
   }
}