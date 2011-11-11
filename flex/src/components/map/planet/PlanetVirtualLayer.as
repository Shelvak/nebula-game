package components.map.planet
{
   
   import flash.errors.IllegalOperationError;
   import flash.events.MouseEvent;
   
   import interfaces.ICleanable;
   
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;
   
   
   /**
    * Defines interface of virtual planet layer. Virtual planet layer
    * is not a component and therefore does not hold any planet objects.
    * Its responsibility is to implement custom planet objects behaviour
    * that does not fit into <code>ObjectsLayer</code>.
    */
   public class PlanetVirtualLayer implements ICleanable
   {
      /* ####################################### */
      /* ### LAYER SPECIALIZATION PROPERTIES ### */
      /* ####################################### */
      
      /**
       * Returns class of palnet objects component the layer is responsible for.
       * This is an abstract property and <strong>must be overriden</strong>
       * by subclasses.
       */
      protected function get componentClass() : Class
      {
         throw new IllegalOperationError("Property is abstract!");
      }
      
      
      /**
       * Returns class of planet objects model the layer is responsible for.
       * This is an abstract property and <strong>must be overriden</strong>
       * by subclasses.
       */
      protected function get modelClass() : Class
      {
         throw new IllegalOperationError("Property is abstract!");
      }
      
      
      protected function get objectsListName() : String
      {
         throw new IllegalOperationError("Property is abstract!");
      }
      
      
      /* ############################################ */
      /* ### LAYER INITIALIZATION AND DESTRUCTION ### */
      /* ############################################ */
      
      
      protected var objectsLayer:PlanetObjectsLayer = null;
      protected var map:PlanetMap = null;
      protected var planet:MPlanet = null;
      
      
      /**
       * Called by <code>objectsLayer</code> to initialize virtual layer. This is called only once
       * when planet map is beeing constructed or changed. Default behaviour of this method is:
       * <ul>
       *    <li>Calls <code>cleanup()</code>.</li>
       *    <li>sets <code>objectsLayer</code>, <code>map</code> and <code>planet</code>
       *        properties to values that were passed to this method.</li>
       *    <li>Adds event handlers to <code>objectsLayer</code>, <code>planet</code> and
       *        <code>EventBroker</code> by calling <code>addPlanetEventHandlers()</code>,
       *        <code>addObjectsLayerEventHandlers</code> and
       *        <code>addGlobalEventHandlers()</code>.</li>
       *    <li>Then loops through all given planet's objects and creates components for
       *        only the object type this virtual layer is responsible for.</li>
       * </ul>
       */
      public function initialize(objectsLayer:PlanetObjectsLayer, map:PlanetMap, planet:MPlanet) : void
      {
         cleanup();
         this.map = map;
         this.objectsLayer = objectsLayer;
         this.planet = planet;
         addGlobalEventHandlers();
         addObjectsLayerEventHandlers(objectsLayer);
         addPlanetEventHandlers(planet);
         for each (var object:MPlanetObject in planet[objectsListName])
         {
            addObjectImpl(object);
         }
      }
         
         
      /**
       * Called by instance of <code>PlanetObjectsLayer</code> when it
       * needs to be garbage collected. You should unregister any event listeners
       * in this method to make that available. 
       */
      public function cleanup() : void
      {
         removeGlobalEventHandlers();
         if (objectsLayer)
         {
            removeObjectsLayerEventHandlers(objectsLayer);
         }
         if (planet)
         {
            removePlanetEventHandlers(planet);
         }
         if (planet && objectsLayer)
         {
            removeAllObjects();
         }
         objectsLayer = null;
         planet = null;
      }
      
      
      /**
       * @see components.map.BaseMap#reset()
       */
      public function reset() : void
      {
      }
      
      
      /**
       * Removes all objects of the type this layer is responsible for from
       * <code>objectsLayer</code>. 
       */
      protected function removeAllObjects() : void
      {
         for each (var object:MPlanetObject in planet.objects)
         {
            if (object is modelClass)
            {
               objectsLayer.removeObject(object, false);
            }
         }
      }
      
      
      /* ############################ */
      /* ### NOTIFICATION METHODS ### */
      /* ############################ */
      
      
      /**
       * Called by <code>PlanetObjectsLayer</code> when an interactive object
       * has been selected.
       */
      public function objectSelected(object:IInteractivePlanetMapObject) : void
      {
         if (object is componentClass)
         {
            objectSelectedImpl(object);
         }
      }
      /**
       * Override this to react to object selection in <code>objectsLayer</code>.
       * Inside this method you can safely cast <code>object</code> to
       * the type returned by <code>objectComponentClass</code>.
       */
      protected function objectSelectedImpl(object:IInteractivePlanetMapObject) : void
      {
      }
      
      
      /**
       * Called by <code>PlanetObjectsLayer</code> when an interactive object
       * has been deselected.
       */
      public function objectDeselected(object:IInteractivePlanetMapObject) : void
      {
         if (object is componentClass)
         {
            objectDeselectedImpl(object);
         }
      }
      /**
       * Override this to react to object deselection in <code>objectsLayer</code>.
       * Inside this method you can safely cast <code>object</code> to
       * the type returned by <code>objectComponentClass</code>.
       */
      protected function objectDeselectedImpl(object:IInteractivePlanetMapObject) : void
      {
      }
      
      
      /**
       * Called by <code>PlanetObjectsLayer</code> when a new object
       * has been added to the planet.
       */
      public function addObject(object:MPlanetObject) : void
      {
         if (object is modelClass)
         {
            addObjectImpl(object);
         }
      }
      /**
       * Override this change default layer's behaviour when component needs to be created
       * and added to <code>objectsLayer</code>. Inside this method you can safely cast
       * <code>object</code> to the type returned by <code>modelClass</code>.
       * 
       * @return component created
       */
      protected function addObjectImpl(object:MPlanetObject) : IPrimitivePlanetMapObject
      {
         var component:IPrimitivePlanetMapObject = new componentClass() as IPrimitivePlanetMapObject;
         component.initModel(object);
         objectsLayer.addObject(component);
         return component;
      }
      
      
      
      /**
       * Called by <code>PlanetObjectsLayer</code> when an object has been removed. You don't need and should not call
       * any methods on <code>objectsLayer</code> considering the removed object.
       */
      public function objectRemoved(object:IPrimitivePlanetMapObject) : void
      {
         if (object is componentClass)
         {
            objectRemovedImpl(object);
         }
      }
      /**
       * Override this to react to object removal from <code>objectsLayer</code>.
       * Inside this method you can safely cast <code>object</code> to
       * the type returned by <code>componentClass</code>.
       */
      protected function objectRemovedImpl(object:IPrimitivePlanetMapObject) : void
      {
      }
      
      
      /**
       * Called by <code>PlanetObjectsLayer</code> when a user has double-clicked on an object and it probably should be
       * opened.
       */
      public function openObject(object:IPrimitivePlanetMapObject) : void
      {
         if (object is componentClass)
         {
            openObjectImpl(object);
         }
      }
      /**
       * Override this to react to a double-click on an object in <code>objectsLayer</code>. Inside this method you can
       * safely cast <code>object</code> to the type returned by <code>objectComponentClass</code>.
       */
      protected function openObjectImpl(object:IPrimitivePlanetMapObject) : void
      {
      }
      
      
      
      /* ############################ */
      /* ### MOUSE ENTRY FUNCTION ### */
      /* ############################ */
      
      
      /**
       * Called by <code>objectsLayer</code> after this layer has invoked
       * <code>passOverMouseEvents(layer:PlanetVirtualLayer)</code> method
       * on <code>objectsLayer</code> and a mouse event occured.
       */
      public function handleMouseEvent(event:MouseEvent) : void
      {
      }
      
      
      /* ################################### */
      /* ### EVENT HANDLERS REGISTRATION ### */
      /* ################################### */
      
      
      /**
       * Override this to register add event listeners to
       * <code>EventBroker</code>.
       */
      protected function addGlobalEventHandlers() : void
      {
      }
      
      
      /**
       * Override this to remove any event listeners from
       * <code>EventBroker</code> that were added by
       * <code>addGlobalEventHandlers()</code>.
       */
      protected function removeGlobalEventHandlers() : void
      {
      }
      
      
      protected function addObjectsLayerEventHandlers(objectsLayer:PlanetObjectsLayer) : void
      {
      }
      
      
      protected function removeObjectsLayerEventHandlers(objectsLayer:PlanetObjectsLayer) : void
      {
      }
      
      
      protected function addPlanetEventHandlers(planet:MPlanet) : void
      {
      }
      
      
      protected function removePlanetEventHandlers(planet:MPlanet) : void
      {
      }
   }
}