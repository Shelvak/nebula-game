package components.planetmapeditor
{
   import com.developmentarc.core.utils.EventBroker;

   import components.map.planet.PlanetMap;
   import components.map.planet.PlanetObjectsLayer;
   import components.map.planet.PlanetVirtualLayer;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;

   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;

   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import models.tile.TileKind;

   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;

   import utils.Objects;


   public class TerrainEditorLayer extends PlanetVirtualLayer
   {
      internal static const ACTIVATION_KEY_CODE: int = Keyboard.CONTROL;

      public function TerrainEditorLayer(initialTile: IRTileKindM) {
         _initialTile = Objects.paramNotNull("initialTile", initialTile);
      }


      private var _initialTile: IRTileKindM = null;
      override public function initialize(objectsLayer: PlanetObjectsLayer,
                                          map: PlanetMap,
                                          planet: MPlanet): void {
         super.initialize(objectsLayer, map, planet);
         _tilePlaceholder.tile = _initialTile;
         _tilePlaceholder.visible = false;
         _tilePlaceholder.depth = Number.MAX_VALUE;
         objectsLayer.addObject(_tilePlaceholder);
         _initialTile = null;
      }

      private function activate(): void {
         objectsLayer.passOverMouseEventsTo(this);
         _tilePlaceholder.visible = true;
         repositionTilePlaceholder();
      }

      private function deactivate(): void {
         _tilePlaceholder.visible = false;
      }

      private var _tilePlaceholder: CTilePlaceholder = new CTilePlaceholder();

      override public function handleMouseEvent(event: MouseEvent): void {
         switch (event.type) {
            case MouseEvent.CLICK:
               this_clickHandler(event);
               break;

            case MouseEvent.MOUSE_MOVE:
               this_mouseMoveHandler(event);
               break;
         }
      }

      private function this_clickHandler(event: MouseEvent): void {
         const tile: IRTileKindM = _tilePlaceholder.tile;
         const object: MPlanetObject = _tilePlaceholder.tileObject;
         if (!planet.isObjectOnMap(object)
                || !TileKind.isResourceKind(tile.tileKind)) {
            return;
         }
         var x: int;
         var y: int;
         for (x = object.x; x <= object.xEnd; x++) {
            for (y = object.y; y <= object.yEnd; y++) {
               planet.removeTile(x, y);
            }
         }
         const xEnd: int = Math.min(object.xEnd + 1, planet.width - 1);
         const yEnd: int = Math.min(object.yEnd + 1, planet.height - 1);
         for (x = Math.max(object.x - 1, 0); x <= xEnd; x++) {
            for (y = Math.max(object.y - 1, 0); y <= yEnd; y++) {
               const objectUnder: MPlanetObject = planet.getObject(x, y);
               if (objectUnder != null) {
                  planet.removeObject(objectUnder);
               }
               if (TileKind.isResourceKind(planet.getTileKind(x, y))) {
                  planet.removeTile(x, y);
               }
            }
         }
         planet.addResourceTile(object.x, object.y, tile.tileKind);
         map.renderBackground(false);
      }

      private function this_mouseMoveHandler(event: MouseEvent): void {
         repositionTilePlaceholder();
         if (event.buttonDown) {
            // if not resource tile
            // add tile at current position
            // remove at current position if tile is regular
         }
      }

      private function repositionTilePlaceholder(): void {
         const logicalCoords: Point = map.coordsTransform.realToLogical(
            new Point(objectsLayer.mouseX, objectsLayer.mouseY)
         );

         // Don't do anything if object has not been moved.
         const object: MPlanetObject = _tilePlaceholder.tileObject;
         if (!object.moveTo(logicalCoords.x, logicalCoords.y)) {
            return;
         }

         objectsLayer.positionObject(_tilePlaceholder);
      }


      /* ############################### */
      /* ### INTERFACE FOR MAPEDITOR ### */
      /* ############################### */

      public function setTile(tile: IRTileKindM): void {
         _tilePlaceholder.tile = tile;
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
         if (event.keyCode == ACTIVATION_KEY_CODE) {
            activate();
         }
      }

      private function keyboard_keyUpHandler(event:KeyboardEvent): void {
         if (event.keyCode == ACTIVATION_KEY_CODE) {
            deactivate();
         }
      }

      /* ############## */
      /* ### NO-OPS ### */
      /* ############## */

      override protected function get componentClass(): Class {
         return null;
      }

      override protected function get modelClass(): Class {
         return null;
      }

      override protected function get objectsList(): ListCollectionView {
         return new ArrayCollection();
      }

      override protected function removeAllObjects(): void {
      }

      override public function objectSelected(object: IInteractivePlanetMapObject): void {
      }

      override public function objectDeselected(object: IInteractivePlanetMapObject): void {
      }

      override public function addObject(object: MPlanetObject): void {
      }

      override public function objectRemoved(object: IPrimitivePlanetMapObject): void {
      }

      override public function openObject(object: IPrimitivePlanetMapObject): void {
      }
   }
}
