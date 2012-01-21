package components.planetmapeditor
{
   import com.developmentarc.core.utils.EventBroker;

   import components.map.planet.PlanetMap;

   import components.map.planet.PlanetObjectsLayer;

   import components.map.planet.PlanetVirtualLayer;
   import components.map.planet.objects.BlockingFolliageMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;
   import components.map.planet.objects.InteractivePlanetMapObject;
   import components.map.planet.objects.MapBuilding;

   import flash.events.KeyboardEvent;

   import flash.events.MouseEvent;
   import flash.geom.Point;

   import models.building.Building;
   import models.folliage.BlockingFolliage;

   import models.planet.MPlanet;

   import models.planet.MPlanetObject;

   import mx.collections.ListCollectionView;

   import utils.Objects;


   public class ObjectsEditorLayer extends PlanetVirtualLayer
   {
      override protected function get componentClass(): Class {
         return InteractivePlanetMapObject;
      }

      override protected function get modelClass(): Class {
         return MPlanetObject;
      }

      override protected function get objectsList(): ListCollectionView {
         return planet.objects;
      }

      public function ObjectsEditorLayer(initialObject:MPlanetObject) {
         super();
         _initialObject = Objects.paramNotNull("initialObject", initialObject);
      }

      private var _initialObject:MPlanetObject;
      private var _objectPlaceholder:CObjectPlaceholder =
                     new CObjectPlaceholder();

      override public function initialize(objectsLayer: PlanetObjectsLayer,
                                          map: PlanetMap,
                                          planet: MPlanet): void {
         super.initialize(objectsLayer, map, planet);
         _objectPlaceholder.initModel(_initialObject);
         _objectPlaceholder.visible = false;
         _objectPlaceholder.depth = Number.MAX_VALUE;
         objectsLayer.addObject(_objectPlaceholder);
         activate();
         _initialObject = null;
      }

      override protected function addObjectImpl(object: MPlanetObject): IPrimitivePlanetMapObject {
         var component:InteractivePlanetMapObject = null;
         switch (object.CLASS) {
            
            case Building:
               component = new MapBuilding();
               break;
            
            case BlockingFolliage:
               component = new BlockingFolliageMapObject();
               break;

            default:
               throw new Error("Unsupported object type: " + object.CLASS);
         }
         component.initModel(object);
         objectsLayer.addObject(component);
         return component;
      }

      override public function handleMouseEvent(event: MouseEvent): void {
         switch (event.type) {
            case MouseEvent.MOUSE_OVER:
               this_mouseOverHandler(event);
               break;

            case MouseEvent.MOUSE_MOVE:
               this_mouseMoveHandler(event);
               // For map drag to work
               objectsLayer.redispatchEventFromMap(event);
               break;

            case MouseEvent.CLICK:
               this_clickHandler(event);
               break;

            case MouseEvent.MOUSE_DOWN:
            case MouseEvent.MOUSE_UP:
               // For map drag to work
               objectsLayer.redispatchEventFromMap(event);
               break;
         }
      }

      private function activate(): void {
         objectsLayer.passOverMouseEventsTo(this);
         _objectPlaceholder.visible = true;
         repositionObjectPlaceholder();
      }

      private function deactivate(): void {
         _objectPlaceholder.visible = false;
      }

      private function this_mouseOverHandler(event: MouseEvent): void {
         repositionObjectPlaceholder();
      }

      private function this_mouseMoveHandler(event: MouseEvent): void {
         repositionObjectPlaceholder();
      }

      private function this_clickHandler(event: MouseEvent): void {
         // remove objects under the object and in the immediate vicinity
         // add new object at the coordinates
      }

      private function repositionObjectPlaceholder(): void {
         const logicalCoords: Point = map.coordsTransform.realToLogical(
            new Point(objectsLayer.mouseX, objectsLayer.mouseY)
         );

         // Don't do anything if object has not been moved.
         const object: MPlanetObject = _objectPlaceholder.model;
         if (!object.moveTo(logicalCoords.x, logicalCoords.y)) {
            return;
         }

         objectsLayer.positionObject(_objectPlaceholder);
      }

      /* ################################ */
      /* ### INTERFACE FOR MAP EDITOR ### */
      /* ################################ */

      public function setObject(object:MPlanetObject): void {
         _objectPlaceholder.initModel(object);
      }


      /* ################################ */
      /* ### KEYBOARD EVENTS HANDLERS ### */
      /* ################################ */

      override protected function addGlobalEventHandlers(): void {
         EventBroker.subscribe(KeyboardEvent.KEY_DOWN, keyboard_keyDownHandler);
         EventBroker.subscribe(KeyboardEvent.KEY_UP, keyboard_keyUpHandler);
      }

      override protected function removeGlobalEventHandlers(): void {
         EventBroker.unsubscribe(KeyboardEvent.KEY_DOWN, keyboard_keyDownHandler);
         EventBroker.unsubscribe(KeyboardEvent.KEY_UP, keyboard_keyUpHandler);
      }

      private function keyboard_keyDownHandler(event:KeyboardEvent): void {
         if (event.keyCode == TerrainEditorLayer.ACTIVATION_KEY_CODE) {
            deactivate();
         }
      }

      private function keyboard_keyUpHandler(event:KeyboardEvent): void {
         if (event.keyCode == TerrainEditorLayer.ACTIVATION_KEY_CODE) {
            activate();
         }
      }
   }
}
