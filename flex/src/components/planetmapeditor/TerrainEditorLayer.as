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

      private var _currentCommand: TerrainEditCommand = null;
      private var f_active:Boolean = false;

      private function commitCurrentCommand(): void {
         if (_currentCommand != null && _currentCommand.valid) {
            _commandInvoker.addCommand(_currentCommand);
         }
         _currentCommand = null;
      }

      private function startNewCommand(): void {
         _currentCommand = new TerrainEditCommand(map, planet);
      }

      override protected function activationKeyDown(): void {
         if (f_active) {
            return;
         }
         f_active = true;
         objectsLayer.passOverMouseEventsTo(this);
         map.viewport.contentDragEnabled = false;
         _tilePlaceholder.visible = true;
         startNewCommand();
         moveObjectToMouse(_tilePlaceholder);
      }

      override protected function activationKeyUp(): void {
         if (!f_active) {
            return;
         }
         f_active = false;
         _tilePlaceholder.visible = false;
         map.viewport.contentDragEnabled = true;
         commitCurrentCommand();
      }

      override protected function clickHandler(event: MouseEvent): void {
         commitCurrentCommand();
         startNewCommand();
         const tile: IRTileKindM = _tilePlaceholder.tile;
         const object: MPlanetObject = _tilePlaceholder.tileObject;
         if (!planet.isObjectOnMap(object)) {
            return;
         }
         const tileKindAtMouse:int = planet.getTileKind(object.x, object.y);
         if (tileKindAtMouse == tile.tileKind
                && !TileKind.isResourceKind(tileKindAtMouse)) {
            return;
         }
         _currentCommand.addTile(tile.tileKind, object.x, object.y);
         commitCurrentCommand();
         startNewCommand();
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
         _currentCommand.addTile(tile.tileKind, object.x, object.y);
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


import components.map.planet.PlanetMap;
import components.planetmapeditor.MapEditCommand;

import models.building.Building;
import models.planet.MPlanet;
import models.planet.MPlanetObject;
import models.planet.Range2D;
import models.tile.Tile;
import models.tile.TileKind;

import utils.undo.ICommand;


class TerrainEditCommand extends MapEditCommand implements ICommand
{
   private var _tilesToAdd:Array = new Array();

   private function addTileToMap(kind: int, x: int, y: int): void {
      planet.addTile(kind, x, y);
      _tilesToAdd.push(planet.getTile(x, y));
   }

   function TerrainEditCommand(map: PlanetMap, planet: MPlanet) {
      super(map, planet);
   }

   private var _valid: Boolean = false;
   public function get valid(): Boolean {
      return _valid;
   }

   public function addTile(kind:int, x: int, y: int): void {
      _valid = true;
      TileKind.isResourceKind(kind)
         ? addResourceTile(kind, x, y)
         : addSimpleTile(kind, x, y);
   }

   private function addSimpleTile(kind: int, x: int, y: int): void {
      removeTileToRestore(x, y);
      const object: MPlanetObject = planet.getObject(x, y);
      if (object != null) {
         if (object is Building) {
            const building: Building = Building(object);
            if (!building.npc || building.isExtractor) {
               removeObjectToRestore(x, y);
            }
         }
         else {
            removeObjectToRestore(x, y);
         }
      }
      if (kind != TileKind.REGULAR) {
         addTileToMap(kind, x, y);
      }
   }

   private function addResourceTile(kind: int, x: int, y: int): void {
      planet.forEachPointIn(
         [new Range2D(x, x + 1, y, y + 1)], false,
         function(x: int, y: int): void {
            removeTileToRestore(x, y);
         }
      );
      const gap: int = Building.GAP_BETWEEN;
      planet.forEachPointIn(
         [new Range2D(x - gap, x + 1 + gap, y - gap, y + 1 + gap)], true,
         function(x: int, y: int): void {
            removeObjectToRestore(x, y);
            if (TileKind.isResourceKind(planet.getTileKind(x, y))) {
               removeTileToRestore(x, y);
            }
         }
      );
      addTileToMap(kind, x, y);
   }

   public function execute(): void {
      const tiles: Array = _tilesToAdd;
      _tilesToAdd = new Array();
      for each (var tile: Tile in tiles) {
         addTile(tile.kind, tile.x, tile.y);
      }
      map.renderBackground(false);
   }

   public function undo(): void {
      for each (var tile: Tile in _tilesToAdd) {
         planet.removeTile(tile.x, tile.y);
      }
      restoreRemoved();
   }
}