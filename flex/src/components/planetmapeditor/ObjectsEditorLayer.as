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
   import models.building.Extractor;
   import models.folliage.BlockingFolliage;
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import models.tile.Tile;
   import models.tile.TileKind;

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
         if (object is Building) {
            component = new MapBuilding();
         }
         else if (object is BlockingFolliage) {
            component = new BlockingFolliageMapObject();
         }
         else {
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
//               objectsLayer.redispatchEventFromMap(event);
               break;

            case MouseEvent.CLICK:
               this_clickHandler(event);
               break;

            case MouseEvent.MOUSE_DOWN:
            case MouseEvent.MOUSE_UP:
               // For map drag to work
//               objectsLayer.redispatchEventFromMap(event);
               break;
         }
      }

      private function activate(): void {
         objectsLayer.passOverMouseEventsTo(this);
         _objectPlaceholder.visible = true;
         moveObjectToMouse(_objectPlaceholder);
      }

      private function deactivate(): void {
         _objectPlaceholder.visible = false;
      }

      private function this_mouseOverHandler(event: MouseEvent): void {
         moveObjectToMouse(_objectPlaceholder);
      }

      private function this_mouseMoveHandler(event: MouseEvent): void {
         moveObjectToMouse(_objectPlaceholder);
      }

      private function this_clickHandler(event: MouseEvent): void {
         const object: MPlanetObject = _objectPlaceholder.model;
         var objectUnder: MPlanetObject = null;
         if (!planet.isObjectOnMap(object)) {
            return;
         }
         const building: Building = object as Building;
         const foliage: BlockingFolliage = object as BlockingFolliage;
         var x: int;
         var y: int;
         for (x = object.x; x <= object.xEnd; x++) {
            for (y = object.y; y <= object.yEnd; y++) {
               objectUnder = planet.getObject(x, y);
               if (objectUnder != null) {
                  planet.removeObject(objectUnder);
               }
               if (object is BlockingFolliage
                      || building.isTileRestricted(planet.getTileKind(x, y))) {
                  planet.removeTile(x, y);
               }
            }
         }
         if (object is Building) {
            const gap: int = Building.GAP_BETWEEN;
            const xEnd: int = Math.min(object.xEnd + gap, planet.width - 1);
            const yEnd: int = Math.min(object.yEnd + gap, planet.height - 1);
            for (x = Math.max(object.x - gap, 0); x <= xEnd; x++) {
               for (y = Math.max(object.y - gap, 0); y <= yEnd; y++) {
                  objectUnder = planet.getObject(x, y);
                  if (objectUnder is Building) {
                     planet.removeObject(objectUnder);
                  }
                  if (TileKind.isResourceKind(planet.getTileKind(x, y))) {
                     planet.removeTile(x, y);
                  }
               }
            }
            if (building.isExtractor) {
               planet.addResourceTile(
                  building.x, building.y, Extractor(building).baseResource
               );
            }
         }
         planet.addObject(
            object is Building ? cloneBuilding(building) : cloneFoliage(foliage)
         );
         map.renderBackground(false);
      }

      private function cloneFoliage(foliage: BlockingFolliage): BlockingFolliage {
         const clone:BlockingFolliage = new BlockingFolliage();
         clone.kind = foliage.kind;
         clone.terrainType = foliage.terrainType;
         copyDimensions(foliage, clone);
         return clone;
      }

      private function cloneBuilding(building: Building): Building {
         const clone:Building = new building.CLASS();
         clone.id = 1;
         clone.planetId = building.planetId;
         clone.type = building.type;
         clone.level = Math.min(building.level, building.maxLevel);
         clone.hp = clone.hpMax;
         clone.state = Building.ACTIVE;
         copyDimensions(building, clone);
         return clone;
      }

      private function copyDimensions(source:MPlanetObject,
                                      destination:MPlanetObject): void {
         destination.x = source.x;
         destination.y = source.y;
         destination.xEnd = source.xEnd;
         destination.yEnd = source.yEnd;
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
