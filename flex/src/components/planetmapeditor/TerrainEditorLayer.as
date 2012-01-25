package components.planetmapeditor
{
   import components.map.planet.PlanetMap;
   import components.map.planet.PlanetObjectsLayer;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;

   import flash.events.MouseEvent;

   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import models.tile.Tile;
   import models.tile.TileKind;

   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;

   import utils.Objects;


   public class TerrainEditorLayer extends MapEditorLayer
   {
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


      override protected function activationKeyDown(): void {
         objectsLayer.passOverMouseEventsTo(this);
         map.viewport.contentDragEnabled = false;
         _tilePlaceholder.visible = true;
         moveObjectToMouse(_tilePlaceholder);
      }


      override protected function activationKeyUp(): void {
         _tilePlaceholder.visible = false;
         map.viewport.contentDragEnabled = true;
      }

      private var _tilePlaceholder: CTilePlaceholder = new CTilePlaceholder();

      override protected function clickHandler(event: MouseEvent): void {
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

      override protected function mouseMoveHandler(event: MouseEvent): void {
         moveObjectToMouse(_tilePlaceholder);
         const tile: IRTileKindM = _tilePlaceholder.tile;
         const object: MPlanetObject = _tilePlaceholder.tileObject;
         if (!event.buttonDown
                || !planet.isObjectOnMap(object)
                || TileKind.isResourceKind(tile.tileKind)
                || planet.getTileKind(object.x, object.y) == tile.tileKind) {
            return;
         }
         planet.removeTile(object.x, object.y);
         const objectUnder: MPlanetObject =
                  planet.getObject(object.x, object.y);
         if (objectUnder != null) {
            planet.removeObject(objectUnder);
         }
         if (tile.tileKind != TileKind.REGULAR) {
            const newTile: Tile = new Tile();
            newTile.x = object.x;
            newTile.y = object.y;
            newTile.kind = tile.tileKind;
            planet.addTile(newTile);
         }
         map.renderBackground(false);
      }


      /* ############################### */
      /* ### INTERFACE FOR MAPEDITOR ### */
      /* ############################### */

      public function setTile(tile: IRTileKindM): void {
         _tilePlaceholder.tile = tile;
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
