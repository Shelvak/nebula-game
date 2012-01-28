package components.planetmapeditor
{
   import components.map.planet.PlanetMap;
   import components.map.planet.PlanetObjectsLayer;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;

   import flash.events.MouseEvent;

   import models.planet.MPlanet;
   import models.planet.MPlanetObject;
   import models.tile.TileKind;

   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;

   import utils.Objects;
   import utils.undo.CommandInvoker;


   public class TerrainEditorLayer extends MapEditorLayer
   {
      public function TerrainEditorLayer(initialTile: IRTileKindM,
                                         commandInvoker: CommandInvoker) {
         super();
         _initialTile = Objects.paramNotNull("initialTile", initialTile);
         _commandInvoker = Objects.paramNotNull("commandInvoker", commandInvoker);
      }

      private var _commandInvoker: CommandInvoker = null;
      private var _initialTile: IRTileKindM = null;
      private var _tilePlaceholder: CTilePlaceholder = new CTilePlaceholder();
      
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

      override protected function clickHandler(event: MouseEvent): void {
         const tile: IRTileKindM = _tilePlaceholder.tile;
         const object: MPlanetObject = _tilePlaceholder.tileObject;
         if (!planet.isObjectOnMap(object)
                || !TileKind.isResourceKind(tile.tileKind)) {
            return;
         }
         planet.forEachPointUnder(
            object, false, true,
            function(x: int, y: int): void {
               planet.removeTile(x, y);
            }
         );
         planet.forEachPointUnder(
            object, true, true,
            function(x: int, y: int): void {
               const objectUnder: MPlanetObject = planet.getObject(x, y);
               if (objectUnder != null) {
                  planet.removeObject(objectUnder);
               }
               if (TileKind.isResourceKind(planet.getTileKind(x, y))) {
                  planet.removeTile(x, y);
               }
            }
         );
         planet.addTile(tile.tileKind, object.x, object.y);
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
            planet.addTile(tile.tileKind, object.x, object.y);
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
