package components.map.planet
{

   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;

   import flash.events.MouseEvent;
   import flash.geom.Point;

   import interfaces.ICleanable;

   import models.planet.MPlanet;
   import models.planet.MPlanetObject;

   import mx.collections.ListCollectionView;

   import utils.Objects;


   /**
    * Defines interface of virtual planet layer. Virtual planet layer
    * is not a component and therefore does not hold any planet objects.
    * Its responsibility is to implement custom planet map behaviour regarding
    * specific objects that does not fit into <code>ObjectsLayer</code>.
    * 
    * <p>Although the main responsibility is handling objects of a specific
    * type, virtual layer that performs completely different actions is also
    * possible. However the API supports objects so you will have to make
    * most of the methods to be no-ops to implement some other behaviour.
    * Example of such implementation is <code>PlanetMapTerrainEditorLayer</code>.
    * </p>
    */
   public class PlanetVirtualLayer implements ICleanable
   {
      /* ####################################### */
      /* ### LAYER SPECIALIZATION PROPERTIES ### */
      /* ####################################### */
      
      /**
       * Returns class of planet objects component the layer is responsible for.
       * This is an abstract property and <strong>must be overridden</strong>
       * by subclasses.
       */
      protected function get componentClass(): Class {
         Objects.throwAbstractPropertyError();
         return null;   // unreachable
      }

      /**
       * Returns class of planet objects model the layer is responsible for.
       * This is an abstract property and <strong>must be overridden</strong>
       * by subclasses.
       */
      protected function get modelClass(): Class {
         Objects.throwAbstractPropertyError();
         return null;   // unreachable
      }

      protected function get objectsList(): ListCollectionView {
         Objects.throwAbstractPropertyError();
         return null;   // unreachable
      }
      
      
      /* ############################################ */
      /* ### LAYER INITIALIZATION AND DESTRUCTION ### */
      /* ############################################ */
      
      protected var objectsLayer:PlanetObjectsLayer = null;
      protected var map:PlanetMap = null;
      protected var planet:MPlanet = null;
      
      /**
       * Called by <code>objectsLayer</code> to initialize virtual layer. This
       * is called only once when planet map is being constructed or changed.
       * Default behaviour of this method is:
       * <ul>
       *    <li>Calls <code>cleanup()</code>.</li>
       *    <li>sets <code>objectsLayer</code>, <code>map</code> and
       *        <code>planet</code> properties to values that were passed to
       *        this method.</li>
       *    <li>Adds event handlers to <code>objectsLayer</code>,
       *        <code>planet</code> and <code>EventBroker</code> by calling
       *        <code>addPlanetEventHandlers()</code>,
       *        <code>addObjectsLayerEventHandlers</code> and
       *        <code>addGlobalEventHandlers()</code>.</li>
       *    <li>Then loops through all given planet's objects and creates
       *        components for only the object type this virtual layer is
       *        responsible for.</li>
       * </ul>
       */
      public function initialize(objectsLayer: PlanetObjectsLayer,
                                 map: PlanetMap,
                                 planet: MPlanet): void {
         cleanup();
         this.map = map;
         this.objectsLayer = objectsLayer;
         this.planet = planet;
         addGlobalEventHandlers();
         addObjectsLayerEventHandlers(objectsLayer);
         addPlanetEventHandlers(planet);
         for each (var object: MPlanetObject in objectsList) {
            addObjectImpl(object);
         }
      }

      /**
       * Called by instance of <code>PlanetObjectsLayer</code> when it
       * needs to be garbage collected. You should unregister any event listeners
       * in this method to make that available.
       */
      public function cleanup(): void {
         removeGlobalEventHandlers();
         if (objectsLayer) {
            removeObjectsLayerEventHandlers(objectsLayer);
         }
         if (planet) {
            removePlanetEventHandlers(planet);
         }
         if (planet && objectsLayer) {
            removeAllObjects();
         }
         objectsLayer = null;
         planet = null;
      }

      public function reset(): void {
      }

      /**
       * Removes all objects of the type this layer is responsible for from
       * <code>objectsLayer</code>.
       */
      protected function removeAllObjects(): void {
         for each (var object: MPlanetObject in planet.objects) {
            if (object is modelClass) {
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
      public function objectSelected(object: IInteractivePlanetMapObject): void {
         if (object is componentClass) {
            objectSelectedImpl(object);
         }
      }

      /**
       * Override this to react to object selection in <code>objectsLayer</code>.
       * Inside this method you can safely cast <code>object</code> to
       * the type returned by <code>objectComponentClass</code>.
       */
      protected function objectSelectedImpl(object: IInteractivePlanetMapObject): void {
      }


      /**
       * Called by <code>PlanetObjectsLayer</code> when an interactive object
       * has been deselected.
       */
      public function objectDeselected(object: IInteractivePlanetMapObject): void {
         if (object is componentClass) {
            objectDeselectedImpl(object);
         }
      }

      /**
       * Override this to react to object deselection in <code>objectsLayer</code>.
       * Inside this method you can safely cast <code>object</code> to
       * the type returned by <code>objectComponentClass</code>.
       */
      protected function objectDeselectedImpl(object: IInteractivePlanetMapObject): void {
      }


      /**
       * Called by <code>PlanetObjectsLayer</code> when a new object
       * has been added to the planet.
       */
      public function addObject(object: MPlanetObject): void {
         if (object is modelClass) {
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
      protected function addObjectImpl(object: MPlanetObject): IPrimitivePlanetMapObject {
         var component: IPrimitivePlanetMapObject =
                IPrimitivePlanetMapObject(new componentClass());
         component.initModel(object);
         objectsLayer.addObject(component);
         return component;
      }

      /**
       * Called by <code>PlanetObjectsLayer</code> when an object has been removed. You don't need and should not call
       * any methods on <code>objectsLayer</code> considering the removed object.
       */
      public function objectRemoved(object: IPrimitivePlanetMapObject): void {
         if (object is componentClass) {
            objectRemovedImpl(object);
         }
      }

      /**
       * Override this to react to object removal from <code>objectsLayer</code>.
       * Inside this method you can safely cast <code>object</code> to
       * the type returned by <code>componentClass</code>.
       */
      protected function objectRemovedImpl(object: IPrimitivePlanetMapObject): void {
      }

      /**
       * Called by <code>PlanetObjectsLayer</code> when a user has double-clicked on an object and it probably should be
       * opened.
       */
      public function openObject(object: IPrimitivePlanetMapObject): void {
         if (object is componentClass) {
            openObjectImpl(object);
         }
      }

      /**
       * Override this to react to a double-click on an object in <code>objectsLayer</code>. Inside this method you can
       * safely cast <code>object</code> to the type returned by <code>objectComponentClass</code>.
       */
      protected function openObjectImpl(object: IPrimitivePlanetMapObject): void {
      }

      protected function moveObjectToMouse(object: IPrimitivePlanetMapObject): void {
         const objectModel: MPlanetObject = object.model;
         const logicalCoords: Point = map.coordsTransform.realToLogical(
            new Point(objectsLayer.mouseX, objectsLayer.mouseY)
         );

         // Don't do anything if building has not been moved.
         if (!objectModel.moveTo(logicalCoords.x, logicalCoords.y)) {
            return;
         }

         objectsLayer.positionObject(object);
         afterObjectMoveToMouse(object);
      }

      /**
       * Invoked after an object has been moved by
       * <code>moveObjectToMouse()</code> method.
       */
      protected function afterObjectMoveToMouse(object: IPrimitivePlanetMapObject): void {
      }


      /* ############################ */
      /* ### MOUSE ENTRY FUNCTION ### */
      /* ############################ */

      /**
       * Called by <code>objectsLayer</code> after this layer has invoked
       * <code>passOverMouseEvents(layer:PlanetVirtualLayer)</code> method
       * on <code>objectsLayer</code> and a mouse event occured.
       */
      public function handleMouseEvent(event: MouseEvent): void {
      }

      
      /* ################################### */
      /* ### EVENT HANDLERS REGISTRATION ### */
      /* ################################### */

      protected function addGlobalEventHandlers(): void {
      }

      protected function removeGlobalEventHandlers(): void {
      }

      protected function addObjectsLayerEventHandlers(objectsLayer: PlanetObjectsLayer): void {
      }

      protected function removeObjectsLayerEventHandlers(objectsLayer: PlanetObjectsLayer): void {
      }

      protected function addPlanetEventHandlers(planet: MPlanet): void {
      }

      protected function removePlanetEventHandlers(planet: MPlanet): void {
      }
   }
}